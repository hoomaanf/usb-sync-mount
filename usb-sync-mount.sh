#!/bin/bash

echo "Installing simple & reliable USB write-cache limiter (no dependencies)..."

# Create helper script
HELPER_SCRIPT="/usr/local/bin/usb-cache-limit.sh"

sudo tee "$HELPER_SCRIPT" > /dev/null << 'EOF'
#!/bin/bash

DEVICE="$1"
SPEED="$2"

# Set cache size based on USB speed (without bc)
case "$SPEED" in
    12)      # USB 1.1
        MAX_BYTES=4194304      # 4 MB
        ;;
    480)     # USB 2.0
        MAX_BYTES=16777216     # 16 MB
        ;;
    5000)    # USB 3.0 / 3.1 Gen1
        MAX_BYTES=33554432     # 32 MB
        ;;
    10000)   # USB 3.1 Gen2 / 3.2
        MAX_BYTES=50331648     # 48 MB
        ;;
    *)       # Unknown or fallback
        MAX_BYTES=33554432     # 32 MB
        ;;
esac

# Apply the limits
echo 1 > /sys/block/$DEVICE/bdi/strict_limit 2>/dev/null
echo $MAX_BYTES > /sys/block/$DEVICE/bdi/max_bytes 2>/dev/null
EOF

sudo chmod +x "$HELPER_SCRIPT"

# Create udev rule
RULE_FILE="/etc/udev/rules.d/99-usb-cache-limit.rules"

sudo tee "$RULE_FILE" > /dev/null << EOF
# USB write cache limiter (no dependencies)
ACTION=="add|change", KERNEL=="sd[a-z]", ENV{ID_BUS}=="usb", ENV{DEVTYPE}=="disk", ATTRS{speed}=="?*", RUN+="/usr/local/bin/usb-cache-limit.sh %k %s{speed}"
ACTION=="add|change", KERNEL=="sd[a-z]", ENV{ID_BUS}=="usb", ENV{DEVTYPE}=="disk", ATTRS{speed}=="", RUN+="/usr/local/bin/usb-cache-limit.sh %k 5000"
EOF

# Reload udev
sudo udevadm control --reload-rules
sudo udevadm trigger

echo ""
echo "======================================================"
echo "✅ Done! (No extra packages required)"
echo ""
echo "Please eject and reconnect your USB / Ventoy."
echo "======================================================"
