#!/bin/bash

# TODO add 1394 module autoload?
# sudo_file_grep_append /etc/modules raw1394
# sudo_file_grep_append /etc/modules video1394

# Increase the max USB image size to 1000MB in GRUB
# Insert into line starting with GRUB_CMDLINE_LINUX_DEFAULT
# Don't insert if line contains usbcore.usbfs_memory_mb=1000
# Insert at the end of the line before the "
if [[ -f /etc/default/grub ]]; then
    sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/ { /usbcore.usbfs_memory_mb=1000/! s|"$| usbcore.usbfs_memory_mb=1000"|g }' /etc/default/grub
    sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/ { /noresume/! s|"$| noresume"|g }' /etc/default/grub
    sudo update-grub
fi

# NOTE this doesn't work when building in docker.
# Increase the max USB image size to 1000MB in USB module
# https://importgeek.wordpress.com/2017/02/26/increase-usbfs-memory-limit-in-ubuntu/
# https://support.pixelink.com/support/solutions/articles/3000054087-image-transfer-fails-to-start-when-image-size-is-bigger-than-2-mb
if [[ -w /sys/module/usbcore/parameters ]]; then
    sudo sh -c "echo 1000 > /sys/module/usbcore/parameters/usbfs_memory_mb"
fi

# TODO Add UDEV rules?
