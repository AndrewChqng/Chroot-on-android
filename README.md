# Chroot on Termux

## Content

- [Good to Mention](#good-to-mention)
- [Choosing a rootfs](#choosing-a-rootfs)
- [Extracting the rootfs](#extracting-the-rootfs)
- [Making a script to launch the chroot environment](#making-a-script-to-launch-the-chroot-environment)
- [Troubleshooting](#troubleshooting)
  - [Fixing apt under debian based ditros](#fixing-apt-under-debian-based-ditros)
  - [Fixing network issues](#fixing-network-issues)

## Good to Mention

- You need a [rooted](https://en.m.wikipedia.org/wiki/Rooting_(Android)) phone for that
- I've used here a samsung A20 phone running Android 11
- If any damage happens to your phone, you are all responsible for it!


## Choosing a rootfs

the rootfs architecture have to match with your device architecture too, to know what architecture your phone have run:

```shell
$ uname -m
  aarch64
```

(e.g. `aarch64`, `armv7l`).

## Extracting the rootfs

Any location under `/data` should be good (because it formatted as `ext4`) so you can doing that under your termux home directory (because its under `/data` too "_**`/data`**_`/data/com.termux/files/home`"), or `/data/local`

e.g.

```shell
$ mkdir chroot #or anything else
$ sudo tar xfp /sdcard/Download/rootfs.tar.xz -C ./chroot #to keep the files permissions
```

## Making a script to launch the chroot environment

Use `vim` or any text editor you like for that:

```
$ vim run-chroot.sh
```

simple example:

```shell
#!/bin/sh

# fix /dev mount options
mount -o remount,dev,suid /data

mount --bind /dev /data/ubuntu/dev
mount --bind /sys /data/ubuntu/sys
mount --bind /proc /data/ubuntu/proc
mount --bind /dev/pts /data/ubuntu/dev/pts


export PATH=/bin:/sbin:/usr/bin:/usr/sbin
export TERM=$TERM
export TMPDIR=/tmp

chroot ./chroot /bin/su - root
```

then change the file permissions to executable:

```shell
$ chmod +x run-chroot.sh
```

you have to run it as root:

```shell
$ sudo ./run-chroot.sh
```

## Troubleshooting

### Fixing apt under debian based ditros

```shell
usermod -g 3003 _apt
```

### Fixing network issues

you have to add a DNS to `resolv.conf`:

```shell
echo "nameserver 8.8.8.8" > /etc/resolv.conf
```

then you need to add android root groups:

```shell
groupadd -g 3001 aid_bt
groupadd -g 3002 aid_bt_net
groupadd -g 3003 aid_inet
groupadd -g 3004 aid_net_raw
groupadd -g 3005 aid_admin
```

then add those groups to the user you using:

```shell
usermod -a -G aid_bt,aid_bt_net,aid_inet,aid_net_raw,aid_admin root
```

