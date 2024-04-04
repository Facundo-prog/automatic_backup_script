# Automatic Backup Files Script

## Prerequisites

* Rsync (included in Debian, Ubuntu, Linux Mint, etc.)
* SUDO or root access
* External disk in format ext4
* Familiarity with terminal commands

</br>

## Quick Start

### Create mount point in system:

Copy the UUID of your external disk:

    sudo blkid

Edit the mount points file:

    sudo nano /etc/fstab


Replace the disk `UUID` and `mount point` (default is "/backup-disk") with your configuration:

View fstab.example file for more information.

```
# <file system> <mount point>   <type>  <options>       <dump>  <pass>

# Others discks
UUID=645648-kadfvadfb86teyn1sd3  /boot/efi       vfat    umask=0077      0       1

# backup external disk
UUID=<replace for your disk UUID>  /<replace for mount point>   ext4   nofail   0  0
```

Reload system daemon:

    sudo systemctl daemon-reload

Mount disks:

    sudo mount -a


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

Copy service:

    sudo cp backup-files.service /etc/systemd/system/

Enable service:

    sudo systemctl enable backup-files.service



### Modify script:
```
# Paths
# Unmount disk after save backup (default is true)
unmount_dick=true

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

Concede execute permission:

    sudo chmod 754 /home/backup-files.sh



### Test script commands:

Manually execute the script for testing:

    sudo bash /home/backup-files.sh



### If no errors occurred during the test, start the service:

Start service:

    sudo systemctl start backup-files.service



### Check the status of the service:

    sudo systemctl status backup-files.service

Or view logs

    journalctl -u backup-files.service


</br>


## View Backup Files

Show disks:

    sudo lsblk

Mount the external disk. An example command contains disk /dev/sdb1 and a mount point is "/backup-files":

    sudo mount /dev/sdb1 /backup-files

Enter the folder configured for the script backup-files.sh:

    cd /backup-files 
