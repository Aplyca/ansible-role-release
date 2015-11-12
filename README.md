Ansible Role Release
====================

An Ansible role that releases code

[![Build Status](https://travis-ci.org/Aplyca/ansible-role-release.svg?branch=master)](https://travis-ci.org/Aplyca/ansible-role-release)
[![Circle CI](https://circleci.com/gh/Aplyca/ansible-role-release.svg?style=svg)](https://circleci.com/gh/Aplyca/ansible-role-release)

Ansible Role that releases code on Debian/Ubuntu.

Requirements
------------

Use hash behavior for variables in ansible.cfg
See example: https://github.com/Aplyca/ansible-role-release/blob/master/tests/ansible.cfg
See official docs: http://docs.ansible.com/intro_configuration.html#hash-behaviour

Installation
------------

Using ansible galaxy:
```bash
ansible-galaxy install aplyca.Release
```
You can add this role as a dependency for other roles, add the role to the meta/main.yml file of your own role:
```yaml
dependencies:
  - { role: aplyca.Release }
```

Role Variables
--------------
See default variables: https://github.com/Aplyca/ansible-role-release/blob/master/defaults/main.yml

Dependencies
------------

- Git

None.

Testing
-------
Using Vagrant:

```bash
tests/vagrant.sh
```

Using Docker:

```bash
tests/docker.sh
```

License
-------

MIT / BSD

Author Information
------------------

Mauricio Sánchez from Aplyca SAS (http://www.aplyca.com)
