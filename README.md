# ⚡ USB Mount Config – Real-Time Accurate Copy Speeds (udisks2)

**Make external drives (USB, HDD, SD Card, etc.) behave with **accurate real-time write speeds** like Windows.**

## 🧠 The Problem
By default, Linux uses heavy caching on external drives. This causes:
- Progress bars show **artificially high speeds**
- Copy finishes instantly at the end (cache flush)
- Feels "fake" compared to Windows

---

## ✅ What This Script Does
- Enables **`sync`** mode on all common removable filesystems
- Shows **real hardware write speeds** during copy
- Progress bar reflects actual disk writes (no sudden finish)
- Fixes permission issues on NTFS, exFAT, FAT32
- Works on all removable drives automatically

> 💡 **Note:** Write speeds will be lower than cached mode (this is expected — it's honest).  
> Always use "Eject" before unplugging.

---

## 📦 Installation

### Method 1: One-line install (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/hoomaanf/usb-sync-mount/main/usb-sync-mount.sh | sudo bash
```

### Method 2: Manual
```bash
git clone https://github.com/hoomaanf/usb-sync-mount.git
cd usb-sync-mount
chmod +x usb-sync-mount.sh
sudo ./usb-sync-mount.sh
```

### 3. Done
No reboot needed. Just **eject and reconnect** your external drive.

---

## 🧹 Uninstall / Revert to Default
```bash
sudo rm -f /etc/udisks2/mount_options.conf
sudo systemctl restart udisks2.service
echo "✅ Reverted to default udisks2 behavior."
```

---

## 🔍 Configuration Applied

The script creates this configuration:

```ini
[defaults]
defaults=

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
```

---

## 🐧 Compatibility
- Ubuntu / Debian / Linux Mint
- Fedora / RHEL / CentOS
- Arch Linux / Manjaro
- Any modern distribution using **udisks2**

---

## 🤝 Credits
Made with 🐧 and ❤️ by [hoomaanf](https://github.com/hoomaanf)

---
**If this made your copy experience more honest and Windows-like, give it a star! ⭐**
