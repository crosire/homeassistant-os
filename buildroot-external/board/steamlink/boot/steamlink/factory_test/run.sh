#!/bin/sh

# Required to prevent factory reset after a few reboots.
fts-set steamlink.crashcounter 0

mkdir -p /mnt/disk/proc /mnt/disk/sys /mnt/disk/dev
mount -t proc proc /mnt/disk/proc
mount -o rbind /sys /mnt/disk/sys
mount -o rbind /dev /mnt/disk/dev

insmod /mnt/disk/kexec_load.ko

bootargs_a="root=PARTUUID=48617373-06 rootfstype=erofs ro rauc.slot=A"
cmdline="${bootargs_a} rootwait zram.enabled=1 zram.num_devices=3 fsck.repair=yes cgroup_enable=memory console=ttyS0,115200n8 usbcore.autosuspend=-1"

chroot /mnt/disk/ /kexec -l /zImage --initrd /initramfs.cpio --dtb /berlin2cd-valve-steamlink.dtb --command-line "${cmdline}"
chroot /mnt/disk/ /kexec -e
