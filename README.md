# ⚡ USB Write-Cache Limiter – Real-Time Accurate Copy Speeds (udev + bdi)

**Make external drives (USB flash, HDD, SSD, SD Card, etc.) report their real
write speed while copying — just like Windows — with no extra packages and
no dependencies.**

---

## 🧠 The Problem

By default, Linux buffers writes to external drives heavily in RAM (the
page cache / dirty pages). This causes:

- Progress bars to show **artificially high speeds** at the start of a copy
- The copy to appear to "finish" almost instantly, while the kernel is
  still silently flushing data in the background
- A long, confusing freeze on `eject` / `umount` while the real write
  actually happens
- No way to know the *true* transfer speed until it's too late

---

## ✅ What This Script Does

- Installs a small helper script + a `udev` rule — **no packages, no
  `bc`, no `udisks2` config, nothing to install**
- Detects the USB link speed of every plugged-in disk (`sd[a-z]`) and sets
  a **per-device write-back cache limit** via
  `/sys/block/<dev>/bdi/max_bytes` and `/sys/block/<dev>/bdi/strict_limit`
- Once the kernel's per-device dirty-page cache hits that limit, it is
  forced to actually flush to the physical disk before accepting more
  writes — so the speed you see in `cp`/`rsync`/your file manager reflects
  the **real, sustained write speed of the disk**, not the RAM cache
- Cache size auto-scales with detected USB speed:

  | USB speed        | Cache limit |
  |-------------------|-------------|
  | USB 1.1 (12 Mbps)  | 4 MB        |
  | USB 2.0 (480 Mbps)  | 16 MB       |
  | USB 3.0 / 3.1 Gen1 (5000 Mbps) | 32 MB |
  | USB 3.1 Gen2 / 3.2 (10000 Mbps) | 48 MB |
  | Unknown / no speed attribute | 32 MB (fallback) |

- Runs automatically on every USB disk `add`/`change` event via a udev
  rule — no manual step needed after install
- Filesystem-agnostic: it works at the block-device layer, so it applies
  the same way to NTFS, exFAT, FAT32, ext4, etc.

> 💡 **Note:** Reported write speeds will be lower and more "honest" than
> the old cached behavior — that's expected, it's the real speed of your
> disk, not RAM.
> ⚠️ Always use "Eject" before unplugging, even with this installed.

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
chmod +x usb-cache-limit.sh
sudo ./usb-cache-limit.sh
```

### 3. Done

No reboot needed. Just **eject and reconnect** your external drive (or
run `sudo udevadm trigger` yourself) for the rule to apply to an already
connected disk.

---

## 🔍 Verifying It Worked

After reconnecting your drive, find its device name:

```bash
lsblk -o NAME,SIZE,TRAN,MOUNTPOINTS
```

Then check (replace `sdX` with your actual whole-disk name, e.g. `sde` —
**not** a partition like `sde1`):

```bash
cat /sys/block/sdX/bdi/strict_limit   # should print 1
cat /sys/block/sdX/bdi/max_bytes      # should print ~4–48 MB, not GBs
```

Copy a large test file and watch the real sustained speed:

```bash
rsync -av --progress /path/to/large/file /media/YOUR_USB_MOUNT/
```

The reported speed should stay steady and match the real hardware speed
of your drive — no fake burst at the start, no long hang at the end.

---

## 🧹 Uninstall / Revert to Default

```bash
sudo rm -f /usr/local/bin/usb-cache-limit.sh
sudo rm -f /etc/udev/rules.d/99-usb-cache-limit.rules
sudo udevadm control --reload-rules
sudo udevadm trigger
echo "✅ Reverted to default Linux write-caching behavior."
```

*(Already-connected drives keep the applied limit until you unplug and
reconnect them, or reboot.)*

---

## ⚙️ How It Works Under the Hood

1. A udev rule matches any `sd[a-z]` block device where `ID_BUS=="usb"`
   and `DEVTYPE=="disk"` (whole disks only, not partitions), on `add` or
   `change` events.
2. It reads the device's link speed from `ATTRS{speed}` (falls back to
   `5000` — i.e. USB 3.0 — if the attribute is empty, which happens with
   some USB-to-SATA/NVMe bridge chips that don't expose it).
3. It calls `/usr/local/bin/usb-cache-limit.sh <device> <speed>`, which
   sets `bdi/strict_limit=1` and `bdi/max_bytes=<limit>` for that specific
   device in `/sys/block/`.
4. From then on, the kernel enforces that dirty-page limit strictly for
   *that device only* — other disks (including your system drive) are
   unaffected.

---

## 🐧 Compatibility

- Ubuntu / Debian / Linux Mint
- Fedora / RHEL / CentOS
- Arch Linux / Manjaro
- Any modern distro running a Linux kernel with per-BDI dirty-limit
  support (mainline for a long time) and `udev`

---

## 🤝 Credits

Made with 🐧 and ❤️ by [hoomaanf](https://github.com/hoomaanf)

---

**If this made your copy experience more honest and Windows-like, give it a star! ⭐**
