# Custom Linux-Based Operating System

A minimal Linux-based operating system built from source to explore low-level operating system concepts such as kernel configuration, process initialization, filesystem mounting, and userland execution.

This project intentionally avoids `systemd` and full GNU userland utilities to maintain transparency and control over the OS boot and execution pipeline.

---

## 🚀 Overview

The operating system boots inside a **QEMU virtual machine** using a **custom-compiled Linux kernel** and an **initramfs-based root filesystem**.  
A custom init process runs as **PID 1**, mounts essential virtual filesystems, and supervises user processes through a minimal shell.

The project focuses on **understanding OS internals**, not on providing a full-featured Linux distribution.

---

## 🧱 System Architecture


QEMU Virtual Machine
        ↓
Custom Linux Kernel (v6.6.x)
        ↓
Custom Init Process (PID 1)
        ↓
Minimal Shell
        ↓
User Programs


---

## 🔁 Boot Flow

1. Linux kernel is compiled from source with required subsystems enabled.
2. Kernel boots inside QEMU using an initramfs root filesystem.
3. Kernel launches a custom init process as PID 1.
4. Init mounts `/proc`, `/sys`, `/dev`, and `/tmp`.
5. Init spawns and supervises a minimal shell.
6. Shell provides user interaction and process execution.

---

## ✨ Key Features

- Custom init system running as **PID 1**
- Minimal statically linked shell written in C
- Manual filesystem mounting (`/proc`, `/sys`, `/dev`, `/tmp`)
- Process supervision and signal handling (`SIGCHLD`)
- Process inspection using the `/proc` filesystem
- Kernel configured with DRM/KMS and input subsystems
- Reproducible QEMU-based boot pipeline

---

## 🧠 What I Implemented vs What Linux Provides

| Component | Implemented in Project | Provided by Kernel |
|--------|----------------------|------------------|
| Kernel compilation & config | ✅ | |
| Init system (PID 1) | ✅ | |
| Shell | ✅ | |
| Filesystem mounting | ✅ | |
| Process supervision | ✅ | |
| Scheduling & VM | | ✅ |
| Device drivers | | ✅ |

---

## 🛠️ Technologies Used

- **Language:** C  
- **Kernel:** Linux 6.6.x  
- **Virtualization:** QEMU  
- **Build Tools:** GCC, Make  
- **Filesystem:** initramfs  

---

## 🧪 Testing & Validation

The system was tested inside QEMU by:

- Verifying the custom init process runs as PID 1
- Inspecting kernel threads and processes via `/proc`
- Confirming correct shell execution and respawn behavior
- Debugging early kernel panics related to VFS root mounting

---

## 📌 Design Decisions

- Full GNU userland utilities are excluded intentionally
- Only explicitly implemented binaries are available
- Static linking ensures minimal runtime dependencies
- Simplicity and clarity are prioritized over feature completeness

---

## 🚧 Limitations

- No persistent storage support
- Graphics support is kernel-enabled but not exercised in userland
- Minimal shell functionality by design

---

## 🔮 Future Enhancements

- Custom userland memory allocator
- Direct framebuffer rendering using DRM/KMS
- Asynchronous input handling
- Security and sandboxing experiments

---

## 🎓 Academic Relevance

This project demonstrates practical experience with:

- Linux boot internals
- Kernel–userland boundaries
- Process lifecycle management
- Low-level systems programming

It serves as a strong foundation for advanced coursework and research in **Operating Systems**, **Systems Programming**, and **Computer Science**.

