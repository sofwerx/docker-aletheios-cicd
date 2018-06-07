#!/bin/bash -xe

mkdir -p /data/usr
mkdir -p /data/bin
mkdir -p /data/lib
mkdir -p /data/var
mkdir -p /data/run
mkdir -p /data/local/tmp

chmod 1777 /data/local/tmp

# This should be run under /data/chroot.sh
cat <<EOF > /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
gpg --keyserver hkp://keys.gnupg.net --recv-key 7D8D0BF6
gpg -a --export 7D8D0BF6 | apt-key add -

apt-get update
apt-get dist-upgrade -y

