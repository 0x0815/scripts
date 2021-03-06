#!/bin/bash

#Serial Number
/usr/bin/sudo /usr/sbin/dmidecode -t system | grep "Serial Number: " | awk '{ print substr($0, index($0,$3)) }' >> logfile2.txt
printf -- "\\r\n" >> logfile2.txt

#Bios Ver
/usr/bin/sudo /usr/sbin/dmidecode -t system | grep "Version: " | awk '{ print substr($0, index($0,$2)) }' >> logfile2.txt
printf -- "\\r\n" >> logfile2.txt

#Model
/usr/bin/sudo /usr/sbin/dmidecode -t system | grep "Product Name:" | awk '{ print substr($0, index($0,$3)) }' >> logfile2.txt
printf -- "\\r\n" >> logfile2.txt

#Processor

if [ -f /proc/cpuinfo ]; then
    grep -m 1 "model name" /proc/cpuinfo | cut -d: -f2 | sed -e 's/^ *//' | awk '{print $0}' >> logfile2.txt
    printf -- "\\r\n" >> logfile2.txt
fi

#RAM

grep MemTotal /proc/meminfo | awk '{print $2/1024/1024}' | perl -nl -MPOSIX -e 'print ceil($_);' | awk '{print $1" GB"}' >> logfile2.txt
printf -- "\\r\n" >> logfile2.txt

#OS

lsb_release -a | head -n 2 | tail -n 1 | awk '{print substr ($0, index ($0,$2))}' >> logfile2.txt
printf -- "\\r\n" >> logfile2.txt

#HDD SIZE
awk '/sd[a-z]$/{printf "%s %8.2f GiB\n", $NF, $(NF-1) / 1024 / 1024}' /proc/partitions | head -n 1 | awk '{print $2"GB"}' >> logfile2.txt
printf -- "\\r\n" >> logfile2.txt

#HDD NAME
udevadm info --query=all --name=/dev/sda | grep "E: ID_MODEL=" | awk -F'=' '{print $2}' >> logfile2.txt
printf -- "\\r\n" >> logfile2.txt

#HDD S/N

udevadm info --query=all --name=/dev/sda | grep ID_SERIAL | grep "E: ID_SERIAL_SHORT=" | awk -F'=' '{print $2}' >> logfile2.txt
printf -- "\\r\n" >> logfile2.txt

#IP

ifconfig | grep inet | awk '{print $1 " " $2}' | grep "inet " | awk '($2!="127.0.0.1") && ($2!~"^192."){print $2}' >> logfile2.txt
printf -- "\\r\n" >> logfile2.txt

#Mac Address
ifconfig | head -n 1 | tail -n 1 | awk '{print $5}' >> logfile2.txt
printf -- "\\r\n" >> logfile2.txt

printf -- "\\r\n" >> logfile2.txt

#Hostname

hostname >> logfile2.txt
printf -- "\\r\n" >> logfile2.txt

#Monitor
cat /var/log/Xorg.0.log | grep "Monitor name:" | awk '{ print substr($0, index($0,$6)) }' >> logfile2.txt
cat /var/log/Xorg.0.log | grep "Serial No:" | awk '{ print substr($0, index($0,$6)) }' >> logfile2.txt

printf -- "------------------------------------------------------\r\n " >> logfile2.txt
