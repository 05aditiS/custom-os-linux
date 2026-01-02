#!/bin/bash
set -e

echo "=========================================="
echo "  Custom OS - Complete Build"
echo "=========================================="

cd "$(dirname "$0")/.."
PROJECT_ROOT=$(pwd)

echo "Project: $PROJECT_ROOT"
echo ""
read -p "Press Enter to start..."

# Build kernel
echo ""
echo "=== STEP 1: BUILD KERNEL ==="
echo "This takes 20-45 minutes..."
cd "$PROJECT_ROOT/kernel"
bash build.sh

echo ""
echo "✓ Kernel done!"
read -p "Press Enter to continue..."

# Build programs
echo ""
echo "=== STEP 2: BUILD PROGRAMS ==="

cd "$PROJECT_ROOT/userland/init"
make clean 2>/dev/null || true
make
echo "✓ Init built"

cd "$PROJECT_ROOT/userland/shell"
make clean 2>/dev/null || true
make
echo "✓ Shell built"

read -p "Press Enter to continue..."

# Create rootfs
echo ""
echo "=== STEP 3: CREATE FILESYSTEM ==="

ROOTFS="$PROJECT_ROOT/rootfs_build"
rm -rf "$ROOTFS"
mkdir -p "$ROOTFS"/{bin,sbin,dev,proc,sys,tmp,root,etc,usr/{bin,sbin},lib/modules}

cp "$PROJECT_ROOT/userland/init/init" "$ROOTFS/sbin/"
cp "$PROJECT_ROOT/userland/shell/sh" "$ROOTFS/bin/"

chmod +x "$ROOTFS/sbin/init"
chmod +x "$ROOTFS/bin/sh"

if [ -d "$PROJECT_ROOT/kernel/modules_install/lib/modules" ]; then
    cp -r "$PROJECT_ROOT/kernel/modules_install/lib/modules"/* "$ROOTFS/lib/modules/"
fi

echo "✓ Filesystem created"
read -p "Press Enter to continue..."

# Create initramfs
echo ""
echo "=== STEP 4: CREATE INITRAMFS ==="

cd "$ROOTFS"
find . -print0 | cpio --null --create --format=newc | gzip -9 > "$PROJECT_ROOT/initramfs.cpio.gz"

echo "✓ initramfs: $(du -h $PROJECT_ROOT/initramfs.cpio.gz | cut -f1)"

# Create run script
cat > "$PROJECT_ROOT/run-qemu.sh" << 'EOF'
#!/bin/bash
echo "=== Launching Custom OS ==="
echo "Press Ctrl+A then X to exit"
sleep 2

qemu-system-x86_64 \
    -kernel kernel/linux-6.6.8/arch/x86/boot/bzImage \
    -initrd initramfs.cpio.gz \
    -append "console=ttyS0 root=/dev/ram0 rw" \
    -m 512M \
    -smp 2 \
    -nographic
EOF

chmod +x "$PROJECT_ROOT/run-qemu.sh"

echo ""
echo "=========================================="
echo "  BUILD COMPLETE! 🎉"
echo "=========================================="
echo ""
echo "To run your OS:"
echo "  cd ~/custom-os"
echo "  ./run-qemu.sh"
echo ""
