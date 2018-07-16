HOSTNAME='arch-vm'
TIME_ZONE='America/Los_Angeles'

echo 'SETTING TIME ZONE'
ln -sf "/usr/share/zoneinfo/$TIME_ZONE" /etc/localtime

echo 'SETTING HARDWARE CLOCK'
hwclock --systohc --utc

echo 'GENERATING LOCALE FILES'
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo 'LANG="en_US.UTF-8"' >> /etc/locale.conf

echo 'SETTING HOSTNAME'
echo '$HOSTNAME' > /etc/hostname
cat > /etc/hosts <<EOF
127.0.0.1 localhost.localdomain localhost $HOSTNAME
::1       localhost.localdomain localhost $HOSTNAME
EOF

echo 'ENABLING NETWORKING'
systemctl enable dhcpcd

echo 'SETTING ROOT PASSWORD'
echo 'Enter the root password:'
stty -echo
read ROOT_PASSWORD
stty echo
echo -en "$ROOT_PASSWORD\n$ROOT_PASSWORD" | passwd

echo 'CONFIGURING BOOT LOADER'
grub-install /dev/sda
grub-mkconfig –o /boot/grub/grub.cfg

rm /arch-vm-configure.sh