#!/bin/bash -xe

# This should be run under /data/chroot.sh
cat <<EOF > /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
gpg --keyserver hkp://keys.gnupg.net --recv-key 7D8D0BF6
gpg -a --export 7D8D0BF6 | apt-key add -

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get dist-upgrade -y

apt-get install cmake build-essential
apt-get install libfftw3-dev
