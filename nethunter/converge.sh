#!/system/bin/sh -xe

mkdir -p /data/usr
mkdir -p /data/bin
mkdir -p /data/lib
mkdir -p /data/var
mkdir -p /data/run
mkdir -p /data/local/tmp

chmod 1777 /data/local/tmp

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

/data/local/userinit.d/99sshd
