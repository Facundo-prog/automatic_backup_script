#!/bin/bash

# Paths
# Unmount disk after save backup
unmount_dick=true

# Disk backup mount point
backup_path="/backup-disk"

# Origins files array
origins=("/home/user1/files" "/home/user2/files/documents")

# Destination backups
destinations=("$backup_path/backup-user1" "$backup_path/backup-user2")

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
        echo "Folder $destination created"
        mkdir "$destination"
    fi

    # Execute rsync
    rsync -av --delete "$origin/" "$destination/"

    # Verify folder backup
    if [ $? -eq 0 ]; then
        echo "Backup successfully saved $origin on $destination"
    else
        echo "Error on copy files"
        return 1
    fi

    return 0
}


# The mount point disk not exists
if [ ! -d "$backup_path" ]; then
    mkdir -p "$backup_path"
    echo "Mount point disk created"
fi

# The disk not mount
if ! mountpoint -q "$backup_path"; then
    echo "Mounting disk..."
    mount "$backup_path"
fi


# Iterate over origin-destination pairs and perform backup
for (( i=0; i<${#origins[@]}; i++ )); do
    perform_backup "${origins[i]}" "${destinations[i]}"
done


# Unmount disk
if [ "$unmount_dick" = true ]; then
    if mountpoint -q "$backup_path"; then
        echo "Unmounting disk..."
        umount "$backup_path"
    fi
fi
