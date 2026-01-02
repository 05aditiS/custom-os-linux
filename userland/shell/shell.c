#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <dirent.h>

#define MAX_CMD 1024
#define MAX_ARGS 64

void print_prompt(void) {
    char cwd[256];
    getcwd(cwd, sizeof(cwd));
    printf("\033[32mcustom-os\033[0m:\033[34m%s\033[0m$ ", cwd);
    fflush(stdout);
}

int builtin_ps(void) {
    DIR *proc = opendir("/proc");
    if (!proc) return 1;
    
    printf("PID    COMMAND\n");
    struct dirent *entry;
    while ((entry = readdir(proc)) != NULL) {
        if (entry->d_name[0] >= '0' && entry->d_name[0] <= '9') {
            char path[512];
            snprintf(path, sizeof(path), "/proc/%s/comm", entry->d_name);
            FILE *f = fopen(path, "r");
            if (f) {
                char comm[256];
                if (fgets(comm, sizeof(comm), f)) {
                    comm[strcspn(comm, "\n")] = 0;
                    printf("%-6s %s\n", entry->d_name, comm);
                }
                fclose(f);
            }
        }
    }
    closedir(proc);
    return 0;
}

int main(void) {
    char cmd[MAX_CMD];
    char *args[MAX_ARGS];
    
    printf("\n=== Custom OS Shell ===\n");
    printf("Built by Aditi\n");
    printf("Commands: cd, exit, ps, clear, or any program\n\n");
    
    while (1) {
        print_prompt();
        
        if (!fgets(cmd, sizeof(cmd), stdin)) break;
        cmd[strcspn(cmd, "\n")] = 0;
        if (strlen(cmd) == 0) continue;
        
        int i = 0;
        args[i] = strtok(cmd, " ");
        while (args[i] && i < MAX_ARGS - 1) {
            args[++i] = strtok(NULL, " ");
        }
        
        if (strcmp(args[0], "exit") == 0) {
            printf("Goodbye!\n");
            exit(0);
        }
        
        if (strcmp(args[0], "cd") == 0) {
            if (args[1] == NULL) {
                chdir("/root");
            } else if (chdir(args[1]) != 0) {
                perror("cd");
            }
            continue;
        }
        
        if (strcmp(args[0], "clear") == 0) {
            printf("\033[2J\033[H");
            continue;
        }
        
        if (strcmp(args[0], "ps") == 0) {
            builtin_ps();
            continue;
        }
        
        pid_t pid = fork();
        if (pid == 0) {
            execvp(args[0], args);
            printf("Error: command not found: %s\n", args[0]);
            exit(127);
        } else if (pid > 0) {
            waitpid(pid, NULL, 0);
        }
    }
    
    return 0;
}
