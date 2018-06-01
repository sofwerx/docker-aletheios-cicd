# docker-lineage-cicd

[![Waffle.io - Columns and their card count](https://badge.waffle.io/sofwerx/docker-aletheios-cicd.svg?columns=all)](https://waffle.io/sofwerx/docker-aletheios-cicd)

Docker microservice for LineageOS Continuous Integration and Continous Deployment

## Why Docker?

A fair number of dependencies is needed to build LineageOS, plus a Linux system
(and a discrete knowledge of it). With Docker we give you a minimal Linux build
system with all the tools and scripts already integrated, easing considerably
the creation of your own LineageOS build.

Moreover Docker runs also on Microsoft Windows and Mac OS, which means that
LineageOS can be built on such platforms without requiring a dual boot system
or a manual set up of a Virtual Machine.

## How do I install Docker?

The official Docker guides are well-written:
 * Linux ([Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/), [Debian](https://docs.docker.com/install/linux/docker-ce/debian/), [CentOS](https://docs.docker.com/install/linux/docker-ce/centos/) and [Fedora](https://docs.docker.com/install/linux/docker-ce/fedora/) are officially supported)
 * [Windows 10/Windows Server 2016 64bit](https://docs.docker.com/docker-for-windows/install/)
 * [Mac OS El Capitan 10.11 or newer](https://docs.docker.com/docker-for-mac/install/)

If your Windows or Mac system doesn't satisfy the requirements (or if you have
Oracle VirtualBox installed, you can use [Docker Toolbox](https://docs.docker.com/toolbox/overview/).
Docker Toolbox is not described in this guide, but it should be very similar to
the standard Docker installation.

Once you can run the [`hello-world` image](https://docs.docker.com/get-started/#test-docker-installation) you're ready to start!

## How can I build LineageOS?

This Docker image contains a great number of settings, to allow you to fully
customize your LineageOS build.

TL;DR - go to the [Examples](#examples)

### Fundamental settings

The two fundamental settings are (default value in brackets):

 * `BRANCH_NAME (cm-14.1)`: LineageOS branch, see the branch list [here](https://github.com/LineageOS/android_vendor_cm/branches)
 * `DEVICE_LIST`: comma-separated list of devices to build

Running a build with only these two set will create a ZIP file almost identical
to the LineageOS official builds, just signed with the test keys.

### Signature spoofing

There are two options for the [signature spoofing patch](https://github.com/microg/android_packages_apps_GmsCore/wiki/Signature-Spoofing)
required for [microG](https://microg.org/):
 * "Original" [patches](https://github.com/lineageos4microg/docker-lineage-cicd/tree/master/src/signature_spoofing_patches)
 * Restricted patches

With the "original" patch the FAKE_SIGNATURE permission can be granted to any
user app: while it may seem handy, this is considered dangerous by a great
number of people, as the user could accidentally give this permission to rogue
apps.

A more strict option is the restricted patch, where the FAKE_SIGNATURE
permission can be obtained only by privileged system apps, embedded in the ROM
during the build process.

The signature spoofing patch can be optionally included with:

 * `SIGNATURE_SPOOFING (no)`: `yes` to use the original patch, `restricted` for the restricted one, `no` for none of them

If in doubt, use `restricted`: note that packages that requires the
FAKE_SIGNATURE permission must be embedded in the build by adding them in

 * `CUSTOM_PACKAGES`

Extra packages can be included in the tree by adding the corresponding manifest
XML to the local_manifests volume.

### Proprietary files

Some proprietary files are needed to create a LineageOS build, but they're not
included in the LineageOS repo for legal reasons. You can obtain these blobs in
three ways:

 * by [pulling them from a running LineageOS](https://wiki.lineageos.org/devices/bacon/build#extract-proprietary-blobs)
 * by [extracting them from a LineageOS ZIP](https://wiki.lineageos.org/extracting_blobs_from_zips.html)
 * by downloading them from [TheMuppets repos](https://github.com/TheMuppets/manifests) (unofficial)

The third way is the easiest one and is enabled by default; if you're OK with
that just move on, otherwise set `INCLUDE_PROPRIETARY (true)` to `false` and
manually provide the blobs (not explained in this guide).

### OTA

If you have a server and you want to enable [OTA updates](https://github.com/julianxhokaxhiu/LineageOTA)
you have to provide the URL of your server during the build process with:

 * `OTA_URL`

If you don't setup a OTA server you won't be able to update the device from the
updater app (but you can still update it manually with the recovery of course).

### Signing

By default, builds are signed with the Android test keys. If you want to sign
your builds with your own keys (highly recommended):

 * `SIGN_BUILDS (false)`: set to `true` to sign the builds with the keys contained in `/srv/keys`; if no keys are present, a new set will be generated

### Other settings

Other useful settings are:

 * `CCACHE_SIZE (50G)`: change this if you want to give more (or less) space to ccache
 * `WITH_SU (false)`: set to `true` to embed `su` in the build (note that, even when set to `false`, you can still enable root by flashing the [su installable ZIP](https://download.lineageos.org/extras))
 * `RELEASE_TYPE (UNOFFICIAL)`: change the release type of your builds
 * `BUILD_OVERLAY (false)`: normally each build is done on the source tree, then the tree is cleaned with `mka clean`. If you want to be sure that each build is isolated from the others, set `BUILD_OVERLAY` to `true` (longer build time). Requires `--cap-add=SYS_ADMIN`.
 * `LOCAL_MIRROR (false)`: change this to `true` if you want to create a local mirror of the LineageOS source (> 200 GB)
 * `CRONTAB_TIME (now)`: instead of building immediately and exit, build at the specified time (uses standard cron format)

## Flashing
Be sure the phone is tethered to a computer with Android SDK installed via USB cable.
Go into the phone's settings and enable developer settings if it isn't already by tapping build number 5 times. Then go to the developer settings and enable OEM unlocking. This will allow you access to the boot loader. 

Now reboot the phone into the bootloader by press and holding the power and volume down buttons. On a computer with Android SDK installed run the following commands to unlock the phone:
```
fastboot flashing unlock_critical
fastboot flashing unlock
```
Now that the phone is unlocked, boot it into recovery mode and select wipe data/factory reset. This will delete anything in storage.
Restart the phone and go back to the bootloader. 

On a computer run `fastboot boot <twrp_image>`. This is another bootloader that will be used to install Lineage OS. 

Now wipe everything. Including the system. Reboot the phone into bootloader and go back to twrp.

Now run: `adb push <lineage_firmware> /sdcard`

Once that is on the phone go to install in the twrp bootloader and click the new zip file. It will install itself. 
When it is done reboot the phone. It should boot into Lineage OS.

Four apps must be present to use the chroot: fdroid (should already be there), nethunter, Term-nh, and VNC-nh.
Use adb to install these to the phone: `adb install <app.apk>`

Once they are installed, make sure root access is allowed in the developer settings and run nethunter and accept all its permission requests. 

Now to install the chroot. Restart into the bootloader and go into twrp again. This time push the nethunter zip file to /sdcard with adb.
install it like you did Lineage OS. Reboot the phone when you are done and do not install the app when they ask. Verify that the chroot is there by opening nethunter and term.

## Volumes

You also have to provide Docker some volumes, where it'll store the source, the
resulting builds, the cache and so on. The volumes are:

 * `/srv/src`, for the LineageOS sources
 * `/srv/zips`, for the output builds
 * `/srv/logs`, for the output logs
 * `/srv/ccache`, for the ccache
 * `/srv/local_manifests`, for custom manifests (optional)
 * `/srv/userscripts`, for the user scripts (optional)

When `SIGN_BUILDS` is `true`

 * `/srv/keys`, for the signing keys

When `BUILD_OVERLAY` is `true`

 * `/srv/tmp`, for temporary files

When `LOCAL_MIRROR` is `true`:

 * `/srv/mirror`, for the LineageOS mirror

## Examples

### Build for bacon (officially supported), test keys, no patches

```
docker run \
    -e "BRANCH_NAME=cm-14.1" \
    -e "DEVICE_LIST=bacon" \
    -v "/home/user/lineage:/srv/src" \
    -v "/home/user/zips:/srv/zips" \
    -v "/home/user/logs:/srv/logs" \
    -v "/home/user/cache:/srv/ccache" \
    lineageos4microg/docker-lineage-cicd
```

### Build for dumpling (officially supported), custom keys, restricted signature spoofing with integrated microG and FDroid

```
docker run \
    -e "BRANCH_NAME=lineage-15.1" \
    -e "DEVICE_LIST=dumpling" \
    -e "SIGN_BUILDS=true" \
    -e "SIGNATURE_SPOOFING=restricted" \
    -e "CUSTOM_PACKAGES=GmsCore GsfProxy FakeStore MozillaNlpBackend NominatimNlpBackend com.google.android.maps.jar FDroid FDroidPrivilegedExtension " \
    -v "/home/user/lineage:/srv/src" \
    -v "/home/user/zips:/srv/zips" \
    -v "/home/user/logs:/srv/logs" \
    -v "/home/user/cache:/srv/ccache" \
    -v "/home/user/keys:/srv/keys" \
    -v "/home/user/manifests:/srv/local_manifests" \
    lineageos4microg/docker-lineage-cicd
```

If there are already keys in `/home/user/keys` they will be used, otherwise a
new set will be generated before starting the build (and will be user for every
build).

The microG and FDroid packages are not present in the LineageOS repositories,
and must be provided through an XML in the `/home/user/manifests`. [This](https://github.com/lineageos4microg/android_prebuilts_prebuiltapks)
repo contains some of the most common packages for these kind of builds: to
include it create an XML (the name is irrelevant, as long as it ends with
`.xml`) in the `/home/user/manifests` folder with this content:

```
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project name="lineageos4microg/android_prebuilts_prebuiltapks" path="prebuilts/prebuiltapks" remote="github" revision="master" />
</manifest>
```

### Build for four devices on cm-14.1 and lineage-15.1 (officially supported), custom keys, restricted signature spoofing with integrated microG and FDroid, custom OTA server

```
docker run \
    -e "BRANCH_NAME=cm-14.1,lineage-15.1" \
    -e "DEVICE_LIST_CM_14_1=onyx,thea" \
    -e "DEVICE_LIST_LINEAGE_15_1=cheeseburger,dumpling" \
    -e "SIGN_BUILDS=true" \
    -e "SIGNATURE_SPOOFING=restricted" \
    -e "CUSTOM_PACKAGES=GmsCore GsfProxy FakeStore MozillaNlpBackend NominatimNlpBackend com.google.android.maps.jar FDroid FDroidPrivilegedExtension " \
    -e "OTA_URL=https://api.myserver.com/" \
    -v "/home/user/lineage:/srv/src" \
    -v "/home/user/zips:/srv/zips" \
    -v "/home/user/logs:/srv/logs" \
    -v "/home/user/cache:/srv/ccache" \
    -v "/home/user/keys:/srv/keys" \
    -v "/home/user/manifests:/srv/local_manifests" \
    lineageos4microg/docker-lineage-cicd
```

### Build for a6000 (not officially supported), custom keys, restricted signature spoofing with integrated microG and FDroid

As there is no official support for this device, we first have to include the
sources in the source tree through an XML in the `/home/user/manifests` folder;
from [this](https://forum.xda-developers.com/lenovo-a6000/development/rom-lineageos-15-1-t3733747)
thread we get the links of:

 * Device tree: [https://github.com/dev-harsh1998/android_device_lenovo_a6000](https://github.com/dev-harsh1998/android_device_lenovo_a6000)
 * Common Tree: [https://github.com/dev-harsh1998/android_device_lenovo_msm8916-common](https://github.com/dev-harsh1998/android_device_lenovo_msm8916-common)
 * Kernel: [https://github.com/dev-harsh1998/kernel_lenovo_msm8916](https://github.com/dev-harsh1998/kernel_lenovo_msm8916)
 * Vendor blobs: [https://github.com/dev-harsh1998/proprietary-vendor_lenovo](https://github.com/dev-harsh1998/proprietary-vendor_lenovo)

Then, with the help of lineage.dependencies from the [device tree](https://github.com/dev-harsh1998/android_device_lenovo_a6000/blob/lineage-15.1/lineage.dependencies)
and the [common tree](https://github.com/dev-harsh1998/android_device_lenovo_msm8916-common/blob/lineage-15.1/lineage.dependencies),
we create an XML `/home/user/manifests/a6000.xml` with this content:

```
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project name="dev-harsh1998/android_device_lenovo_a6000" path="device/lenovo/a6000" remote="github" />
  <project name="dev-harsh1998/android_device_lenovo_msm8916-common" path="device/lenovo/msm8916-common" remote="github" />
  <project name="dev-harsh1998/kernel_lenovo_msm8916" path="kernel/lenovo/a6000" remote="github" />
  <project name="dev-harsh1998/proprietary-vendor_lenovo" path="vendor/lenovo" remote="github" />
  <project name="LineageOS/android_device_qcom_common" path="device/qcom/common" remote="github" />
</manifest>
```

We also want to include our custom packages so, like before, create an XML (for
example `/home/user/manifests/custom_packages.xml`) with this content:

```
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project name="lineageos4microg/android_prebuilts_prebuiltapks" path="prebuilts/prebuiltapks" remote="github" revision="master" />
</manifest>
```

We also set `INCLUDE_PROPRIETARY=false`, as the proprietary blobs are already
provided by the repo [https://github.com/dev-harsh1998/prorietary_vendor_lenovo](https://github.com/dev-harsh1998/prorietary_vendor_lenovo)
(so we don't have to include the TheMuppets repo).

Now we can just run the build like it was officially supported:

```
docker run \
    -e "BRANCH_NAME=lineage-15.1" \
    -e "DEVICE_LIST=a6000" \
    -e "SIGN_BUILDS=true" \
    -e "SIGNATURE_SPOOFING=restricted" \
    -e "CUSTOM_PACKAGES=GmsCore GsfProxy FakeStore MozillaNlpBackend NominatimNlpBackend com.google.android.maps.jar FDroid FDroidPrivilegedExtension " \
    -e "INCLUDE_PROPRIETARY=false" \
    -v "/home/user/lineage:/srv/src" \
    -v "/home/user/zips:/srv/zips" \
    -v "/home/user/logs:/srv/logs" \
    -v "/home/user/cache:/srv/ccache" \
    -v "/home/user/keys:/srv/keys" \
    -v "/home/user/manifests:/srv/local_manifests" \
    lineageos4microg/docker-lineage-cicd
```

