#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <signal.h>
#include <string.h>

void sigchld_handler(int sig) {
    (void)sig;
    int status;
    while (waitpid(-1, &status, WNOHANG) > 0);
}

int main(void) {
    printf("\n=== Custom OS Init System ===\n\n");
    
    if (getpid() != 1) {
        fprintf(stderr, "Error: init must be PID 1\n");
        return 1;
    }
    
    signal(SIGCHLD, sigchld_handler);
    
    printf("[init] Mounting filesystems...\n");
    mkdir("/proc", 0755);
    mkdir("/sys", 0755);
    mkdir("/dev", 0755);
    mkdir("/tmp", 0755);
    
    mount("proc", "/proc", "proc", 0, NULL);
    mount("sysfs", "/sys", "sysfs", 0, NULL);
    mount("devtmpfs", "/dev", "devtmpfs", 0, NULL);
    mount("tmpfs", "/tmp", "tmpfs", 0, NULL);
    
    printf("[init] Filesystems mounted\n");
    printf("[init] Starting shell...\n\n");
    
    while (1) {
        pid_t pid = fork();
        
        if (pid == 0) {
            char *argv[] = {"/bin/sh", NULL};
            char *envp[] = {
                "PATH=/bin:/sbin:/usr/bin",
                "HOME=/root",
                "TERM=linux",
                NULL
            };
            execve("/bin/sh", argv, envp);
            perror("execve");
            exit(1);
        }
        
        int status;
        waitpid(pid, &status, 0);
        printf("\n[init] Shell exited, respawning...\n\n");
        sleep(1);
    }
    
    return 0;
}
