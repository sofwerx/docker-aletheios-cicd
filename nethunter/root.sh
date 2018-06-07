#!/system/bin/sh
if ! mount | grep -v grep | grep /dev/pts ; then
  mount -t devpts devpts /dev/pts
fi
if ! mount | grep -v grep | grep /data/usr; then
  mount --bind /data/local/nhsystem/kali-armhf/usr /data/usr
fi
if ! mount | grep -v grep | grep /data/bin; then
  mount --bind /data/local/nhsystem/kali-armhf/bin /data/bin
fi
if ! mount | grep -v grep | grep /data/lib; then
  mount --bind /data/local/nhsystem/kali-armhf/lib /data/lib
fi
if ! mount | grep -v grep | grep /data/var; then
  mount --bind /data/local/nhsystem/kali-armhf/var /data/var
fi
if ! mount | grep -v grep | grep /data/run; then
  mount --bind /data/local/nhsystem/kali-armhf/run /data/run
fi
if ! mount | grep /sys/fs/cgroup | grep tmpfs ; then
  mount -t tmpfs -o rw,relatime,seclabel,mode=755 tmpfs /sys/fs/cgroup
fi
if ! mount | grep -v grep | grep /sys/fs/cgroup/cpuset; then
  mkdir -p /sys/fs/cgroup/cpuset
  mount -t cgroup -o rw,relatime,cpuset,release_agent=/sbin/cpuset_release_agent cgroup /sys/fs/cgroup/cpuset
fi
if ! mount | grep -v grep | grep /sys/fs/cgroup/cpu; then
  mkdir -p /sys/fs/cgroup/cpu
  mount -t cgroup -o rw,relatime,cpu cgroup /sys/fs/cgroup/cpu
fi
if ! mount | grep -v grep | grep /sys/fs/cgroup/cpuacct; then
  mkdir -p /sys/fs/cgroup/cpuacct
  mount -t cgroup -o rw,relatime,cpuacct cgroup /sys/fs/cgroup/cpuacct
fi
if ! mount | grep -v grep | grep /sys/fs/cgroup/schedtune; then
  mkdir -p /sys/fs/cgroup/schedtune
  mount -t cgroup -o rw,relatime,schedtune cgroup /sys/fs/cgroup/schedtune
fi
if ! mount | grep -v grep | grep /sys/fs/cgroup/blkio; then
  mkdir -p /sys/fs/cgroup/blkio
  mount -t cgroup -o rw,relatime,blkio cgroup /sys/fs/cgroup/blkio
fi
if ! mount | grep -v grep | grep /sys/fs/cgroup/memory; then
  mkdir -p /sys/fs/cgroup/memory
  mount -t cgroup -o rw,relatime,memory cgroup /sys/fs/cgroup/memory
fi
if ! mount | grep -v grep | grep /sys/fs/cgroup/devices; then
  mkdir -p /sys/fs/cgroup/devices
  mount -t cgroup -o rw,relatime,devices cgroup /sys/fs/cgroup/devices
fi
if ! mount | grep -v grep | grep /sys/fs/cgroup/freezer; then
  mkdir -p /sys/fs/cgroup/freezer
  mount -t cgroup -o rw,relatime,freezer cgroup /sys/fs/cgroup/freezer
fi
if ! mount |grep -v grep | grep /sys/fs/cgroup/net_cls; then
  mkdir -p /sys/fs/cgroup/net_cls
  mount -t cgroup -o rw,relatime,net_cls cgroup /sys/fs/cgroup/net_cls
fi
if ! mount | grep -v grep | grep /sys/fs/cgroup/perf_event; then
  mkdir -p /sys/fs/cgroup/perf_event
  mount -t cgroup -o rw,relatime,perf_event cgroup /sys/fs/cgroup/perf_event
fi
if ! mount | grep -v grep | grep /sys/fs/cgroup/net_prio; then
  mkdir -p /sys/fs/cgroup/net_prio
  mount -t cgroup -o rw,relatime,net_prio cgroup /sys/fs/cgroup/net_prio
fi
if ! mount | grep -v grep | grep /sys/fs/cgroup/pids; then
  mkdir -p /sys/fs/cgroup/pids
  mount -t cgroup -o rw,relatime,pids cgroup /sys/fs/cgroup/pids
fi
if ! mount | grep -v grep | grep /sys/fs/cgroup/debug; then
  mkdir -p /sys/fs/cgroup/debug
  mount -t cgroup -o rw,relatime,debug cgroup /sys/fs/cgroup/debug
fi
CHROOTFS=/data/local/nhsystem/kali-armhf
export PATH=${CHROOTFS}/usr/bin:${CHROOTFS}/bin:${CHROOTFS}/usr/local/bin:${CHROOTFS}/usr/sbin:${CHROOTFS}/sbin:${CHROOTFS}/usr/local/sbin:$PATH
exec bash -i $@
