#!/bin/bash -e

install -m 644 files/kiosk.service "${ROOTFS_DIR}/etc/systemd/system/kiosk.service"

cat files/config.txt.append >> "${ROOTFS_DIR}/boot/firmware/config.txt"

CMDLINE="${ROOTFS_DIR}/boot/firmware/cmdline.txt"
for opt in quiet splash logo.nologo vt.global_cursor_default=0; do
  grep -qw -- "$opt" "$CMDLINE" || sed -i "1s|\$| $opt|" "$CMDLINE"
done

on_chroot << EOF
useradd -m -G video,input,render,_seatd -s /bin/bash kiosk
systemctl enable seatd.service
systemctl enable kiosk.service
systemctl set-default graphical.target
EOF

install -m 644 files/splash.png \
  "${ROOTFS_DIR}/usr/share/plymouth/themes/pix/splash.png"

on_chroot << EOF
plymouth-set-default-theme pix
update-initramfs -u
EOF
