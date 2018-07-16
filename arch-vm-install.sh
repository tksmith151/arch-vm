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

echo 'GENERATING FILE SYSTEM TABLE'
genfstab -U /mnt >> /mnt/etc/fstab

echo 'CHANGING ROOT'
wget https://raw.githubusercontent.com/tksmith151/arch-vm/master/arch-vm-configure.sh
chmod +x arch-vm-configure.sh
cp arch-vm-configure.sh /mnt
arch-chroot /mnt ./arch-vm-configure.sh