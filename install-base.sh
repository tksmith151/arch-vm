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
pacstrap /mnt base

echo 'GENERATING FILESYSTEM TABLE'
genfstab -U /mnt >> /mnt/etc/fstab

echo 'CHANGING ROOT'
wget https://raw.githubusercontent.com/tksmith151/arch-vm/master/configure-base.sh
chmod +x configure-base.sh
cp configure-base.sh /mnt
arch-chroot /mnt ./configure-base.sh

echo 'UNMOUNTING FILESYSTEM'
umount -R /mnt

echo 'REBOOTING VIRTUAL MACHINE'
shutdown -r now