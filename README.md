# Introduction

# Dependencies Installation
These are Arch packages. Install the equivalent for your distribution.

- community/arm-none-eabi-gcc
- community/arm-none-eabi-binutils
- bc
- aur/arm-linux-gnueabihf-gcc (to build u-boot)

# U-boot
We are using U-boot to boot the image from a squashfs. Since we are using a Raspberry Pi 2 board, the following configuration may not work if you are using any other model. Adapt accordingly.

## Compiling U-boot
To generate the default configuration for the Raspberry Pi 2, issue:
    make rpi_2_defconfig

To compile, run the following commands:

     export ARCH=arm
     export CROSS_COMPILE=arm-linux-gnueabihf-
     make

## Configuring U-boot
We provide a `uboot.env` file that contains sensible defaults for the Raspberry Pi 2. If you are using some other board and some features of the kernel are not working, consider looking into the kernel parameters passed by your board's GPU bootloader and insert them in the U-boot's environment by editing its env variables (connect a serial cable to your board's GPIO). More information can be found in (1)[http://elinux.org/RPi_U-Boot] and (2)[http://pinout.xyz/]. We copied the default kernel parameters passed by the bootloader for the RPI2 because the HDMI output was not working correctly with the kernel parameters depicted in *1*, however, one of the kernel parameters passed (`vc_mem.mem_base=0x3dc000000`) was causing a kernel panic only when the kernel was booted up with U-boot so we removed it.

# Image building process


# Customizing considerations
The `.config.example` file provides a an example configuration for a Raspberry Pi 2 rootfs that includes packages the authors found necessary. Please customize according to the hardware you wish to use.

## Wireless
Be default, the configuration install `iw` and `wpa_supplicant` for managing and connecting to wireless networks. The authors were using a TP-LINK WN722N which has AR9271 chipset and is driven by the `ath9k_htc` module. Firmware is required for this device and comes from the `linux-firmware` package, specifically the `htc_9271.fw` blob. Your wireless adapter may differ and its configuration may be necessary. We suggest looking into the your device's chipset and its driving module andpossibly required firmware so you can produce a new BuildRoot configuration that contains the required procedures.
