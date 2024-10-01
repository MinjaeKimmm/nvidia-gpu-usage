#!/bin/bash

# Function to get unique and sorted items
sort_unique() {
    echo "$1" | tr ',' '\n' | sort -un | tr '\n' ',' | sed 's/,$//'
}

(echo "---" && nvidia-smi --format=csv,noheader,nounits --query-gpu=index,memory.total && echo "---" && nvidia-smi --format=csv,noheader,nounits --query-compute-apps=gpu_uuid,pid,used_memory) | 
awk -F', ' '
BEGIN {
    FS = ", "
    printf "+-----------------------------------------------------------------------+\n"
    printf "| %-10s | %-16s | %-37s |\n", "User", "GPUs", "PIDs"
    printf "+-----------------------------------------------------------------------+\n"
}
$0 == "---" {
    data_section++
    next
}
data_section == 1 {
    total_mem[$1] = $2
    next
}
data_section == 2 {
    cmd = "nvidia-smi --format=csv,noheader,nounits --query-gpu=index --id=" $1
    cmd | getline gpu_index
    close(cmd)
    cmd = "ps -o user= -p " $2 " 2>/dev/null"
    cmd | getline user
    close(cmd)
    if (user != "") {
        users[user] = users[user] ? users[user] "," gpu_index : gpu_index
        pids[user] = pids[user] ? pids[user] "," $2 : $2
        mem = $3
        gpu_mem[user,gpu_index] = gpu_mem[user,gpu_index] ? gpu_mem[user,gpu_index] + mem : mem
        if (!(gpu_index in gpu_users)) {
            gpu_users[gpu_index] = user
        } else if (index(gpu_users[gpu_index], user) == 0) {
            gpu_users[gpu_index] = gpu_users[gpu_index] "," user
        }
    }
}
END {
    for (user in users) {
        split(users[user], gpus, ",")
        split(pids[user], pid_arr, ",")
        gpu_str = sort_unique(gpus)
        pid_str = sort_unique(pid_arr)
        printf "| %-10s | %-16s | %-37s |\n", user, gpu_str, pid_str
    }
    printf "+-----------------------------------------------------------------------+\n"
    printf "\n"
    printf "+-----------------------------------------------------------------------+\n"
    printf "| GPU Memory Usage:                                                     |\n"
    printf "+-----+---------------+-------------------------------------------------+\n"
    printf "| GPU | Total Memory  | Usage per User                                  |\n"
    printf "+-----+---------------+-------------------------------------------------+\n"
    for (gpu_index in total_mem) {
        printf "| %-3s | %-13s |", gpu_index, total_mem[gpu_index] " MiB"
        if (gpu_index in gpu_users) {
            split(gpu_users[gpu_index], users_arr, ",")
            first_user = 1
            for (i in users_arr) {
                user = users_arr[i]
                mem_used = gpu_mem[user,gpu_index]
                percentage = mem_used / total_mem[gpu_index] * 100
                bar = ""
                for (j = 0; j < int(percentage/5); j++) bar = bar "█"
                for (j = int(percentage/5); j < 20; j++) bar = bar "░"
                if (first_user) {
                    printf " %-8s: %5d MiB %5.1f%% %s |\n", user, mem_used, percentage, bar
                    first_user = 0
                } else {
                    printf "|     |               | %-8s: %5d MiB %5.1f%% %s |\n", user, mem_used, percentage, bar
                }
            }
        } else {
            printf " %-8s: %5d MiB %5.1f%% %s |\n", "N/A", 0, 0, "░░░░░░░░░░░░░░░░░░░░"
        }
        printf "+-----+---------------+-------------------------------------------------+\n"
    }
}
function sort_unique(arr, i, j, temp, n, result) {
    n = 0
    for (i in arr) {
        n++
        temp[n] = arr[i]
    }
    for (i = 1; i < n; i++)
        for (j = i + 1; j <= n; j++)
            if (temp[i] > temp[j]) {
                t = temp[i]
                temp[i] = temp[j]
                temp[j] = t
            }
    result = temp[1]
    for (i = 2; i <= n; i++)
        if (temp[i] != temp[i-1])
            result = result "," temp[i]
    return result
}'
