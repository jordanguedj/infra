# infra
Infrastructure repository for my personal use.

## Usage
### To run using the Ansible inventory:
```
$ ansible-playbook -i production.ini site.yml
```

### To run against a Vagrant test box (running on [centos/7](https://app.vagrantup.com/centos/boxes/7)):
```
$ vagrant up # from the root directory
```

This will bring the box up and will run the Ansible provisioner.

This command will only run the provisioner:
```
$ vagrant provision
```
