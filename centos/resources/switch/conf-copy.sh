#!/bin/sh

. resources/colors.sh

verbose "Copy the switch conf files to /etc/freeswitch"

if [ -d /etc/freeswitch ]; then
	verbose "Directory /etc/freeswitch not empty"
else
	mv /etc/freeswitch /etc/freeswitch.org
	mkdir /etc/freeswitch
fi
cp -R /var/www/fusionpbx/resources/templates/conf/* /etc/freeswitch
