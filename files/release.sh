#!/bin/bash
# Release new feature, Idempotent, instantaneous and ACID.
# Arguments <project>

TIMESTART=$(date +%s);
DATE=$(date);
BASEDIR=$(dirname $0);
HOSTNAME=$(hostname);
PROJECT=$1
VERSION=$2

echo "Arguments: $@";

if [ -z $PROJECT ]; then
    echo "No project was provided.";
    exit 0;
fi

if [ -z $VERSION ]; then
    echo "No version was provided.";
    exit 0;
fi

SITEROOT="/var/www/$PROJECT";
cd $SITEROOT;
if [[ -L app ]] && [[ -d current/.git ]] && [[ "$(readlink app)" = "current" ]]; then
    SITEROOT="/var/www/$PROJECT";
fi

echo "Releasing version $VERSION on $HOSTNAME:$SITEROOT at $DATE";

if [[ -L app ]] && [[ -d current/.git ]] && [[ "$(readlink app)" = "current" ]]; then
    if [ -f .lock ]; then
        echo "Locked, please wait until the current operation ends.";
    else
        echo "Locking the $SITEROOT to perform the operation";
        touch .lock;

        rm -rf new;
        mkdir -p new;
        rsync -aA current/ new/;

        cd new;
        echo "Pulling lastest code from Prod ..."
        git checkout master;
        git fetch --all -p;
        PULLRESULT=$(git pull 2>&1);
        echo "$PULLRESULT";
        UPTODATE=$(echo $PULLRESULT | grep "Already up-to-date.");

        if [ -z "$UPTODATE" ]; then
            CURRENTVERSION=$(git describe --dirty --always --abbrev=0 --tags 2>&1 | grep 'v');
            if [ "$CURRENTVERSION" == "$VERSION" ]; then
                #TODO: remove out of retention period branches
                git checkout tags/$VERSION -b release-$VERSION

                echo "Regenerating autoloads ..."
                php bin/php/ezpgenerateautoloads.php -e > /dev/null 2>&1;
                php bin/php/ezpgenerateautoloads.php -o > /dev/null 2>&1;

                echo "Clearing cache ...";
                php bin/php/ezcache.php --clear-id=content,ini,codepage,template,template-block,template-override,ezjscore-packer,translation > /dev/null 2>&1;
                cd ..;

                echo "New release symlink";
                ln -sf new latest;

                #TODO: pre-generate cache, create a new VHwith access restriction and use wget or curl with a URLs text file to create cache.

                echo "Publishing the new release $VERSION"
                mv -T latest app;

                #TODO: Purge Varnish

                echo "Saving the previous release";
                rm -rf previous;
                mv current previous;

                echo "Renaming the new release to current";
                mkdir -p current;
                rsync -a new/ current/;
                ln -sf current tmp_app;
                mv -T tmp_app app;
            else
              echo "Current version $CURRENTVERSION is not equal to release version $VERSION";
            fi
        else
            echo "Nothing new to release";
        fi

        cd $SITEROOT;
        rm -rf new;

        echo "Unlocking the $SITEROOT directory";
        rm .lock
    fi
else
    echo "Release directories on $SITEROOT are not properly installed.";
fi

echo "";
TIMEEND=$(date +%s);
TIMEDIFF=$(( $TIMEEND - $TIMESTART ));
echo "Process ended in $TIMEDIFF seconds.";
echo "End of the process.";

exit 0;
