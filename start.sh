#!/bin/bash

# Script serhana ini saya buat untuk memudahkan kita mount
# partisi yang kita punya sebelum kita install
# distro secara manual

MY_CHROOT=/mnt

MOUNT () {
clear
read -p "
Masukkan disk anda (misalnya sda, sdb, sdc dll) : " disk
read -p "
Masukkan nomor partisi anda (misalnya 1, 2, 3 dll) : " no
read -p "
Masukkan mount point (misalnya /, /boot/efi, /home) : " mp

if [ "$mp" = "/" ] ;
    then
        mount -m /dev/$disk$no $MY_CHROOT$mp
        rm -rf $MY_CHROOT/*
        rm -rf $MY_CHROOT/.*
    else
        if [ "$mp" = "/boot/efi" ] ;
            then
                mount -m /dev/$disk$no $MY_CHROOT$mp
                rm -rf $MY_CHROOT/boot/efi/EFI/Arch*
                rm -rf $MY_CHROOT/boot/efi/EFI/arch*
            else
                if [ "$mp" = "/var" ] ;
                    then
                        mount -m /dev/$disk$no $MY_CHROOT$mp
                        mv $MY_CHROOT/var/cache $MY_CHROOT/var/.cache
                        rm -rf $MY_CHROOT/var/*
                        mv $MY_CHROOT/var/.cache $MY_CHROOT/var/cache
                        rm -rf $MY_CHROOT/var/.*
                    else echo
                        mount -m /dev/$disk$no $MY_CHROOT$mp
                fi
        fi
fi
genfstab -U /mnt
read -p "
Proses mount berhasil, apakah ingin mount partisi lain ?

[Y/n] : " yn
    case $yn in
        [Yy]*) clear
        MOUNT
        ;;
        [Nn]*) clear
        exit
        ;;
        *) read -p "
Input yang anda masukkan salah tekan enter untuk kembali" ret
            case $ret in
                *) MOUNT
                ;;
            esac

    esac
}
MOUNT
