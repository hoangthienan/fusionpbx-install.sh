#!/bin/sh

. resources/colors.sh

#setup owner and group, permissions and sticky
verbose "Setup owner and group, permissions and sticky"

chown -R nginx:nginx /usr/local/freeswitch
chmod -R ug+rw /usr/local/freeswitch
find /usr/local/freeswitch -type d -exec chmod 2770 {} \;
