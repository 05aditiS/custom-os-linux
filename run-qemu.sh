#!/bin/bash
echo "=== Launching Custom OS ==="
echo "Press Ctrl+A then X to exit"
sleep 2

qemu-system-x86_64 \
    -kernel kernel/linux-6.6.8/arch/x86/boot/bzImage \
    -initrd initramfs.cpio.gz \
    -append "console=ttyS0 rdinit=/sbin/init" \
    -m 512M \
    -smp 2 \
    -nographic
