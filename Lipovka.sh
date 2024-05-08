# 13 - worker
echo 'nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install apache2
apt-get install nginx php-fpm php -y
apt-get install nginx
apt-get install lynx
apt-get install php libapache2-mod-php

service apache2 restart
service apache2 status
service apache2 start

echo '<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/lipovka
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>' >/etc/apache2/sites-available/000-default.conf

mkdir -p /var/www/html/lipovka

echo '<?php
$hostname = gethostname();
$date = date("Y-m-d H:i:s");
$php_version = phpversion();
$username = get_current_user();

echo "Hello World!<br>";
echo "Saya adalah: $username<br>";
echo "Saat ini berada di: $hostname<br>";
echo "Versi PHP yang saya gunakan: $php_version<br>";
echo "Tanggal saat ini: $date<br>";
?>' >/var/www/html/lipovka/index.php

# 14 - worker nginx

apt-get update
apt-get install nginx php-fpm php -y
service nginx stop

cd /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/sites-available

echo 'server {
    listen 80;
    server_name 10.72.1.2;

    root /var/www/html/lipovka;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    error_log /var/log/nginx/lipovka_error.log;
    access_log /var/log/nginx/lipovka_access.log;
}' >/etc/nginx/sites-available/lipovka

ln -s /etc/nginx/sites-available/lipovka /etc/nginx/sites-enabled/

mkdir -p /var/www/html/lipovka

echo '<?php
$hostname = gethostname();
$date = date("Y-m-d H:i:s");
$php_version = phpversion();
$username = get_current_user();

echo "Hello World from Lipovka!<br>";
echo "Saya adalah: $username<br>";
echo "Saat ini berada di: $hostname<br>";
echo "Versi PHP yang saya gunakan: $php_version<br>";
echo "Tanggal saat ini: $date<br>";
?>' >/var/www/html/lipovka/index.php

chown -R www-data:www-data /var/www/html/lipovka
chmod -R 755 /var/www/html/lipovka

service php7.0-fpm start
systemctl enable php7.0-fpm

service nginx restart
service nginx status

#19
# Install wget and unzip
apt-get update
apt-get install wget unzip -y

# Download the file using wget
wget -O file.zip "https://drive.google.com/uc?export=download&id=11S6CzcvLG$
# Unzip the downloaded file
unzip file.zip

# Cleanup: remove the downloaded zip file
rm file.zip

#!/bin/bash

# Nama direktori target
TARGET_DIR="/root/worker2"

# Periksa apakah direktori target ada
if [ -d "$TARGET_DIR" ]; then
    echo "Direktori $TARGET_DIR ditemukan."
else
    echo "Direktori $TARGET_DIR tidak ditemukan. Membuat direktori..."
    mkdir -p "$TARGET_DIR"
fi

# Tampilkan isi direktori target
echo "Listing isi direktori $TARGET_DIR:"
ls -la "$TARGET_DIR"

# 20
#!/bin/bash

ZONE_NAME="tamat.IT17.com"
ZONE_FILE="/etc/bind/jarkom/${ZONE_NAME}"
ZONE_CONF="/etc/bind/named.conf.local"

IP_ADDRESS="10.72.1.2"
TTL="604800"

mkdir -p /etc/bind/jarkom

if ! grep -q "$ZONE_NAME" "$ZONE_CONF"; then
    echo "Menambahkan zona $ZONE_NAME ke $ZONE_CONF"
    echo "
zone \"$ZONE_NAME\" {
    type master;
    file \"$ZONE_FILE\";
};" >> "$ZONE_CONF"
else
    echo "Zona $ZONE_NAME sudah ada di $ZONE_CONF"
fi

echo "Menyiapkan file zona untuk $ZONE_NAME"
cat <<EOF > "$ZONE_FILE"
;
; BIND data file for local loopback interface
;
\$TTL    $TTL
@       IN      SOA     $ZONE_NAME. root.$ZONE_NAME. (
                        $(date +%Y%m%d%H) ; Serial
                         $TTL            ; Refresh
                          86400          ; Retry
                        2419200          ; Expire
                         604800 )        ; Negative Cache TTL
;
@       IN      NS      $ZONE_NAME.
@       IN      A       $IP_ADDRESS
www     IN      CNAME   $ZONE_NAME.
EOF

named-checkconf
named-checkzone "$ZONE_NAME" "$ZONE_FILE"

mv /root/worker2 /var/www/html

chown -R nginx:nginx /var/www/html/worker2
chmod -R 755 /var/www/html/worker2

echo '
server {
    listen 80;
    server_name tamat.IT17.com www.tamat.IT17.com;

    root /var/www/html/worker2;
    index index.html;

    location / {
        autoindex on;
    }

    error_log /var/log/nginx/tamat_IT17_error.log;
    access_log /var/log/nginx/tamat_IT17_access.log;
}' > /etc/nginx/sites-available/tamat.IT17.com

service bind9 restart

echo "Konfigurasi selesai untuk $ZONE_NAME dengan alias www.$ZONE_NAME dan IP $IP_ADDRESS"