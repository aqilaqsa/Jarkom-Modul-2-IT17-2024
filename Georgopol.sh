# Georgopol

echo 'nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install bind9 -y

#7
echo 'zone "airdrop.IT17.com" {
    type slave;
    masters { 10.72.3.2; }; // Masukan IP EniesLobby tanpa tanda petik
    file "/var/lib/bind/airdrop.IT17.com";
};

zone "redzone.IT17.com" {
    type slave;
    masters { 10.72.3.2; }; // Masukan IP EniesLobby tanpa tanda petik
    file "/var/lib/bind/redzone.IT17.com";
};

zone "loot.IT17.com" {
    type slave;
    masters { 10.72.3.2; }; // Masukan IP EniesLobby tanpa tanda petik
    file "/var/lib/bind/loot.IT17.com";
};' > /etc/bind/named.conf.local

#9
echo 'options {
        directory "/var/cache/bind";
        allow-query{any;};
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};' > /etc/bind/named.conf.options

echo 'zone "siren.redzone.IT17.com"{
        type master;
        file "/etc/bind/siren/siren.redzone.IT17.com";
};' >> /etc/bind/named.conf.local

mkdir /etc/bind/siren

echo '$TTL    604800
@       IN      SOA     siren.redzone.IT17.com. root.siren.redzone.IT17.com. (
                        2021100401      ; Serial
                        604800         ; Refresh
                        86400         ; Retry
                        2419200         ; Expire
                        604800 )       ; Negative Cache TTL
;
@               IN      NS      siren.redzone.IT17.com.
@               IN      A       10.72.1.4       ;ip skypie
www             IN      CNAME   siren.redzone.IT17.com.' > /etc/bind/siren/siren.redzone.IT17.com

#service bind9 restart

#10
echo '$TTL    604800
@       IN      SOA     siren.redzone.IT17.com. root.siren.redzone.IT17.com. (
                        2021100401      ; Serial
                        604800         ; Refresh
                        86400         ; Retry
                        2419200         ; Expire
                        604800 )       ; Negative Cache TTL
;
@               IN      NS      siren.redzone.IT17.com.
@               IN      A       10.72.1.4       ;
www             IN      CNAME   siren.redzone.IT17.com.
log             IN      A       10.72.1.4      ;
www.log         IN      CNAME   log.siren.redzone.IT17.com.' > /etc/bind/siren/siren.redzone.IT17.com

service bind9 restart