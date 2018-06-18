all:
	adb root || true
	adb push chroot.sh /data/chroot.sh
	adb shell chmod 755 /data/chroot.sh
	adb push root.sh /data/root.sh
	adb shell chmod 755 /data/root.sh
	adb push converge-root.sh /data/converge-root.sh
	adb shell /data/root.sh /data/converge-root.sh
	adb push converge.sh /data/local/nhsystem/kali-armhf/converge-chroot.sh
	adb shell /data/chroot.sh /converge-chroot.sh
