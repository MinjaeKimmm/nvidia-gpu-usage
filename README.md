# GPU Usage Monitor

This Bash script provides a detailed overview of NVIDIA GPU usage on a multi-user system. It displays information about which users are utilizing which GPUs, along with their associated processes and memory consumption.

## Features

- **Multi-User GPU Usage**: Displays a table showing which users are using which GPUs, along with associated process IDs.
- **Detailed Memory Breakdown**: Provides a breakdown of GPU memory usage per user for each GPU.
- **Visualized Memory Usage**: Uses ASCII bar graphs to visualize memory consumption.
- **Support for Multiple GPUs**: Works seamlessly with multiple NVIDIA GPUs and multiple system users.

## Prerequisites

- **NVIDIA GPU(s)**: The script is designed to work with NVIDIA GPUs.
- **NVIDIA Drivers & Tools**: Make sure you have NVIDIA drivers and the `nvidia-smi` utility installed.
- **Bash Shell**: The script is written for and requires a Bash shell to execute.

## Usage

1. **Clone the Repository**: 
    ```bash
    git clone https://github.com/MinjaeKimmm/nvidia-gpu-usage.git
    ```

    *Or manually copy the script*:

    Navigate to your directory and create a new Bash file:
    ```bash
    vi gpu_usage.sh
    ```
    Then, paste the script's contents and save the file with `:wq`.

2. **Make the Script Executable**:
    ```bash
    chmod +x gpu_usage.sh
    ```

3. **Run the Script**:
    ```bash
    ./gpu_usage.sh
    ```

## Sample Output

<p align="center">
  <img src="https://github.com/MinjaeKimmm/nvidia-gpu-usage/blob/main/Sample_Output.png?raw=true" alt="Sample GPU Usage Output" width="400"/>
</p>
   
