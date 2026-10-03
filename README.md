# Home Assistant Operating System

Home Assistant Operating System (formerly HassOS) is a Linux based operating system optimized to host [Home Assistant](https://www.home-assistant.io) and its [Apps](https://www.home-assistant.io/apps/).

Home Assistant Operating System uses Docker as its container engine. By default it deploys the Home Assistant Supervisor as a container. Home Assistant Supervisor in turn uses the Docker container engine to control Home Assistant Core and Apps in separate containers. Home Assistant Operating System is **not** based on a regular Linux distribution like Ubuntu. It is built using [Buildroot](https://buildroot.org/) and it is optimized to run Home Assistant. It targets single board compute (SBC) devices like the Raspberry Pi or ODROID but also supports x86-64 systems with UEFI.

This fork adds support for the Valve Steam Link as a target device.
1. To build: `scripts/enter.sh make steamlink`
2. Flash the resulting `output/images/haos_steamlink-????.img.xz` onto an USB stick (replace `/dev/s??` with the USB stick device): `xzcat output/images/haos_steamlink-????.img.xz | sudo dd of=/dev/s?? bs=4M status=progress conv=fsync`
3. (Optional) [Enable SSH access on the Steam Link](https://github.com/ValveSoftware/steamlink-sdk/tree/master#ssh-access), and use that to patch [line 134](https://github.com/ValveSoftware/steamlink-sdk/blob/62b4d098d1472c3534dd098ca2a0e0e10712f1c6/rootfs/etc/init.d/startup/S01config#L134) `/etc/init.d/startup/S01config` on the stock Linux OS from `sleep 2` to e.g. `sleep 5`. Otherwise it sometimes does not enumerate the USB stick partitions fast enough and skips booting into the Home Assistant OS. This was certainly a pain to figure out =)
4. Plug the USB stick into the Steam Link. On the next power cycle it should now boot into Home Assistant OS, and continue to do so until the USB stick is removed again.

References:
- https://feyor.sh/blog/infecting-the-steam-link-with-nixos/
- https://heap.ovh/getting-linux-on-valve-steam-link.html
- https://github.com/ValveSoftware/steamlink-sdk/
- https://github.com/lukas2511/steamlink-sdk/

[![Home Assistant - A project from the Open Home Foundation](https://www.openhomefoundation.org/badges/home-assistant.png)](https://www.openhomefoundation.org/)

## Features

- Lightweight and memory-efficient
- Minimized I/O
- Over The Air (OTA) updates
- Offline updates
- Modular using Docker container engine

## Supported hardware

The list of supported hardware is defined by [ADR-0015](https://github.com/home-assistant/architecture/blob/master/adr/0015-home-assistant-os.md).
Every new hardware addition must meet at least requirements defined in [ADR-0017](https://github.com/home-assistant/architecture/blob/master/adr/0017-hardware-screening-os.md) and pass through an architecture design proposal.

For documentation explaining details of the individual supported boards, see [Board support](https://developers.home-assistant.io/docs/operating-system/boards/overview) section of the Home Assistant Developer Docs.

## Getting Started

If you just want to use Home Assistant the official [getting started guide](https://www.home-assistant.io/getting-started/) and [installation instructions](https://www.home-assistant.io/hassio/installation/) take you through how to download Home Assistant Operating System and get it running on your machine.

If you're interested in finding out more about Home Assistant Operating System and how it works read on...

## Development

If you don't have experience with embedded systems, Buildroot or the build process for Linux distributions it is recommended to read up on these topics first (e.g. [Bootlin](https://bootlin.com/docs/) has excellent resources).

The Home Assistant Operating System documentation can be found on the [Home Assistant Developer Docs website](https://developers.home-assistant.io/docs/operating-system).

### Components

- **Operating System:**
  - [Buildroot](https://buildroot.org/) LTS Linux
- **File Systems:**
  - [SquashFS](https://www.kernel.org/doc/Documentation/filesystems/squashfs.txt) for read-only file systems (using LZ4 compression)
  - [ZRAM](https://www.kernel.org/doc/Documentation/blockdev/zram.txt) for `/tmp`, `/var` and swap (using LZ4 compression)
- **Container Platform:**
  - [Docker Engine](https://docs.docker.com/engine/) for running Home Assistant components in containers
- **Updates:**
  - [RAUC](https://rauc.io/) for Over The Air (OTA) and USB updates
- **Security:**
  - [AppArmor](https://apparmor.net/) Linux kernel security module
