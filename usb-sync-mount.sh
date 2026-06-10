#!/bin/bash
echo "Creating or updating udisks2 configuration file..."
CONFIG_FILE="/etc/udisks2/mount_options.conf"
CONFIG_CONTENT='[defaults]
defaults=

[ntfs]
defaults=uid=0,gid=0,umask=0077

[vfat]
defaults=uid=0,gid=0,umask=0077

[exfat]
defaults=uid=0,gid=0,umask=0077

[ext2]
defaults=

[ext3]
defaults=

[ext4]
defaults=

[btrfs]
defaults=

[xfs]
defaults=

[f2fs]
defaults=

[udf]
defaults=

[iso9660]
defaults=ro

[hfsplus]
defaults=uid=0,gid=0,umask=0077

[hfs]
defaults=uid=0,gid=0,umask=0077

[minix]
defaults=

[nilfs2]
defaults=

[jfs]
defaults=

[reiserfs]
defaults=
'
sudo mkdir -p "$(dirname "$CONFIG_FILE")"
echo "$CONFIG_CONTENT" | sudo tee "$CONFIG_FILE" > /dev/null
if [ $? -eq 0 ]; then
    echo "Configuration file successfully saved to $CONFIG_FILE."
else
    echo "Error saving configuration file."
    exit 1
fi
echo "Restarting udisks2 service..."
sudo systemctl restart udisks2.service
if [ $? -eq 0 ]; then
    echo "udisks2 service restarted successfully."
else
    echo "Error restarting udisks2 service."
    exit 1
fi
echo "Script finished."
exit 0
