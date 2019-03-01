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
sed -i "s/# groot=LABEL=cloudimg-rootfs/# groot=(hd0)/g" /boot/grub/menu.lst
eval update-grub-legacy-ec2 $l
eval apt update $l
eval apt upgrade $l
eval apt install mysql-server ironic-api ironic-conductor python-ironicclient -y $l
date | md5sum | cut -c 1-12 > /root/.mysql_password
exit
echo "CREATE DATABASE ironic CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON ironic.* TO 'ironic'@'localhost' IDENTIFIED BY '$(cat /root/.mysql_password)';
GRANT ALL PRIVILEGES ON ironic.* TO 'ironic'@'%' IDENTIFIED BY '$(cat /root/.mysql_password)';" >/root/mysql_config.sqlievi
eval mysql -u root < /root/mysql_config.sql $l
