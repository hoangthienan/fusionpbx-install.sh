#!/bin/sh

. resources/colors.sh

verbose "Copy the switch conf files to /etc/freeswitch"

if [ -d /etc/freeswitch ]; then
	verbose "Directory /etc/freeswitch not empty"
	rm -rf /etc/freeswitch.org
	mv /etc/freeswitch /etc/freeswitch.org
fi
mkdir /etc/freeswitch
cp -R /var/www/fusionpbx/resources/templates/conf/* /etc/freeswitch
