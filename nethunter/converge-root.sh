#!/system/bin/sh -xe

mkdir -p /data/usr
mkdir -p /data/bin
mkdir -p /data/lib
mkdir -p /data/var
mkdir -p /data/run
mkdir -p /data/local/tmp

chmod 1777 /data/local/tmp

if [ ! -d /data/ssh/authorized_keys ]; then
  curl https://github.com/ianblenke.keys > /data/ssh/authorized_keys
fi
if [ ! -f /data/ssh/ssh_host_dsa_key ]; then
  ssh-keygen -f /data/ssh/ssh_host_dsa_key -N '' -t dsa
fi
if [ ! -f /data/ssh/ssh_host_rsa_key ]; then
  ssh-keygen -f /data/ssh/ssh_host_rsa_key -N '' -t dsa
fi
if [ ! -f /data/ssh/ssh_host_ecdsa_key ]; then
  ssh-keygen -f /data/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
fi
if [ ! -f /data/ssh/ssh_host_ed25519_key ]; then
  ssh-keygen -f /data/ssh/ssh_host_ed25519_key -N '' -t ed25519
fi

# set up sshd

cat > /data/ssh/sshd_config << EOF
AuthorizedKeysFile /data/ssh/authorized_keys
ChallengeResponseAuthentication no
PasswordAuthentication no
PermitRootLogin no
Subsystem sftp internal-sftp
pidfile /data/ssh/sshd.pid
EOF

mkdir -p /data/local/userinit.d
sed 's#/system/etc/ssh#/data/ssh#' /system/bin/start-ssh \
      > /data/local/userinit.d/99sshd
chmod 755 /data/local/userinit.d/99sshd
chmod 600 /data/ssh/authorized_keys
chown shell /data/ssh/authorized_keys
chmod 644 /data/ssh/sshd_config

/system/bin/sshd
