#!/bin/bash
# kernel/build.sh - Build Linux kernel

set -e

echo "========================================"
echo "  Building Linux Kernel"
echo "========================================"

KERNEL_VERSION="6.6.8"
KERNEL_DIR="linux-${KERNEL_VERSION}"
KERNEL_ARCHIVE="${KERNEL_DIR}.tar.xz"
KERNEL_URL="https://cdn.kernel.org/pub/linux/kernel/v6.x/${KERNEL_ARCHIVE}"

# Download kernel
echo "[Step 1/5] Downloading kernel..."
if [ ! -f "$KERNEL_ARCHIVE" ]; then
    wget -c "$KERNEL_URL"
fi

# Extract
echo "[Step 2/5] Extracting..."
if [ ! -d "$KERNEL_DIR" ]; then
    tar -xf "$KERNEL_ARCHIVE"
fi

cd "$KERNEL_DIR"

# Configure
echo "[Step 3/5] Configuring..."
if [ ! -f .config ]; then
    make defconfig
fi

# Apply custom settings
echo "[Step 4/5] Applying custom settings..."
scripts/config --enable CONFIG_DRM
scripts/config --enable CONFIG_DRM_KMS_HELPER
scripts/config --enable CONFIG_FB
scripts/config --enable CONFIG_FRAMEBUFFER_CONSOLE
scripts/config --enable CONFIG_DRM_FBDEV_EMULATION
scripts/config --module CONFIG_DRM_BOCHS
scripts/config --module CONFIG_DRM_VIRTIO_GPU
scripts/config --enable CONFIG_INPUT
scripts/config --enable CONFIG_INPUT_KEYBOARD
scripts/config --enable CONFIG_INPUT_EVDEV
scripts/config --enable CONFIG_EXT4_FS
scripts/config --enable CONFIG_TMPFS
scripts/config --enable CONFIG_PROC_FS
scripts/config --enable CONFIG_SYSFS
scripts/config --enable CONFIG_DEVTMPFS
scripts/config --enable CONFIG_DEVTMPFS_MOUNT
scripts/config --disable CONFIG_SYSTEMD

# Build
echo "[Step 5/5] Building kernel (this takes 20-45 minutes)..."
echo "CPU cores: $(nproc)"
yes "" | make -j$(nproc) bzImage modules

echo "Installing modules..."
mkdir -p ../modules_install
make INSTALL_MOD_PATH=../modules_install modules_install
echo ""
echo "✓ Kernel build complete!"
echo "Location: $(pwd)/arch/x86/boot/bzImage"
