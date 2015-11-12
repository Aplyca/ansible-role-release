#!/usr/bin/python

def main():
    types = ['major', 'minor', 'patch']
    module = AnsibleModule(
        argument_spec = dict(
            type=dict(default="patch", required=False, choices=types),
            version=dict(required=True),
            prefix=dict(required=False),
        ),
        supports_check_mode=False
    )

    type = module.params['type']
    prefix = module.params['prefix']
    version = module.params['version']

    try:
        version_list = dict(zip(types, version.lstrip(prefix).split('.')))
        if not version or len(version_list) != len(types):
            raise Exception('Invalid version format', version)

        version_list[type] = str(int(version_list[type]) + 1)
        new_version = prefix+'.'.join(list(version_list.values()))

    except Exception as error:
        module.fail_json(msg=error.args[0])

    module.exit_json(changed=False, version=new_version)

# import module snippets
from ansible.module_utils.basic import *
from ansible.module_utils.known_hosts import *

if __name__ == '__main__':
    main()
