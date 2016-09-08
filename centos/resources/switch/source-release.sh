#!/bin/sh

. resources/colors.sh

verbose "Installing the FreeSWITCH source"
yum install -y http://files.freeswitch.org/freeswitch-release-1-6.noarch.rpm epel-release

yum install -y curl memcached gcc-c++ autoconf automake libtool wget python ncurses-devel zlib-devel libjpeg-devel openssl-devel e2fsprogs-devel sqlite-devel libcurl-devel pcre-devel speex-devel ldns-devel libedit-devel libxml2-devel libyuv-devel opus-devel libvpx-devel libvpx2* libdb4* libidn-devel unbound-devel libuuid-devel lua-devel libsndfile-devel yasm-devel nasm libmemcached-devel libshout libshout-devel libpqxx libpqxx-devel

rpm -Uvh https://forensics.cert.org/centos/cert/7/x86_64/lame-libs-3.99.5-1.el7.x86_64.rpm
rpm -Uvh https://forensics.cert.org/centos/cert/7/x86_64/lame-3.99.5-1.el7.x86_64.rpm
rpm -Uvh https://forensics.cert.org/centos/cert/7/x86_64/lame-devel-3.99.5-1.el7.x86_64.rpm
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/libmpg123-1.15.1-1.el7.nux.x86_64.rpm
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/libmpg123-devel-1.15.1-1.el7.nux.x86_64.rpm
#curl https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add -
#echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main" > /etc/apt/sources.list.d/freeswitch.list
#yum update

#we are about to move out of the executing directory so we need to preserve it to return after we are done
CWD=$(pwd)
#git clone https://freeswitch.org/stash/scm/fs/freeswitch.git /usr/src/freeswitch
#git clone -b v1.6 https://freeswitch.org/stash/scm/fs/freeswitch.git /usr/src/freeswitch
SWITCH_MAJOR=$(git ls-remote --heads https://freeswitch.org/stash/scm/fs/freeswitch.git "v*" | cut -d/ -f 3 | grep -P '^v\d+\.\d+' | sort | tail -n 1| cut -dv -f2)
SWITCH_MINOR=$(git ls-remote --tags https://freeswitch.org/stash/scm/fs/freeswitch.git v$SWITCH_MAJOR.* | cut -d/ -f3 | cut -dv -f2 | cut -d. -f3 | sort -n | tail -n1)
SWITCH_VERSION=$SWITCH_MAJOR.$SWITCH_MINOR
verbose "Using version $SWITCH_VERSION"
cd /usr/src
if [ -f freeswitch-$SWITCH_VERSION.zip ]; then
	verbose "Downloaded freeswitch file OK. Checking file content is valid..."
else
	wget http://files.freeswitch.org/freeswitch-releases/freeswitch-$SWITCH_VERSION.zip
fi
unzip freeswitch-$SWITCH_VERSION.zip
rm -R freeswitch
mv freeswitch-$SWITCH_VERSION freeswitch
cd freeswitch

#./bootstrap.sh -j
sed -i /usr/src/freeswitch/modules.conf -e s:'#applications/mod_avmd:applications/mod_avmd:'
sed -i /usr/src/freeswitch/modules.conf -e s:'#applications/mod_callcenter:applications/mod_callcenter:'
sed -i /usr/src/freeswitch/modules.conf -e s:'#applications/mod_cidlookup:applications/mod_cidlookup:'
sed -i /usr/src/freeswitch/modules.conf -e s:'#applications/mod_memcache:applications/mod_memcache:'
sed -i /usr/src/freeswitch/modules.conf -e s:'#applications/mod_curl:applications/mod_curl:'
#sed -i /usr/src/freeswitch/modules.conf -e s:'#formats/mod_shout:formats/mod_shout:'
#./configure --help
#./configure --prefix=/usr/local/freeswitch --enable-core-pgsql-support --enable-system-lua --disable-fhs
./configure --prefix=/usr/local/freeswitch --enable-core-pgsql-support --disable-fhs
#make mod_shout-install
make
rm -rf /usr/local/freeswitch/{lib,mod,bin}/*
make install
make sounds-install moh-install
make hd-sounds-install hd-moh-install
make cd-sounds-install cd-moh-install

#move the music into music/default directory
mkdir -p /usr/local/freeswitch/sounds/music/default
mv /usr/local/freeswitch/sounds/music/*000 /usr/share/freeswitch/sounds/music/default

#return to the executing directory
cd $CWD

#configure system service
ln -s /usr/local/freeswitch/bin/fs_cli /usr/bin/fs_cli
cp "$(dirname $0)/source/freeswitch.service.source" /lib/systemd/system/freeswitch.service
cp "$(dirname $0)/source/etc.default.freeswitch" /etc/default/freeswitch