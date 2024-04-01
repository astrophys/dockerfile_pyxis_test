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

## Install
Installing `enroot` and `pyxis` on compute and head nodes:
1. Dependencies
```
$ apt-get install -y jq pigz parallel
```

2. `enroot`
```
$ arch=$(dpkg --print-architecture)
$ curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v3.4.1/enroot_3.4.1-1_${arch}.deb
$ apt install ./enroot_3.4.1-1_amd64.deb
# To run squashfs files via enroot
$ apt-get install -y squashfuse fuse-overlayfs
```

3. `pyxis`, on head node :
```
$ cm-wlm-setup --add-pyxis --wlm slurm --wlm-cluster-name=slurm	# does compute AND head nodes
$ systemctl restart slurmctld
$ pdsh -w n[01,02] systemctl restart slurmd
$ srun --help | grep container	# check that new options are available
```

4. If you want Docker so you can build the Dockerfile, here are the steps

    a) If using a VM via vSphere client, you may need power off the machine and enable `Expose hardware assisted virtualization to the guest OS`.

    b) Check that you have kvm kernel modules
    ```
    $ apt install cpu-checker     # Might need this
    $ lsmod | grep kvm
    $ kvm-ok
    ```

    c) [Install Docker](https://docs.docker.com/engine/install/ubuntu/)
    ```
    $ sudo apt-get update
    $ sudo apt-get install ./docker-desktop-4.28.0-amd64.deb
    $ apt-get install ca-certificates curl
    $ install -m 0755 -d /etc/apt/keyrings
    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyr    ings/docker.asc
    $ chmod a+r /etc/apt/keyrings/docker.asc
    $ echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    $ apt-get update
    $ apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-p    lugin docker-compose-plugin
    $ ps -ef | grep docker      # Docker Daemon is actually running now
    $ docker run hello-world        # WORKS!
    ```

## Build

To build a docker image from this Dockerfile
```
$ gcc -static src/main.c -o hello
$ sudo docker build --tag hello .
$ sudo docker image ls                     # should show up
```

## Run
```
$ docker run hello
```

## Export from Docker to squashfs
1. Find the image name. You'd think you could get it from `docker image ls`, but you can't.  Non-intuitively :
```
$ docker ps -a      # look under NAME column
$ mkdir dockerout
$ docker export optimistic_almeida | tar -C dockerout -p -s --same-owner -xv
$ mksquashfs dockerout hello.sqsh
```

## Export from Docker to squashfs
```
```

## Run with Enroot
```
$ enroot create --name hello hello.sqsh
$ /root/.local/share/enroot/        # hello should be there now
$ enroot list                       # shows as much
```

