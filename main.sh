#!/bin/bash

LOGFILE="output.log"
SUDO_COMMAND="sudo" # Leave empty to run as root directly
INITRAMFS_DIR="initramfs-buildroot"
ROOTFS_DIR="mainfs-buildroot"

# DO NOT EDIT BEYOND THIS LINE
CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOGFILE="$CUR_DIR/$LOGFILE"

CREATE_IMAGE=false
function promptCreateImage {
  read -p "Do you wish to create a sdcard image? [y/n]: " yn
  if [ "$yn" == "y" ]
  then
    CREATE_IMAGE=true
    read -p "Image size in Gigabytes (1000000000 bytes): " size
    createImage $size
    return
  elif [ "$yn" == "n" ]
  then
    echo "Proceeding only with filesystem images generation."
    return 0
  else
    echo "Wrong answer format."
    return 1
  fi
}

function createImage {
  echo "Creating image of size $1Gb"
  if dd if=/dev/zero of=output/images/image.img bs=1000000000 count=$1 >>$LOGFILE 2>&1 &&
    echo "Image created in output/images/image.img" &&
    echo "Mounting image" &&
    $SUDO_COMMAND losetup /dev/loop0 output/images/image.img >>$LOGFILE 2>&1 &&
    echo "Partitioning image for Raspberry Pi" &&
    $SUDO_COMMAND parted /dev/loop0 mktable msdos >>$LOGFILE 2>&1 &&
    $SUDO_COMMAND parted /dev/loop0 mkpart primary fat32 0% 64MB >>$LOGFILE 2>&1 &&
    $SUDO_COMMAND parted /dev/loop0 mkpart primary ext4 64M 192MB >>$LOGFILE 2>&1 &&
    $SUDO_COMMAND parted /dev/loop0 mkpart primary ext4 192MB 100% >>$LOGFILE 2>&1 &&
    echo "Creating filesystems for Raspberry Pi" &&
    $SUDO_COMMAND mkdosfs -F 32 -I /dev/loop0p1 >>$LOGFILE 2>&1 &&
    $SUDO_COMMAND mkfs.ext4 /dev/loop0p2 >>$LOGFILE 2>&1 &&
    $SUDO_COMMAND mkfs.ext4 /dev/loop0p3 >>$LOGFILE 2>&1 &&
    # Mount filesystems and copy files
    $SUDO_COMMAND mkdir -p mnt/{root_overlay,boot} &&
    $SUDO_COMMAND mount /dev/loop0p1 mnt/boot >>$LOGFILE 2>&1 &&
    $SUDO_COMMAND mount /dev/loop0p3 mnt/root_overlay >>$LOGFILE 2>&1;
  then
    return 0
  else
    # Cleanup any missing umounts
    $SUDO_COMMAND umount mnt/boot >>$LOGFILE 2>&1
    $SUDO_COMMAND umount mnt/root_overlay >>$LOGFILE 2>&1
    $SUDO_COMMAND losetup -d /dev/loop0 >>$LOGFILE 2>&1
    echo "Something wrong happened while creating the image. Check $LOGFILE for details."
    return 1
  fi
}

function createFilesystems {
    if (cd $INITRAMFS_DIR &&
    make >>$LOGFILE 2>&1) &&
    (cd $ROOTFS_DIR &&
    read num < board/raspberrypi/fs-overlay/etc/build && # These lines are for
    num=$(($num+1)) &&                                   # creating a build num
    echo $num > board/raspberrypi/fs-overlay/etc/build && # file in the rootfs
    make >>$LOGFILE 2>&1) &&
    if [ "$CREATE_IMAGE" = true ]
    then
      $SUDO_COMMAND dd if=$ROOTFS_DIR/output/images/rootfs.ext4 of=/dev/loop0p2 bs=4M >>$LOGFILE 2>&1

      # Copy relevant raspberrypi files to boot/
      $SUDO_COMMAND cp initramfs-buildroot/output/images/rpi-firmware/bootcode.bin mnt/boot/
      $SUDO_COMMAND cp initramfs-buildroot/output/images/rpi-firmware/start.elf mnt/boot/
      $SUDO_COMMAND cp initramfs-buildroot/output/images/rpi-firmware/fixup.dat mnt/boot/
      $SUDO_COMMAND cp initramfs-buildroot/output/images/rpi-firmware/config.txt mnt/boot/

      # Copy initramfs kernel to boot
      $SUDO_COMMAND cp initramfs-buildroot/output/images/zImage mnt/boot/zImage

      # Create overlayfs directories
      $SUDO_COMMAND mkdir -p mnt/root_overlay/{upper,work,upper/updates}

      $SUDO_COMMAND umount mnt/boot >>$LOGFILE 2>&1
      $SUDO_COMMAND umount mnt/root_overlay >>$LOGFILE 2>&1
      echo "Removing loopback device"
      $SUDO_COMMAND losetup -d /dev/loop0 >>$LOGFILE 2>&1
    fi;

    then
      return 0
    else

      if [ "$CREATE_IMAGE" = true ]
      then
        # Cleanup any missing umounts
        $SUDO_COMMAND umount mnt/boot >>$LOGFILE 2>&1
        $SUDO_COMMAND umount mnt/root_overlay >>$LOGFILE 2>&1
        $SUDO_COMMAND losetup -d /dev/loop0 >>$LOGFILE 2>&1
      fi

      echo "Something wrong happened while creating the filesystems. Check $LOGFILE for details."
      return 1
    fi
}

echo "" > $LOGFILE

until promptCreateImage; do true; done
createFilesystems
