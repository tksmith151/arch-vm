VIRTUAL_DRIVE='/dev/sda'
ROOT_PARTITION="$VIRTUAL_DRIVE"1

echo 'PARTITIONING VIRTUAL DRIVE'
parted -s "$VIRTUAL_DRIVE" \
    mklabel msdos \
    mkpart primary ext4 0% 100% \
    set 1 boot on

echo 'FORMATTING FILESYSTEM'
mkfs.ext4 -L root "$ROOT_PARTITION"

echo 'MOUNTING FILESYSTEM'
mount "$ROOT_PARTITION" /mnt

echo 'INSTALLING BASE SYSTEM'
pacstrap /mnt base

echo 'GENERATING FILESYSTEM TABLE'
genfstab -U /mnt >> /mnt/etc/fstab

echo 'CHANGING ROOT'
wget https://raw.githubusercontent.com/tksmith151/arch-vm/master/arch-vm-configure.sh
chmod +x arch-vm-configure.sh
cp arch-vm-configure.sh /mnt
arch-chroot /mnt ./arch-vm-configure.sh

if [ -f /mnt/setup.sh ]
then
    echo 'ERROR: Something failed inside the chroot, not unmounting filesystems so you can investigate.'
    echo 'Make sure you unmount everything before you try to run this script again.'
else
    echo 'UNMOUNTING FILESYSTEM'
    umount /mnt
    echo 'REBOOTING VIRTUAL MACHINE'
    shutdown -r now
fi