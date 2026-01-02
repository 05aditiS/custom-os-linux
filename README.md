Custom Linux-Based Operating System
Overview

This project implements a minimal Linux-based operating system built from source. The system focuses on low-level operating system concepts including kernel configuration, process initialization, filesystem mounting, and userland execution without relying on systemd or full GNU userland utilities.

The OS boots in a virtualized environment using QEMU and operates entirely from an initramfs-based root filesystem.

System Architecture
QEMU Virtual Machine
        ↓
Custom Linux Kernel (v6.6.x)
        ↓
Custom Init Process (PID 1)
        ↓
Minimal Shell
        ↓
User Programs

Boot Flow

Custom Linux kernel is compiled with required subsystems enabled.

Kernel boots using an initramfs root filesystem.

Kernel launches a custom init process as PID 1.

Init mounts virtual filesystems and supervises child processes.

Shell provides user interaction and process execution.

Key Features

Custom init system running as PID 1

Minimal statically linked shell

Manual filesystem mounting (/proc, /sys, /dev)

Process supervision and signal handling

Kernel built with DRM/KMS and input support enabled

Clean, reproducible QEMU boot pipeline

Technologies Used

Language: C

Kernel: Linux 6.6.x

Virtualization: QEMU

Build Tools: GCC, Make

Filesystem: initramfs

Learning Outcomes

Understanding of Linux boot internals

Hands-on experience with process management

Exposure to kernel–userland boundaries

Foundation for advanced OS and systems research

Future Work

Custom memory allocator

Direct framebuffer rendering using DRM

Asynchronous input handling
