#/bin/sh

ubuntu_hdd_import()
{
    echo zpool import -R /mnt/rpool -c /root/zpool.cache rpool
    zpool import -R /mnt/rpool -c /root/zpool.cache rpool
    echo zpool import -R /mnt/rpool -c /root/zpool.cache bpool
    zpool import -R /mnt/rpool -c /root/zpool.cache bpool
    echo mv /mnt/rpool/etc/resolv.conf /mnt/rpool/etc/resolv.conf_
    mv /mnt/rpool/etc/resolv.conf /mnt/rpool/etc/resolv.conf_
    echo cp /etc/resolv.conf /mnt/rpool/etc/resolv.conf
    cp /etc/resolv.conf /mnt/rpool/etc/resolv.conf
    echo mount -o bind /dev /mnt/rpool/dev
    mount -o bind /dev /mnt/rpool/dev
    echo mount -o bind /dev/pts /mnt/rpool/dev/pts
    mount -o bind /dev/pts /mnt/rpool/dev/pts
    echo mount -t proc proc /mnt/rpool/proc
    mount -t proc proc /mnt/rpool/proc
    echo mount -t sysfs sys /mnt/rpool/sys
    mount -t sysfs sys /mnt/rpool/sys
    echo mount /dev/sdb2 /mnt/rpool/boot/grub
    mount /dev/sdb2 /mnt/rpool/boot/grub
    echo chroot /mnt/rpool/ /bin/su - $1
    chroot /mnt/rpool/ /bin/su - $1
}

ubuntu_hdd_export()
{
    echo umount /mnt/rpool/boot/grub
    umount /mnt/rpool/boot/grub
    echo umount /mnt/rpool/sys
    umount /mnt/rpool/sys
    echo umount /mnt/rpool/proc
    umount /mnt/rpool/proc
    echo umount /mnt/rpool/dev/pts
    umount /mnt/rpool/dev/pts
    echo umount /mnt/rpool/dev
    umount /mnt/rpool/dev
    echo rm /mnt/rpool/etc/resolv.conf
    rm /mnt/rpool/etc/resolv.conf
    echo mv /mnt/rpool/etc/resolv.conf_ /mnt/rpool/etc/resolv.conf
    mv /mnt/rpool/etc/resolv.conf_ /mnt/rpool/etc/resolv.conf
    echo zpool export bpool
    zpool export bpool
    echo zpool export rpool
    zpool export rpool
}

/mnt/c/Windows/system32/WindowsPowerShell/v1.0/powershell.exe \
	-NoProfile -ExecutionPolicy unrestricted \
	-Command Start-Process powerShell.exe \
	-ArgumentList \"-Command wsl --mount \\\\.\\PHYSICALDRIVE1 --bare\; wsl --mount \\\\.\\PHYSICALDRIVE2 --bare\" -Verb runas
/mnt/c/Windows/system32/WindowsPowerShell/v1.0/powershell.exe \
        -NoProfile -ExecutionPolicy unrestricted \
        -Command Get-CimInstance Win32_DiskDrive
ubuntu_hdd_import $1
ubuntu_hdd_export
/mnt/c/Windows/system32/WindowsPowerShell/v1.0/powershell.exe \
	-NoProfile -ExecutionPolicy unrestricted \
	-Command Start-Process powerShell.exe \
	-ArgumentList \"-Command wsl --unmount \\\\.\\PHYSICALDRIVE2\; wsl --unmount \\\\.\\PHYSICALDRIVE1\" -Verb runas
