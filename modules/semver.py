#!/usr/bin/python

def main():
    module = AnsibleModule(
        argument_spec = dict(
            type=dict(default="patch", required=False, choices=['patch', 'minor', 'major']),
            version=dict(required=True),
            prefix=dict(required=False),
        ),
        supports_check_mode=False
    )

    type = module.params['type']
    prefix = module.params['prefix']
    version = module.params['version']

    try:
        new_version = "1.0.1"

    except Exception as error:
        module.fail_json(msg=error.args[0])

    module.exit_json(changed=False, version=new_version)

# import module snippets
from ansible.module_utils.basic import *
from ansible.module_utils.known_hosts import *

if __name__ == '__main__':
    main()
