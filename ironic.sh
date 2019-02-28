#!/bin/bash
sed -i "s/# groot=LABEL=cloudimg-rootfs/# groot=(hd0)/g" /boot/grub/menu.lst
update-grub-legacy-ec2 
apt update
apt upgrade
apt install mysql-server -y
