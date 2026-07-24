#!/bin/bash -e

install -m 644 files/kiosk.service "${ROOTFS_DIR}/etc/systemd/system/kiosk.service"

on_chroot << EOF
useradd -m -G video,input,render,_seatd -s /bin/bash kiosk
systemctl enable seatd.service
systemctl enable kiosk.service
systemctl set-default graphical.target
EOF
