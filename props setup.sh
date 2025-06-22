#!/bin/sh
resetprop ro.secure 0
resetprop service.adb.tcp.port 5555
setenforce 0
#swapoff /dev/block/zram0
resetprop ro.config.low_ram true
