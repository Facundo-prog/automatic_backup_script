# Automatic Backup Files Script

## Prerequisites

* Rsync (included in Debian, Ubuntu, Linux Mint, etc.)
* SUDO or root access
* Familiarity with terminal commands

</br>

## Quick Start

### If the backup disk is different from the installation disk:

Copy the UUID of your external disk:

    sudo blkid

Edit the mount points file:

    sudo nano /etc/fstab


Replace the disk `UUID` and `mount point` (default is "/backup-disk") with your configuration:

View fstab file for more information.

```
# <file system> <mount point>   <type>  <options>       <dump>  <pass>

# Others discks
UUID=645648-kadfvadfb86teyn1sd3  /boot/efi       vfat    umask=0077      0       1

# backup external disk
UUID=<replace for your disk UUID>  /<replace for moun point>    ext4    defaults        0       0
```

Reload system dameon:

    sudo systemctl daemon-reload


### Modify custom service:

* Default backup runs every hour (RestartSec=3600)
* Default bash script path is "/home/backup-files.sh" (ExecStart=/to/script/file)

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



### Copy the service to the path "/etc/systemd/system/":

Copy script:

    sudo cp backup-files.service /etc/systemd/system/

Enable backup service:

    sudo systemctl enable backup-files.service



### Modify script:
```
# Paths
# Default backup saved on external disk
external_disk=true

# Disk backup mount point
backup_path="/backup-disk"

# Origins files array
origins=("/home/user1/files" "/home/user2/files/documents")

# Destination backups
destinations=("$backup_path/backup-user1" "$backup_path/backup-user2")
```



### Copy the script to the path defined in the service file:

The default path is ExecStart=/home/backup-files.sh

    sudo cp backup-files.sh /home/



### Test script commands:

Manually execute the script for testing:

    sudo bash /home/backup-files.sh



### If no errors occurred during the test, start the service:

Start service:

    sudo systemctl start backup-files.service



### Check the status of the service:

    sudo systemctl status backup-files.service


</br>


## View Backup Files

### If the backup disk is different from the installation disk:

Show disks:

    sudo lsblk

Mount the external disk. An example command contains disk /dev/sdb1 and a mount point is "/backup-files":

    sudo mount /dev/sdb1 /backup-files

</br>

### Or if the backup disk is the installation disk:

Enter the folder configured for the script backup-files.sh:

    cd /backup-files 
