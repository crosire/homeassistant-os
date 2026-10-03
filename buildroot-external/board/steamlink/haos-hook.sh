#!/bin/bash

function haos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    cp -r "${BR2_EXTERNAL_HAOS_PATH}/board/steamlink/boot/." "${BOOT_DATA}/"
    chmod 0755 "${BOOT_DATA}/usr/bin/kexec"
    chmod 0755 "${BOOT_DATA}/steamlink/factory_test/run.sh"

    mkdir -p "${BOOT_DATA}/boot/dtbs"
    cp "${BR2_EXTERNAL_HAOS_PATH}/board/steamlink/cmdline.txt" "${BOOT_DATA}/boot/cmdline.txt"
    cp "${BINARIES_DIR}/zImage" "${BOOT_DATA}/boot/zImage"
    cp "${BINARIES_DIR}/berlin2cd-valve-steamlink.dtb" "${BOOT_DATA}/boot/dtbs/berlin2cd-valve-steamlink.dtb"
}

function haos_post_image() {
    convert_disk_image_xz
}
