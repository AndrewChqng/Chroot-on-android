#!/bin/sh
while ! ping -c 1 -W 1 1.1.1.1; do
    echo "Waiting for 1.2.3.4 - network interface might be down..."
    sleep 1
done
chroot /data/ubu/ /bin/su -c "/bin/screen -DmS mc /root/mc/start.sh"
