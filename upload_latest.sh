#!/bin/bash

time curl -i --verbose --header "Authorization: Bearer 123123" -F "file=@mainfs-buildroot/output/images/rootfs.ext2" -k --progress-bar https://sign:9443/updates/
