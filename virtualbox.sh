arch-chroot /mnt <<EOT
pacman -Syu --noconfirm virtualbox-guest-modules-arch virtualbox-guest-utils
modprobe -a vboxguest vboxsf vboxvideo
EOF
