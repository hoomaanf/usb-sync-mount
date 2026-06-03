#!/bin/bash

# This script configures udisks2 to use 'sync' for mount options by default.
# WARNING: This will affect the mount behavior of all devices, not just USB drives.

echo "Creating or updating udisks2 configuration file..."

# Define the configuration file path
CONFIG_FILE="/etc/udisks2/mount_options.conf"

# Define the configuration content
CONFIG_CONTENT='[defaults]
# Use sync for all mount operations by default
defaults=dirsync

[ntfs]
defaults=dirsync,uid=0,gid=0,umask=0077

[vfat]
defaults=dirsync,uid=0,gid=0,umask=0077

[exfat]
defaults=dirsync,uid=0,gid=0,umask=0077

[ext2]
defaults=dirsync

[ext3]
defaults=dirsync

[ext4]
defaults=dirsync

[btrfs]
defaults=dirsync

[xfs]
defaults=dirsync

[f2fs]
defaults=dirsync

[udf]
defaults=dirsync

[iso9660]
defaults=ro

[hfsplus]
defaults=dirsync,uid=0,gid=0,umask=0077

[hfs]
defaults=dirsync,uid=0,gid=0,umask=0077

[minix]
defaults=dirsync

[nilfs2]
defaults=dirsync

[jfs]
defaults=dirsync

[reiserfs]
defaults=dirsync
'

# Ensure the configuration directory exists
sudo mkdir -p "$(dirname "$CONFIG_FILE")"

# Write the configuration content to the file, overwriting if it exists
echo "$CONFIG_CONTENT" | sudo tee "$CONFIG_FILE" > /dev/null

if [ $? -eq 0 ]; then
    echo "Configuration file successfully saved to $CONFIG_FILE."
else
    echo "Error saving configuration file. Please check permissions."
    exit 1
fi

echo "Restarting udisks2 service..."
sudo systemctl restart udisks2.service

if [ $? -eq 0 ]; then
    echo "udisks2 service restarted successfully."
    echo "You can now test your USB drive."
else
    echo "Error restarting udisks2 service. Please check status with 'sudo systemctl status udisks2.service'."
    exit 1
fi

echo "Script finished."
exit 0
