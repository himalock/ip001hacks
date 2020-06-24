/home/ap/stop-ap.sh
wpa_supplicant -B -iwlan0 -c /media/hack/wpa_supplicant.conf
ifconfig wlan0 192.168.1.200/24
route add default gw 192.168.1.1
echo nameserver=8.8.8.8 > /tmp/resolve.conf
