#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

BURIQ () {
    curl -sS https://raw.githubusercontent.com/kenDevXD/src/main/ip > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f /root/tmp
}

MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/kenDevXD/src/main/ip | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}

PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://raw.githubusercontent.com/kenDevXD/src/main/ip | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}

x="ok"

cekray=`cat /root/log-install.txt | grep -ow "XRAY" | sort | uniq`
if [ "$cekray" = "XRAY" ]; then
rekk='XRAY'
bec='xray'
else
rekk='V2RAY'
bec='v2ray'
fi

PERMISSION

if [ "$res" = "Expired" ]; then
Exp="\e[36mExpired\033[0m"
rm -f /home/needupdate > /dev/null 2>&1
else
Exp=$(curl -sS https://raw.githubusercontent.com/kenDevXD/src/main/ip | grep $MYIP | awk '{print $3}')
fi
clear
echo -e "\e[36m╒════════════════════════════════════════════════════╕\033[0m"
echo -e " \E[0;41;36m                  KennXV MENU                      \E[0m"
echo -e "\e[36m╘════════════════════════════════════════════════════╛\033[0m"
uphours=`uptime -p | awk '{print $2,$3}' | cut -d , -f1`
upminutes=`uptime -p | awk '{print $4,$5}' | cut -d , -f1`
uptimecek=`uptime -p | awk '{print $6,$7}' | cut -d , -f1`
cekup=`uptime -p | grep -ow "day"`
IPVPS=$(curl -s ipinfo.io/ip )
serverV=$( curl -sS https://raw.githubusercontent.com/kenDevXD/src/main/versi)

if [ "$cekup" = "day" ]; then
echo    -e   "System Uptime   :  $uphours $upminutes $uptimecek"
else
echo -e   "System Uptime   :  $uphours $upminutes"
fi
echo -e "Use Core        :  $rekk"
echo -e "Current Domain  :  $(cat /etc/$bec/domain)"
echo -e "IP-VPS          :  $IPVPS"
echo -e "\e[36m╒════════════════════════════════════════════════════╕\033[0m"
echo -e " \E[0;41;36m                   TUNNELING MENU                   \E[0m"
echo -e "\e[36m╘════════════════════════════════════════════════════╛\033[0m"
echo -e " [\033[1;36m01\033[0m]  SSH & OVPN
 [\033[1;36m02\033[0m]  $rekk : VMess / VLess
 [\033[1;36m03\033[0m]  TROJAN-WS & GRPC
 [\033[1;36m04\033[0m]  WIREGUARD
 [\033[1;36m05\033[0m]  SSTP
 [\033[1;36m06\033[0m]  L2TP / PPTP
 [\033[1;36m07\033[0m]  SHADOWSOCKS WS/GRPC
 [\033[1;36m08\033[0m]  SHADOWSOCKS OBFS/SSR
\e[36m╒════════════════════════════════════════════════════╕\033[0m"
echo -e "  \E[0;41;36m                  SETTINGS MENU                    \E[0m"
echo -e "\e[36m╘════════════════════════════════════════════════════╛\033[0m
 [\033[1;36m09\033[0m]  Trial Generator
 [\033[1;36m10\033[0m]  Logs User Created
 [\033[1;36m11\033[0m]  VPS Setting [ Menu ]
 [\033[1;36m12\033[0m]  Autokill Multi-login [ Menu ]
 [\033[1;36m13\033[0m]  ALL Information VPS[ Menu ]
 [\033[1;36m14\033[0m]  SYSTEM / Admin [ Menu ]
 [\033[1;36m15\033[0m]  Xol-Panel
"
if [[ $(cat /opt/.ver) = $serverV ]] > /dev/null 2>&1; then
echo -ne
else
echo -e "[\033[1;32m999\033[0m] • \033[0;31mUpdate Available ! Go choice 69 to update\033[0m"
echo ""
fi
echo -e "\033[1;37mPress [ Ctrl+C ] • To-Exit-Script\033[0m"
echo ""
#echo -e "\e[36m╘════════════════════════════════════════════════════╛\033[0m"
echo -e "\e[36m╒════════════════════════════════════════════════════╕\033[0m"
if [[ $(cat /opt/.ver) = $serverV ]] > /dev/null 2>&1; then
echo -e "Version       :\033[1;36m $(cat /opt/.ver) Latest Version\e[0m"
echo -e "Client Name   : $Name"
echo -e "Expiry script : $Exp"
rm -f /home/needupdate > /dev/null 2>&1
else
rm /dev/.permiss > /dev/null 2>&1
touch /home/needupdate > /dev/null 2>&1
echo -e "\033[0;33mVersion : $(cat /opt/.ver) Update available to $serverV\e[0m"
echo -e "\e[36m╒════════════════════════════════════════════════════╕\033[0m"
echo ""
echo -e "[ \033[0;31mChangelog\033[0m ]"
curl -sS https://raw.githubusercontent.com/kenDevXD/scriptvps/main/clgshow
echo -e "
"
fi
echo -e "\e[36m╘════════════════════════════════════════════════════╛\033[0m"
echo
echo -ne "Select menu : "; read x
if [[ $(cat /opt/.ver) = $serverV ]] > /dev/null 2>&1; then
    if [[ $x -eq 1 ]]; then
       ssh-menu
    elif [[ $x -eq 2 ]]; then
       v2ray-menu
    elif [[ $x -eq 3 ]]; then
       trojan-menu
    elif [[ $x -eq 4 ]]; then
       wg-menu
    elif [[ $x -eq 5 ]]; then
       sstp-menu
    elif [[ $x -eq 6 ]]; then
       ipsec-menu
    elif [[ $x -eq 7 ]]; then
       ssgrpc-menu
    elif [[ $x -eq 8 ]]; then
       ss-menu
    elif [[ $x -eq 9 ]]; then
       trial-menu
    elif [[ $x -eq 10 ]]; then
       clear
       cat /etc/log-create-user.log
       read -n 1 -s -r -p "Press any key to back on menu"
       menu
    elif [[ $x -eq 11 ]]; then
       setting-menu
    elif [[ $x -eq 12 ]]; then
       autokill-menu
    elif [[ $x -eq 19 ]]; then
       info-menu
    elif [[ $x -eq 14 ]]; then
       system-menu
    elif [[ $x -eq 15 ]]; then
       xolbot
    else
       menu
    fi
else
    if [[ $x -eq 999 ]]; then
       wget -q -O /usr/bin/update-script "https://raw.githubusercontent.com/kenDevXD/scriptvps/main/dll/system/update-script.sh" && chmod +x /usr/bin/update-script
       screen -S upds update-script
       menu
    elif [[ $x -eq 1 ]]; then
       ssh-menu 
    elif [[ $x -eq 2 ]]; then
       v2ray-menu
    elif [[ $x -eq 3 ]]; then
       trojan-menu
    elif [[ $x -eq 4 ]]; then
       wg-menu
    elif [[ $x -eq 5 ]]; then
       sstp-menu
    elif [[ $x -eq 6 ]]; then
       ipsec-menu
    elif [[ $x -eq 7 ]]; then
       ssgrpc-menu
    elif [[ $x -eq 8 ]]; then
       ss-menu
    elif [[ $x -eq 9 ]]; then
       trial-menu
    elif [[ $x -eq 10 ]]; then
       clear
       cat /etc/log-create-user.log
       read -n 1 -s -r -p "Press any key to back on menu"
       menu
    elif [[ $x -eq 11 ]]; then
       setting-menu 
    elif [[ $x -eq 12 ]]; then
       autokill-menu
    elif [[ $x -eq 13 ]]; then
       info-menu
    elif [[ $x -eq 14 ]]; then
       system-menu
    elif [[ $x -eq 15 ]]; then
       xolbot
    else
       menu
    fi
fi