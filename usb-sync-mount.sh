#!/bin/bash

# This script configures udisks2 to use 'sync' for mount options by default.
# WARNING: This will affect the mount behavior of all devices, not just USB drives.

echo "Creating or updating udisks2 configuration file..."

# Define the configuration file path
CONFIG_FILE="/etc/udisks2/mount_options.conf"

# Define the configuration content
CONFIG_CONTENT='[defaults]
# Use sync for all mount operations by default
# This ensures data is written immediately to the device.
# Be aware this might slightly slow down operations with many small files.
# For example, sync is generally recommended for SD cards and USB drives
# to prevent data corruption when unplugging.
defaults=dirsync

[ntfs]
defaults=dirsync,uid=0,gid=0,umask=0077

[vfat]
defaults=dirsync,uid=0,gid=0,umask=0077
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
