echo 'SYNCING SYSTEM CLOCK'
timedatectl set-ntp true

echo 'PARTITIONING VIRTUAL DRIVE'
parted -s /dev/sda \
    mklabel msdos \
    mkpart primary ext4 0% 100% \
    set 1 boot on

echo 'FORMATTING FILESYSTEM'
mkfs.ext4 /dev/sda1

echo 'MOUNTING FILESYSTEM'
mount /dev/sda1 /mnt

echo 'INSTALLING BASE SYSTEM'
pacstrap /mnt base grub

echo 'GENERATING FILESYSTEM TABLE'
genfstab -U /mnt >> /mnt/etc/fstab

echo 'CHANGING ROOT'
wget https://raw.githubusercontent.com/tksmith151/arch-vm/master/arch-vm-configure.sh
chmod +x arch-vm-configure.sh
cp arch-vm-configure.sh /mnt
arch-chroot /mnt ./arch-vm-configure

echo 'UNMOUNTING FILESYSTEM'
umount /mnt

echo 'REBOOTING VIRTUAL MACHINE'
shutdown -r now