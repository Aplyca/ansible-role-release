Vagrant.configure(2) do |config|

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  config.vm.define "ansible_release.vagrant", primary: true, autostart: true do |config_machine|
      #Assigning a provider
      config_machine.vm.provider :virtualbox do |virtualbox, override|
        virtualbox.name = "Vagrant Ansible Release"
        #override.vm.box = "chef/centos-7.0"
	      #override.vm.box = "ubuntu/trusty64"
	      override.vm.box = "ubuntu/xenial64"
      end

      # Asinging a provisioner
      config_machine.vm.provision :ansible, run: "always" do |provisioner|
          provisioner.playbook = "playbooks.yml"
          provisioner.extra_vars = "tests/test.yml" if File.file?("tests/test.yml")
          provisioner.raw_arguments = ["-e ansible_python_interpreter=/usr/bin/python3"]
          provisioner.verbose = "vv"
          #provisioner.tags = "vars"
      end
  end
end
