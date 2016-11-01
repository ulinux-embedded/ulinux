# Introduction

# Customizing considerations
The `.config.example` file provides a an example configuration for a Raspberry Pi 2 rootfs that includes packages the authors found necessary. Please customize according to the hardware you wish to use.

## Wireless
Be default, the configuration install `iw` and `wpa_supplicant` for managing and connecting to wireless networks. The authors were using a TP-LINK WN722N which has AR9271 chipset and is driven by the `ath9k_htc` module. Firmware is required for this device and comes from the `linux-firmware` package, specifically the `htc_9271.fw` blob. Your wireless adapter may differ and its configuration may be necessary. We suggest looking into the your device's chipset and its driving module andpossibly required firmware so you can produce a new BuildRoot configuration that contains the required procedures.

### Connect to a wireless network
modprobe ath9k_htc # load kernel module
ip link set wlan0 up # activate network interface
iw dev wlan0 scan # scan for networks
wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf # connect to WPA network, set config in wpa_supplicant.conf
udhcpc -i wlan0 # obtain ip addr via dhcp
date MMddhhmmYYYY # change date; or fix ntpd
