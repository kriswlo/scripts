#!/bin/bash
log=/root/post_install.txt
lr=" 2>> $log"
l=" >> $log$lr"

init() {
 eval timedatectl set-timezone Europe/Oslo $l
 eval date $l
 eval echo "Starting - before firewall" $l
 echo "#!/bin/bash
 iptables -F
 iptables -P INPUT DROP
 iptables -A INPUT -i lo -j ACCEPT
 iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
 iptables -A INPUT -s 195.212.29.0/24 -j ACCEPT
 iptables -A INPUT -s 80.68.235.230 -j ACCEPT
 iptables -A INPUT -s 10.180.0.0/22 -j ACCEPT
 iptables -A INPUT -i eth0 -p udp --dp 67 -j ACCEPT
 iptables -A INPUT -i eth0 -p udp --dp 69  -j ACCEPT" >/root/rc.firewall
 chmod 755 /root/rc.firewall
 /root/rc.firewall
 eval mkdir /root/.ssh $l
 eval "echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9Rv7mjUkhhKAXp/FORWCLoKtr3Wkp+CL8e+FfsG0sGcGIDHPaRJ2mHoxpnIeqMKsYKnq5VeOqhEUlNYnjehrRayrUixCNWiO1ZPAilj0DgjBnykOJq40Qn+FFtRT5jks4Jd+kiXtMnhUcEB5/jx2DBYApEYmTa0fsJtmh6WhXRfQAPioISOQZtaEMAxSrwTOGjldp7Z+qjEDt6DySTBozfpIPDvzY/qBAn1HaD7NwLN2/4PoBrbw4kp74APCDciW1ynkVIFoelzoAAWo73ZFq5PdhEq01dkY8a8DM11OFWlW0o7EnypscIZtD1dzxHPlj7h/+usSf3uXPBRc18F3x kris@Krzysztofs-MBP > /root/.ssh/authorized_keys $lr"
 eval chmod 600 /root/.ssh $l
 eval chmod 400 /root/.ssh/authorized_keys $l
}

apt_up() {
 sed -i "s/# groot=LABEL=cloudimg-rootfs/# groot=(hd0)/g" /boot/grub/menu.lst
 update-grub-legacy-ec2
 export DEBIAN_FRONTEND=noninteractive
 export DEBIAN_PRIORITY=critical
 apt-get -qy update
 apt-get --force-yes -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade
 apt-get -qy autoclean
 dpkg --configure -a
 apt upgrade -y
 #apt dist-upgrade -y
}

soft() {
 cd /root
 #[ -f bionic-server-cloudimg-amd64.img ] || wget http://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img
 apt install python-pip -y
 pip install ansible
 git clone https://git.openstack.org/openstack/bifrost.git
 cd /root/bifrost
 bash ./scripts/env-setup.sh
 export PATH=${HOME}/.local/bin:${PATH}
 cd /root/bifrost/playbooks
 for i in baremetal  localhost  target
  do
   sed -i 's/# network_interface: "virbr0"/network_interface: "eth0"/g' /root/bifrost/playbooks/inventory/group_vars/$i
  done
 ansible-playbook -i inventory/target install.yaml
}


case "$1" in
apt_up)         apt_up
                ;;
soft)       	soft
                ;;
conf)       	conf
                ;;
*)              init
                apt_up
                soft
                ;;
esac

exit
