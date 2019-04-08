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
apt install python-pip make -y
pip install -U pip ansible -y
git clone https://git.openstack.org/openstack/bifrost.git
cd /root/bifrost
bash ./scripts/env-setup.sh
export PATH=${HOME}/.local/bin:${PATH}
cd /root/bifrost/playbooks
# adjust interfaces!
for i in baremetal  localhost  target
  do
   sed -i 's/# network_interface: "virbr0"/network_interface: "eth0"/g' /root/bifrost/playbooks/inventory/group_vars/$i
done
# jessie no longer available there
sed -i 's/dib_os_release: "jessie"/dib_os_release: "stretch"/g' /root/bifrost/playbooks/roles/bifrost-create-dib-image/tasks/main.yml
# adjust dhcp pool
apt remove resolvconf -y
ansible-playbook -i inventory/target install.yaml -e "dhcp_pool_start=10.180.112.92 dhcp_pool_end=10.180.112.92" > /root/bifrost_install.txt 2>&1
