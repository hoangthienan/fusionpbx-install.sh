#!/bin/sh

. resources/colors.sh

#send a message
verbose "Configure PHP"

#update config if source is being used
sed 's#post_max_size = .*#post_max_size = 80M#g' -i /etc/php.ini
sed 's#upload_max_filesize = .*#upload_max_filesize = 80M#g' -i /etc/php.ini

#restart php-fpm
#systemd
/bin/systemctl restart php-fpm

#init.d
#/usr/sbin/service php-fpm restart
