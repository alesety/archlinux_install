gdisk /dev/sda <<EOF
o
y
n


+512M
ef00
n




w
y
EOF
mkfs.vfat /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
timedatectl set-ntp true
curl "https://www.archlinux.org/mirrorlist/?country=JP&protocol=http&protocol=https&ip_version=4&use_mirror_status=on" | \
sed "s/^#Server/Server/" > /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel grub efibootmgr
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt <<EOF
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
lwclock --systohc --utc
sed -i "s/#ja_JP.UTF-8/ja_JP.UTF-8/" /etc/locale.gen
sed -i "s/#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=jp106 > /etc/vconsole.conf
mkinitcpio -p linux
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
sed -i "s/^GRUB_TIMEOUT=5$/GRUB_TIMEOUT=0/" /etc/default/grub
sed -i "s/^#GRUB_HIDDEN_TIMEOUT=5$/GRUB_HIDDEN_TIMEOUT=0/" /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
mkdir -p /boot/EFI/boot
cp /boot/EFI/grub/grubx64.efi /boot/EFI/boot/bootx64.efi
EOF
echo "---finish---"
