# Automatic backup files script

## Prerquisites

* Rsync (included in Debian, Ubuntu, Linux Mint, etc)
* Sudo or Root access
* Terminal learn

## Quick start


1- If disk on save backup is diferent a instalation disk:

Copy UUID your disk

    sudo blkid

Editing disks mount points file

    sudo nano /etc/fstab

Replace backup external disk UUID and mount point for you configuration
```
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# systemd generates mount units based on this file, see systemd.mount(5).
# Please run 'systemctl daemon-reload' after making changes here.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>

# Others discks
UUID=  /boot/efi       vfat    umask=0077      0       1

# backup external disk
UUID=645648-kadfvadfb86teyn1sd3  /backup-disk    ext4    defaults        0       0
```

1- Modify custom service:

* Default backup run on 1 hour (RestartSec=3600)
* Default bash script path is "/home/backup-files.sh" (ExecStart=/to/bash/file)

```
[Unit]
Description=Automatic backup files
After=network.target

[Service]
Type=simple
User=root
ExecStart=/home/backup-files.sh
Restart=always
RestartSec=3600

[Install]
WantedBy=multi-user.target
```

2- Copy service into path /etc/systemd/system/

    sudo cp backup-files.service /etc/systemd/system/

    sudo systemctl dameon-reload

    sudo systemctl enable backup-files.service


3- Modify script

```
# Paths
external_disk=true // Default backup saved on external disk
backup_path="/backup-disk" //Disk backup mount point
origins=("/home/user1/files" "/home/user2/files/documents") // Origins files array
destinations=("$backup_path/backup-user1" "$backup_path/backup-user2") // Destination backups
```

4- Copy script into ExecStart= path defined in .service

    sudo cp backup-files.sh /home/


5- Test script commands

    sudo bash /home/backup-files.sh

6- If before Test not return never error, then start sevice

    sudo systemctl start backup-files.service

    sudo systemctl status backup-files.service
