#!/bin/bash
log='/root/post_install.txt'
lr=' 2>> '$log
l=' >> '$log$lr
eval timedatectl set-timezone Europe/Oslo $l
cd /root
eval mkdir /root/.ssh
eval date $l
eval "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9Rv7mjUkhhKAXp/FORWCLoKtr3Wkp+CL8e+FfsG0sGcGIDHPaRJ2mHoxpnIeqMKsYKnq5VeOqhEUlNYnjehrRayrUixCNWiO1ZPAilj0DgjBnykOJq40Qn+FFtRT5jks4Jd+kiXtMnhUcEB5/jx2DBYApEYmTa0fsJtmh6WhXRfQAPioISOQZtaEMAxSrwTOGjldp7Z+qjEDt6DySTBozfpIPDvzY/qBAn1HaD7NwLN2/4PoBrbw4kp74APCDciW1ynkVIFoelzoAAWo73ZFq5PdhEq01dkY8a8DM11OFWlW0o7EnypscIZtD1dzxHPlj7h/+usSf3uXPBRc18F3x kris@Krzysztofs-MBP' >> /root/.ssh/authorized_keys $lr"
eval chmod 600 /root/.ssh $l
eval chmod 400 /root/.ssh/authorized_keys $l
yum install vim git python-setuptools epel-release -y
easy_install pip
pip install ansible
git clone https://git.openstack.org/openstack/bifrost.git
cd /root/bifrost
pip install -r requirements.txt
cd /root/bifrost/playbooks
sed -i 's/# network_interface: "virbr0"/network_interface: "eth0"/g' /root/bifrost/playbooks/inventory/group_vars/target
ansible-playbook -i inventory/target install.yaml
