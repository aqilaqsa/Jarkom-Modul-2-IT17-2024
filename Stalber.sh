#13 - worker

echo nameserver 192.168.122.1 > /etc/resolv.conf

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
    DocumentRoot /var/www/html/stalber
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>' >/etc/apache2/sites-available/000-default.conf

mkdir -p /var/www/html/stalber

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
?>' >/var/www/html/stalber/index.php

# 14 - worker nginx

apt-get update
apt-get install nginx php-fpm php -y
service apache2 stop
service nginx stop

echo 'server {
    listen 80;
    server_name 10.72.1.3;

    root /var/www/html/stalber;
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

    error_log /var/log/nginx/stalber_error.log;
    access_log /var/log/nginx/stalber_access.log;
}' >/etc/nginx/sites-available/stalber

ln -s /etc/nginx/sites-available/stalber /etc/nginx/sites-enabled/

mkdir -p /var/www/html/stalber

echo '<?php
$hostname = gethostname();
$date = date("Y-m-d H:i:s");
$php_version = phpversion();
$username = get_current_user();

echo "Hello World from Stalber!<br>";
echo "Saya adalah: $username<br>";
echo "Saat ini berada di: $hostname<br>";
echo "Versi PHP yang saya gunakan: $php_version<br>";
echo "Tanggal saat ini: $date<br>";
?>' >/var/www/html/stalber/index.php

chown -R www-data:www-data /var/www/html/stalber
chmod -R 755 /var/www/html/stalber

service php7.0-fpm start
systemctl enable php7.0-fpm

service nginx restart
service nginx status