# apache load balancer
# apt-get update
# apt-get install apache2
# apt-get install lynx
# service apache2 start

# a2enmod proxy
# a2enmod proxy_http
# a2enmod proxy_balancer
# a2enmod lbmethod_byrequests

# service apache2 restart
# service apache2 status

# echo '<VirtualHost *:80>
#    <Proxy balancer://mycluster>
# BalancerMember http://10.72.1.4:80
# BalancerMember http://10.72.1.2:80
#       BalancerMember http://10.72.1.3:80
#     </Proxy>
#     ProxyPreserveHost On
#     ProxyPass / balancer://mycluster/
#     ProxyPassReverse / balancer://mycluster/
# </VirtualHost>' >/etc/apache2/sites-available/000-default.conf

# service apache2 restart
# service apache2 status
# service apache2 start

# Nginx Load Balancer Setup
apt-get update
apt-get install nginx -y

cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak

cat > /etc/nginx/sites-available/default <<EOF
upstream myapp {
    server 10.72.1.4:80;
    server 10.72.1.2:80;
    server 10.72.1.3:80;
}

server {
    listen 80;
    server_name mylta.xxx.com www.mylta.xxx.com;

    location / {
        proxy_pass http://myapp;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

nginx -t
service nginx restart
service nginx status
