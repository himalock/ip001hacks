#!/bin/sh

# ANT-THOMAS
############
# HACKS HERE

# mount sd card to separate location
if [ -b /dev/mmcblk0p1 ]; then
	mount -t vfat /dev/mmcblk0p1  /media
elif [ -b /dev/mmcblk0 ]; then
	mount -t vfat /dev/mmcblk0 /media
fi

# confirm hack type
touch /home/HACKSD

mkdir -p /home/busybox

# install updated version of busybox
mount --bind /media/hack/busybox /bin/busybox
/bin/busybox --install -s /home/busybox

# set new env
mount --bind /media/hack/profile /etc/profile

# possibly needed but may not be
mount --bind /media/hack/group /etc/group
mount --bind /media/hack/passwd /etc/passwd
mount --bind /media/hack/shadow /etc/shadow

# update hosts file to prevent communication
mount --bind /media/hack/hosts.new /etc/hosts

# busybox httpd
/home/busybox/httpd -p 8080 -h /media/hack/www

# setup and install dropbear ssh server - no password login
/media/hack/dropbearmulti dropbear -r /media/hack/dropbear_ecdsa_host_key -B

# telnetd killed
(sleep 20 && killall telnetd) &

# start ftp server
(/home/busybox/tcpsvd -E 0.0.0.0 21 /home/busybox/ftpd -w / ) &

# wifi connect delay start-ap.sh
(sleep 30 && sh /media/hack/connect_wifi.sh ) &

# timezone JST-9 time sync
NTP_SERVER=ntp.jst.mfeed.ad.jp
(sleep 40 && echo "JST-9" > /home/etc/TZ && \
             /home/busybox/ntpd -S 60 -p $NTP_SERVER ) &

# silence the voices - uncomment if needed
#if [ ! -f /home/VOICE-orig.tgz ]; then
#    cp /home/VOICE.tgz /home/VOICE-orig.tgz
#fi
#
#cp /media/hack/VOICE-new.tgz /home/VOICE.tgz

#
############

