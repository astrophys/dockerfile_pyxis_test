##### This is a sparse / bare bones image
### # syntax=docker/dockerfile:1
# https://hub.docker.com/_/scratch
# No kernel attached either
### FROM scratch
### ADD hello /
### SHELL ["/bin/bash"]
### #CMD ["./hello"]                # Works
### #CMD ["/bin/bash", "./hello"]   # fails
### CMD ["/usr/bin/echo"]           # DNE
### #CMD ["set"]

### CMD ["cat", "/etc/os-release", ";", "set"]      # CANNOT daisy chain commands


####### THIS ALSO WORKS WITH ENROOT, it will not execute CMD, but 
# enroot start hello_02apr2024_cat.sqsh will drop you into a shell
FROM ubuntu
ADD hello /
#SHELL ["/bin/bash"]
CMD ["cat", "/etc/os-release"]

###### THIS WORKED WITH ENROOT!!! 
# enroot start hello_02apr2024.sqsh ## puts you in an interactive shell
# docker run -i -t hello   ## Drops you into an interactive shell
# FROM ubuntu
# ADD hello /
# SHELL ["/bin/bash"]
# CMD ["/bin/bash"]
