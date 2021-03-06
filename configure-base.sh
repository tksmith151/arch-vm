echo 'SETTING TIME ZONE'
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

echo 'SETTING HARDWARE CLOCK'
hwclock --systohc --utc

echo 'GENERATING LOCALE FILES'
echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf

echo 'SETTING HOSTNAME'
echo arch-vm > /etc/hostname
echo "127.0.0.1       localhost" > /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       arch-vm.localdomain arch-vm" >> /etc/hosts

echo 'ENABLING NETWORKING'
systemctl enable dhcpcd.service

echo 'SETTING ROOT PASSWORD'
echo -en "password\npassword" | passwd

echo 'CONFIGURING BOOT LOADER'
pacman -S --noconfirm grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

rm /arch-vm-configure.sh