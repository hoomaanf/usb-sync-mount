#!/bin/bash
echo "Creating or updating udisks2 configuration file for all removable drives..."

CONFIG_FILE="/etc/udisks2/mount_options.conf"

CONFIG_CONTENT='[defaults]
defaults=

# =============================================
# Removable drives - Mount with sync mode (accurate copy speed like Windows)
# =============================================
[ntfs]
defaults=uid=0,gid=0,umask=0077,sync

[vfat]
defaults=uid=0,gid=0,umask=0077,sync,flush

[exfat]
defaults=uid=0,gid=0,umask=0077,sync

[ext2]
defaults=sync

[ext3]
defaults=sync

[ext4]
defaults=sync

[btrfs]
defaults=sync

[xfs]
defaults=sync

[f2fs]
defaults=sync

[udf]
defaults=sync

[iso9660]
defaults=ro,sync

[hfsplus]
defaults=uid=0,gid=0,umask=0077,sync

[hfs]
defaults=uid=0,gid=0,umask=0077,sync

[minix]
defaults=sync

[nilfs2]
defaults=sync

[jfs]
defaults=sync

[reiserfs]
defaults=sync
'

sudo mkdir -p "$(dirname "$CONFIG_FILE")"
echo "$CONFIG_CONTENT" | sudo tee "$CONFIG_FILE" > /dev/null

if [ $? -eq 0 ]; then
    echo "✅ Configuration file successfully saved to $CONFIG_FILE"
else
    echo "❌ Error saving configuration file."
    exit 1
fi

echo "Restarting udisks2 service..."
sudo systemctl restart udisks2.service

if [ $? -eq 0 ]; then
    echo "✅ udisks2 service restarted successfully."
else
    echo "❌ Error restarting udisks2 service."
    exit 1
fi

echo "=================================================="
echo "🎉 Done! All external drives (HDD, USB flash, SD cards, etc.)"
echo "will now be mounted in sync mode (accurate real-time copy speed like Windows)."
echo "Please safely eject and reconnect your external drive."
echo "=================================================="
exit 0
