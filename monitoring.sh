#/bin/bash
lvmc=$(lsblk | grep "lvm" | wc -l)

wall """
#Architecture: $(uname -a)
#CPU physical : $(cat /proc/cpuinfo | grep '^physical id' | sort | uniq | wc -l)
#vCPU : $(cat /proc/cpuinfo | grep '^processor' | wc -l)
#Memory Usage: $(free | grep "Mem" | awk '{printf "%.f/%.fMb (%.1f%%)", ($3/1024), ($2/1024)MB, ($3/$2)*100"%" }')
#Disk Usage: $(df -h --total | tail -1 | awk '{printf "%s/%sGB (%.3s%%)", $3, $2, ($3/$2)*100"%" }' | sed 's/G//' | sed 's/GG/G/')
#CPU load: $(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
#Last boot: $(uptime -s)
#LVM use: $(if [ $lvmc -eq 0 ]; then echo no; else echo yes; fi)
#Connections TCP : $(netstat -nat | grep "ESTABLISHED" | awk '{print $4}' | uniq | wc -l) ESTABLISHED
#User log: $(uptime | awk '{print $5}')
#Network: IP $(hostname -I) ($(ip link show | grep "link/ether" | awk '{print $2}'))
#Sudo : $(cat /var/log/sudo | wc -l | awk '{print $1 / 2}') cmd
"""
