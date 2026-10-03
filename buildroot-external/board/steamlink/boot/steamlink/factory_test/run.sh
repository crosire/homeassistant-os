#!/bin/sh

ROOT=/mnt/disk

# Prevent factory reset after a few reboots.
fts-set steamlink.crashcounter 0

# Mount devices and load the "kexec" kernel module.
mkdir -p \
	$ROOT/proc \
	$ROOT/dev \
	$ROOT/sys
mount -t proc proc $ROOT/proc
mount -o rbind /dev $ROOT/dev
mount -o rbind /sys $ROOT/sys

insmod $ROOT/lib/modules/3.8.13/kexec_load.ko

# Read RAUC slot and state.
rauc_slot_primary=$(cat "$ROOT/rauc-slot.txt" 2>/dev/null) || rauc_slot_primary=A
case "$rauc_slot_primary" in
    A) rauc_slot_secondary=B ;;
    B) rauc_slot_secondary=A ;;
    *) exit 1 ;;
esac

# Chose RAUC slot to boot (prefer primary, and only boot a known-good slot).
for rauc_slot in "$rauc_slot_primary" "$rauc_slot_secondary"; do
    rauc_state=$(cat "$ROOT/rauc-state-$rauc_slot.txt" 2>/dev/null) || continue
    [ "$rauc_state" = good ] && break
done
[ "${rauc_state:-}" = good ] || exit 1

case "$rauc_slot" in
    A) rootfs_uuid="48617373-06" ;;
    B) rootfs_uuid="48617373-08" ;;
esac

# Execute the kernel with the chosen slot.
chroot $ROOT/ /usr/bin/kexec -l /boot/zImage \
	--dtb /boot/dtbs/berlin2cd-valve-steamlink.dtb \
	--command-line "root=PARTUUID=$rootfs_uuid rootfstype=erofs ro rauc.slot=$rauc_slot rootwait $(cat $ROOT/boot/cmdline.txt)" &&
chroot $ROOT/ /usr/bin/kexec -e
