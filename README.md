```markdown
# ⚡ USB Mount Config – Optimize External Drive Performance (udisks2)
**Get real write speeds and prevent permission issues on external drives with a single script.**

## 🧠 The Problem
Linux's default udisks2 configuration can cause two issues with external drives:
- 🐢 `dirsync` / `sync` mount options cause **artificially slow write speeds** — progress bars lie
- 🔒 Incorrect `uid`/`gid`/`umask` settings cause **permission issues** on NTFS, vfat, exfat drives

---

## ✅ What This Script Does
| Before (dirsync) | After (This Script) |
|-------------------|----------------------|
| Directory writes are forced to disk immediately | Kernel cache is used freely |
| Write speed is artificially throttled | **Real hardware write speed** |
| Progress bars show fake speeds | Progress reflects actual throughput |
| File system structure "safe" on unsafe unplug | Standard async behavior (same as Windows/macOS) |

> 💡 **Safe removal:** Always use your file manager's "Eject" or run `sync` before unplugging.
> This is the same behavior as Windows and macOS — not unsafe, just honest.

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
No reboot needed. Just unplug and reconnect your drive for changes to take effect.

---

## 🧹 Uninstall / Revert to Default
```bash
sudo rm /etc/udisks2/mount_options.conf
sudo systemctl restart udisks2.service
```

---

## 🔍 How It Works
This script creates `/etc/udisks2/mount_options.conf` without `dirsync` or `sync`:

```ini
[defaults]
defaults=

[ntfs]
defaults=uid=0,gid=0,umask=0077

[vfat]
defaults=uid=0,gid=0,umask=0077

[exfat]
defaults=uid=0,gid=0,umask=0077
```

Removing `dirsync` lets the kernel handle caching normally — the same way Windows and macOS do.
`uid=0,gid=0,umask=0077` ensures correct permissions on FAT-based filesystems.

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
**If this helped your transfer speeds, give it a star! ⭐**
