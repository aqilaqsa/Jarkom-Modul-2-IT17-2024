echo -e '
nameserver 10.72.3.2
nameserver 10.72.2.3
nameserver 192.168.122.1
' > /etc/resolv.conf

apt-get update
apt-get install dnsutils -y
apt-get install lynx -y

ping google.com -c 5