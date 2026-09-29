#!/bin/sh

ROOT=/mnt/disk

# Prevent factory reset after a few reboots.
fts-set steamlink.crashcounter 0

# Mount devices and load the "kexec" kernel module.
mkdir -p \
	$ROOT/proc \
	$ROOT/sys \
	$ROOT/dev
mount -t proc proc $ROOT/proc
mount -o rbind /sys $ROOT/sys
mount -o rbind /dev $ROOT/dev

insmod $ROOT/kexec_load.ko

# Execute the kernel.
BOOTARGS_A="root=PARTUUID=48617373-06 rootfstype=erofs ro rauc.slot=A"
BOOTARGS_B="root=PARTUUID=48617373-08 rootfstype=erofs ro rauc.slot=B"
DEFAULT_CMDLINE="rootwait zram.enabled=1 zram.num_devices=3 fsck.repair=yes cgroup_enable=memory usbcore.autosuspend=-1"

chroot $ROOT/ /kexec -l /zImage --dtb /berlin2cd-valve-steamlink.dtb --command-line "${BOOTARGS_A} ${DEFAULT_CMDLINE}"
chroot $ROOT/ /kexec -e
