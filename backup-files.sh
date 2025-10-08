#!/bin/bash

# Errors checker
set -euo pipefail

# Save log
exec > >(tee /var/log/backup-disk.log) 2>&1

# Paths
# Unmount disk after save backup
unmount_disk=true

# Disk backup mount point
backup_path="/backup-disk"
disk_UUID="aba6bd5-a5sd5b51d-adsfb4542"

# Origins files array
origins=("/home/facu/Documents/backup_folder")

# Destination backups
destinations=("$backup_path/facu")

# Function to perform backup for each origin-destination pair
perform_backup() {
    local origin="$1"
    local destination="$2"

    # The origin folder not exists
    if [ ! -d "$origin" ]; then
        echo "Origin folder not exists: $origin"
        return 1
    fi

    # The destination folder not exists
    if [ ! -d "$destination" ]; then
        echo "Creating folder $destination"
        mkdir -p "$destination"
    fi

    # Execute rsync
    echo
    echo "Starting backup $origin -> $destination"
    rsync -av --delete "$origin/" "$destination/"
    echo "Backup successfully saved $origin on $destination"
}

# Init log
echo "===== Backup created: $(date '+%Y-%m-%d %H:%M:%S') ====="
echo

# The mount point disk not exists
if [ ! -d "$backup_path" ]; then
    mkdir -p "$backup_path"
    echo "Mount point disk created"
fi


# Mount disk
echo "Mounting disk..."
mount UUID="$disk_UUID" "$backup_path"


# The disk not mount
if ! mountpoint -q "$backup_path"; then
    echo "Error occurred when mounting disk. Aborting..."
    exit 1
fi


# Iterate over origin-destination pairs and perform backup
for (( i=0; i<${#origins[@]}; i++ )); do
    perform_backup "${origins[i]}" "${destinations[i]}"
done


# Unmount disk
if [ "$unmount_disk" = true ]; then
    if mountpoint -q "$backup_path"; then
        echo "Unmounting disk..."
        umount -l "$backup_path"
    fi
fi
