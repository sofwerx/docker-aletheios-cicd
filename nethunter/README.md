This directory contains the bits for using/updating/maintaining the kali rolling chroot for nethunter.

# make

Running `make` in this directory should copy up the scripts and converge the chroot environment.

# adb root

In order to run these things, you will probably want to have adb running as root before opening an adb shell

    adb root
    adb shell

# /data/local/nhsystem/kali-armhf

The Kali debian rolling chroot filesystem is in the `/data/local/nhsystem/kali-armhf` folder on the android device.

# chroot.sh

`chroot.sh` is pushed to `/data/chroot.sh` on the android device via adb.

On any rooted android phone with nethunter and kali chroot installed, this will give you a full debian rolling armhl/arm64 linux environment.

This script can be run from the nethunter terminal as root, or from an adb shell as root.

Inside an `adb shell` as root, running `/data/chroot.sh` will leave you in an interactive bash shell chrooted to the nethunter chroot directyory with all of the linux kernel filesystems mounted within it.

# root.sh

`root.sh` is pushed to `/data/root.sh` on the android device via adb.

When using this modified aletheios ROM, this will give you a pseudo-debian rolling linux environment, with some weird pathing behaviors.

Inside an `adb shell as root`, running `/data/root.sh` will leave you with the android root filesystem instead of the kali debian rolling chroot, albeit with various chroot folders bind mounted so that they appear as available (ie: `/usr`, `/bin/`, `/lib`, `/var`, `/run`).

