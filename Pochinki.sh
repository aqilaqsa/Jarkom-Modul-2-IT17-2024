#Pochinki

echo 'nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install bind9 -y

# 2
echo 'zone "airdrop.IT17.com" {
        type master;
        file "/etc/bind/jarkom/airdrop.IT17.com";
};' > /etc/bind/named.conf.local

mkdir /etc/bind/jarkom

cp /etc/bind/db.local /etc/bind/jarkom/airdrop.IT17.com

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     airdrop.IT17.com. root.airdrop.IT17.com. (
                        2024050301      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      airdrop.IT17.com.
@       IN      A       10.72.1.3
www     IN      CNAME   airdrop.IT17.com.' > /etc/bind/jarkom/airdrop.IT17.com

service bind9 restart

# 3
echo 'zone "redzone.IT17.com" {
        type master;
        file "/etc/bind/jarkom/redzone.IT17.com";
};' > /etc/bind/named.conf.local

cp /etc/bind/db.local /etc/bind/jarkom/redzone.IT17.com

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     redzone.IT17.com. root.redzone.IT17.com. (
                        2024050301      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      redzone.IT17.com.
@       IN      A       10.72.1.4
www     IN      CNAME   redzone.IT17.com.' > /etc/bind/jarkom/redzone.IT17.com

service bind9 restart

# 4
echo 'zone "loot.IT17.com" {
        type master;
        file "/etc/bind/jarkom/loot.IT17.com";
};' >> /etc/bind/named.conf.local

cp /etc/bind/db.local /etc/bind/jarkom/loot.IT17.com

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     loot.IT17.com. root.loot.IT17.com. (
                        2024050301      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      loot.IT17.com.
@       IN      A       10.72.2.4
www     IN      CNAME   loot.IT17.com.' > /etc/bind/jarkom/loot.IT17.com

service bind9 restart

# 6

echo 'zone "1.72.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/1.72.10.in-addr.arpa";
};' >> /etc/bind/named.conf.local

mkdir -p /etc/bind/jarkom

cp /etc/bind/db.local /etc/bind/jarkom/1.72.10.in-addr.arpa

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     redzone.IT17.com. root.redzone.IT17.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
1.72.10.in-addr.arpa.   IN      NS      redzone.IT17.com.
4                       IN      PTR     redzone.IT17.com.
' > /etc/bind/jarkom/1.72.10.in-addr.arpa

# service bind9 restart

# 7
echo 'zone "airdrop.IT17.com" {
        type master;
        file "/etc/bind/jarkom/airdrop.IT17.com";
        allow-transfer { 10.72.2.3; };
        also-notify { 10.72.2.3; };
};' > /etc/bind/named.conf.local

echo 'zone "redzone.IT17.com" {
        type master;
        file "/etc/bind/jarkom/redzone.IT17.com";
        also-notify { 10.72.2.3; }; // Masukan IP Water7 tanpa tanda petik
        allow-transfer { 10.72.2.3; }; // Masukan IP Water7 tanpa tanda petik
};' >> /etc/bind/named.conf.local

echo 'zone "loot.IT17.com" {
        type master;
        file "/etc/bind/jarkom/loot.IT17.com";
        also-notify { 10.72.2.3; }; // Masukan IP Water7 tanpa tanda petik
        allow-transfer { 10.72.2.3; }; // Masukan IP Water7 tanpa tanda petik
};' >> /etc/bind/named.conf.local

service bind9 restart

# 8
echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     airdrop.IT17.com. root.airdrop.IT17.com. (
                        2023101001      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      airdrop.IT17.com.
@       IN      A       10.72.1.3
www     IN      CNAME   airdrop.IT17.com.
medkit  IN      A       10.72.1.2' > /etc/bind/jarkom/airdrop.IT17.com

service bind9 restart

# 9
echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     redzone.IT17.com. root.redzone.IT17.com. (
                        2023101001      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      redzone.IT17.com.
@       IN      A       10.72.1.4
www     IN      CNAME   redzone.IT17.com.
ns1     IN      A       10.72.2.3' > /etc/bind/jarkom/redzone.IT17.com

echo "options {
    directory \"/var/cache/bind\";

    // If there is a firewall between you and nameservers you want
    // to talk to, you may need to fix the firewall to allow multiple
    // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

    // If your ISP provided one or more IP addresses for stable
    // nameservers, you probably want to use them as forwarders.
    // Uncomment the following block, and insert the addresses replacing
    // the all-0's placeholder.
    // };

    //========================================================================
    // If BIND logs error messages about the root key being expired,
    // you will need to update your keys.  See https://www.isc.org/bind-keys
    //========================================================================
    //dnssec-validation auto;

    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};" > /etc/bind/named.conf.options

# service bind9 restart

#11
echo 'options {
    directory "/var/cache/bind";

    // If there is a firewall between you and nameservers you want
    // to talk to, you may need to fix the firewall to allow multiple
    // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

    // If your ISP provided one or more IP addresses for stable
    // nameservers, you probably want to use them as forwarders.
    // Uncomment the following block, and insert the addresses replacing
    // the all-0s placeholder.
    forwarders {
        192.168.122.1;
    };

    //========================================================================
    // If BIND logs error messages about the root key being expired,
    // you will need to update your keys.  See https://www.isc.org/bind-keys
    //========================================================================
    //dnssec-validation auto;

    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};' > /etc/bind/named.conf.options

service bind9 restart

