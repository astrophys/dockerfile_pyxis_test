# Dockerfile / Pyxis Test
### Author : Ali Snedden
### Date   : 26-march-2024
### License: GPL-3

This is my first attempt at using Dockerfile in service of understanding enroot / pyxis.
I am familiar with building Singularity containers. I need to learn how to build
Docker images so I can deploy them on a BCM cluster with `enroot` / `pyxis`.

## Environment
This code was tested on a [BCM](https://developer.nvidia.com/bright-cluster-manager)-deployed HPC system running BCM-9.2 with Ubuntu 20.04.6.
If [pyxis](https://github.com/NVIDIA/pyxis) and [enroot](https://github.com/NVIDIA/enroot) isn't installed, install it.

Installing `enroot` and `pyxis` on compute and head nodes:
1. Dependencies
```
apt-get install -y jq pigz parallel
```

2. `enroot`
```
arch=$(dpkg --print-architecture)
curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v3.4.1/enroot_3.4.1-1_${arch}.deb
apt install ./enroot_3.4.1-1_amd64.deb
```

3. `pyxis`, on head node :
```
cm-wlm-setup --add-pyxis --wlm slurm --wlm-cluster-name=slurm	# does compute AND head nodes
systemctl restart slurmctld
pdsh -w n[01,02] systemctl restart slurmd
srun --help | grep container	# check that new options are available
```

## Build

## Run

## Install

