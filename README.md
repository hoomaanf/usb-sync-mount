```markdown
# 🔒 USB Sync Mount – Disable Write Cache for External Drives (udisks2)

**Prevent data loss and file system corruption on USB drives with a single script.**

## 🧠 The Problem

Linux caches file writes in RAM before actually writing them to the USB drive. If you unplug the drive too quickly:

- ❌ Files appear complete but are partially written
- ❌ File system metadata can become corrupted (drive becomes unreadable)
- ❌ "Safe to Remove" does not guarantee data is fully on disk

The solution is to use **`dirsync`** — a balanced mount option that keeps your file system structure safe without destroying performance.

---

## ✅ What This Script Does

| Before (Default: `async`) | After (This Script: `dirsync`) |
|----------------------------|--------------------------------|
| Everything is cached in RAM | **Folder structure** is written immediately |
| Yanking the drive risks corruption | **File system integrity is protected** |
| Progress bars are misleading | Progress is more accurate |
| Maximum write speed | Good write speed with real safety |

> 💡 **Why not full `sync`?** Full `sync` writes all data immediately — making transfers painfully slow. `dirsync` hits the sweet spot: your data writes fast, but the folder structure is always safe.

---

## 📦 Installation

### 1. Clone and run

```bash
git clone https://github.com/hoomaanf/usb-sync-mount.git
cd usb-sync-mount
chmod +x usb-sync-mount.sh
./usb-sync-mount.sh
```

### 2. Done

No reboot needed. Just unplug and reconnect your USB drive for changes to take effect.

---

## 🧹 Uninstall / Revert to Default

To restore original (fully cached/unsafe) behavior:

```bash
sudo rm /etc/udisks2/mount_options.conf
sudo systemctl restart udisks2.service
```

---

## 🔍 How It Works

This script creates the file `/etc/udisks2/mount_options.conf` with:

```ini
[defaults]
defaults=dirsync

[ntfs]
defaults=dirsync,uid=$UID,gid=$GID,umask=0077

[vfat]
defaults=dirsync,uid=$UID,gid=$GID,umask=0077
```

**`dirsync`** tells the kernel to write directory metadata (file names, sizes, timestamps) directly to the device, while file contents are still written asynchronously through RAM. This gives you strong protection against file system corruption after an unsafe unplug, without the severe speed penalty of full `sync`.

---

## 🐧 Compatibility

- Arch Linux
- Ubuntu / Debian
- Fedora
- Any Linux distribution using `udisks2`

---

## 🤝 Credits

Made with 🐧 and ❤️ by [hoomaanf](https://github.com/hoomaanf)

---

**If this saved your USB drive, give it a star! ⭐**
