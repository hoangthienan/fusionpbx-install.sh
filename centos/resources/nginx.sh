#!/bin/sh

. resources/colors.sh

#send a message
verbose "Install the web server"

systemctl stop httpd
systemctl disable httpd

cp resources/nginx/nginx.repo /etc/yum.repos.d/nginx.repo

#install dependencies
yum install -y nginx php php-cli php-fpm php-pgsql php-odbc php-curl php-imap php-mcrypt

#enable fusionpbx nginx config
cp resources/nginx/fusionpbx.conf /etc/nginx/conf.d/fusionpbx.conf
rm -rf /etc/nginx/conf.d/default.conf

#mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled
#cp resources/nginx/fusionpbx /etc/nginx/sites-available/fusionpbx
#ln -s /etc/nginx/sites-available/fusionpbx /etc/nginx/sites-enabled/fusionpbx

#self signed certificate
verbose "Self signed certificate"

mkdir -p /etc/ssl/private
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-openssl.key -out /etc/ssl/certs/ssl-cert-openssl.crt

#ln -s /etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/private/nginx.key
#ln -s /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/certs/nginx.crt
ln -s /etc/ssl/private/ssl-cert-openssl.key /etc/ssl/private/nginx.key
ln -s /etc/ssl/certs/ssl-cert-openssl.crt /etc/ssl/certs/nginx.crt

#remove the default site
#rm /etc/nginx/sites-enabled/default

sed -i /etc/php-fpm.d/www.conf -e s:'listen = 127.0.0.1\:9000:;listen = 127.0.0.1\:9000:'
sed -i /etc/php-fpm.d/www.conf -e s:'user = apache:user = nginx:'
sed -i /etc/php-fpm.d/www.conf -e s:'group = apache:group = nginx:'

echo listen = /var/run/php-fpm/php-fpm.sock >> /etc/php-fpm.d/www.conf