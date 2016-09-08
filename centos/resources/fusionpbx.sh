#!/bin/sh

. resources/colors.sh

#send a message
verbose "Install FusionPBX"

#install dependencies
yum install -y vim git dbus haveged
yum install -y ghostscript libtiff-devel libtiff-tools

#get the source code
git clone https://github.com/fusionpbx/fusionpbx.git /var/www/fusionpbx
chown -R nginx:nginx /var/www/fusionpbx
