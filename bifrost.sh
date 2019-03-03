#!/bin/bash
log='/root/post_install.txt'
lr=' 2>> '$log
l=' >> '$log$lr
eval echo "Starting - before firewall" $l
echo '#!/bin/bash
iptables -F
iptables -P INPUT DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -s 80.68.235.230 -j ACCEPT
iptables -A INPUT -s 10.180.0.0/22 -j ACCEPT' >/root/rc.firewall
chmod 755 /root/rc.firewall
/root/rc.firewall
eval timedatectl set-timezone Europe/Oslo $l
eval date $l
eval mkdir /root/.ssh
eval "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9Rv7mjUkhhKAXp/FORWCLoKtr3Wkp+CL8e+FfsG0sGcGIDHPaRJ2mHoxpnIeqMKsYKnq5VeOqhEUlNYnjehrRayrUixCNWiO1ZPAilj0DgjBnykOJq40Qn+FFtRT5jks4Jd+kiXtMnhUcEB5/jx2DBYApEYmTa0fsJtmh6WhXRfQAPioISOQZtaEMAxSrwTOGjldp7Z+qjEDt6DySTBozfpIPDvzY/qBAn1HaD7NwLN2/4PoBrbw4kp74APCDciW1ynkVIFoelzoAAWo73ZFq5PdhEq01dkY8a8DM11OFWlW0o7EnypscIZtD1dzxHPlj7h/+usSf3uXPBRc18F3x kris@Krzysztofs-MBP' > /root/.ssh/authorized_keys $lr"
eval chmod 600 /root/.ssh $l
eval chmod 400 /root/.ssh/authorized_keys $l
cd /root
[ -f bionic-server-cloudimg-amd64.img ] || wget http://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img
sed -i "s/# groot=LABEL=cloudimg-rootfs/# groot=(hd0)/g" /boot/grub/menu.lst
eval update-grub-legacy-ec2 $l
eval echo "before export" $l
export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical
eval echo "before update" $l
eval apt-get -qy update $l
eval echo "before upgrade" $l
eval apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade $l
eval echo "before autoclean" $l
eval apt-get -qy autoclean $l
eval echo "before rc.local" $l
echo '#!/bin/bash
/root/rc.firewall
apt-get -qy update
apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade
apt-get -qy autoclean
dpkg --configure -a
apt install python-pip tftpd -y
pip install -U pip ansible softlayer bifrost
git clone https://git.openstack.org/openstack/bifrost.git
echo 'service tftp
{
protocol        = udp
port            = 69
socket_type     = dgram
wait            = yes
user            = nobody
server          = /usr/sbin/in.tftpd
server_args     = /tftpboot
disable         = no
}' > /etc/xinet.d/tftp
head -n 2 /etc/rc.local >/etc/rc.local1
mv /etc/rc.local1 /etc/rc.local
chmod 755 /etc/rc.local' > /etc/rc.local
chmod 755 /etc/rc.local
systemctl enable rc-local
eval echo 'End' $l
eval systemctl reboot $l
