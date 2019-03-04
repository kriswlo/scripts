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
iptables -A INPUT -s 10.180.0.0/22 -j ACCEPT
iptables -A INPUT -p udp --dp 67 -j ACCEPT' >/root/rc.firewall
chmod 755 /root/rc.firewall
eval /root/rc.firewall $l
eval timedatectl set-timezone Europe/Oslo $l
eval date $l
eval mkdir /root/.ssh $l
eval "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9Rv7mjUkhhKAXp/FORWCLoKtr3Wkp+CL8e+FfsG0sGcGIDHPaRJ2mHoxpnIeqMKsYKnq5VeOqhEUlNYnjehrRayrUixCNWiO1ZPAilj0DgjBnykOJq40Qn+FFtRT5jks4Jd+kiXtMnhUcEB5/jx2DBYApEYmTa0fsJtmh6WhXRfQAPioISOQZtaEMAxSrwTOGjldp7Z+qjEDt6DySTBozfpIPDvzY/qBAn1HaD7NwLN2/4PoBrbw4kp74APCDciW1ynkVIFoelzoAAWo73ZFq5PdhEq01dkY8a8DM11OFWlW0o7EnypscIZtD1dzxHPlj7h/+usSf3uXPBRc18F3x kris@Krzysztofs-MBP' > /root/.ssh/authorized_keys $lr"
eval chmod 600 /root/.ssh $l
eval chmod 400 /root/.ssh/authorized_keys $l
