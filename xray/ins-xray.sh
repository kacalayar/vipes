#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

BURIQ () {
    curl -sS https://raw.githubusercontent.com/kacalayar/saose/main/ip > /root/tmp
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
Name=$(curl -sS https://raw.githubusercontent.com/kacalayar/saose/main/ip | grep $MYIP | awk '{print $2}')
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
    IZIN=$(curl -sS https://raw.githubusercontent.com/kacalayar/saose/main/ip | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'
echo "XRAY Core Vmess / Vless"
echo "Trojan / Trojan Go"
echo "Progress..."
sleep 3
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
PERMISSION
if [ "$res" = "Permission Accepted..." ]; then
green "Permission Accepted.."
else
red "Permission Denied!"
exit 0
fi
echo -e "
"
date
echo ""
domain=$(cat /root/domain)
sleep 1
mkdir -p /etc/xray > /dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Checking... "
apt install iptables iptables-persistent -y >/dev/null 2>&1
sleep 1
echo -e "[ ${green}INFO$NC ] Setting ntpdate"
ntpdate pool.ntp.org >/dev/null 2>&1
timedatectl set-ntp true >/dev/null 2>&1
sleep 1
echo -e "[ ${green}INFO$NC ] Enable chronyd"
systemctl enable chronyd >/dev/null 2>&1
systemctl restart chronyd >/dev/null 2>&1
sleep 1
echo -e "[ ${green}INFO$NC ] Enable chrony"
systemctl enable chrony >/dev/null 2>&1
systemctl restart chrony >/dev/null 2>&1
timedatectl set-timezone Asia/Jakarta >/dev/null 2>&1
sleep 1
echo -e "[ ${green}INFO$NC ] Setting chrony tracking"
chronyc sourcestats -v >/dev/null 2>&1
chronyc tracking -v >/dev/null 2>&1
echo -e "[ ${green}INFO$NC ] Setting dll"
apt clean all && apt update
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
apt install zip -y
apt install nginx curl pwgen openssl netcat cron -y
systemctl enable nginx
ufw disable

# install xray
sleep 1
echo -e "[ ${green}INFO$NC ] Downloading & Installing xray core"
domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
chown www-data.www-data $domainSock_dir
# Make Folder XRay
mkdir -p /var/log/xray
mkdir -p /etc/xray
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /var/log/xray/access2.log
touch /var/log/xray/error2.log
# / / Ambil Xray Core Version Terbaru
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.5.6



## crt xray
systemctl stop nginx
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc

# nginx renew ssl
echo -n '#!/bin/bash
/etc/init.d/nginx stop
"/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" &> /root/renew_ssl.log
/etc/init.d/nginx start
' > /usr/local/bin/ssl_renew.sh
chmod +x /usr/local/bin/ssl_renew.sh
if ! grep -q 'ssl_renew.sh' /var/spool/cron/crontabs/root;then (crontab -l;echo "15 03 */3 * * /usr/local/bin/ssl_renew.sh") | crontab;fi

mkdir -p /home/vps/public_html

# set uuid
uuid=$(cat /proc/sys/kernel/random/uuid)
# xray config
cat > /usr/local/etc/xray/config.json << END
{
  "log" : {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [
      {
      "listen": "127.0.0.1",
      "port": 10085,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
   {
     "listen": "/run/xray/vless_ws.sock",
     "protocol": "vless",
      "settings": {
          "decryption":"none",
            "clients": [
               {
                 "id": "${uuid}"                 
#vless
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vless"
          }
        }
     },
     {
     "listen": "/run/xray/vmess_ws.sock",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "${uuid}",
                 "alterId": 0
#vmess
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vmess"
          }
        }
     },
     {
		"listen": "127.0.0.1",
		"port": "30001",
		"protocol": "socks",
		"settings": {
			"auth": "password",
			"accounts": [
				{
					"user": "socks",
					"pass": "${uuid}"
#socksws
				}
			],
			"level": 0,
			"udp": true
		},
		"streamSettings":{
			"network": "ws",
			"wsSettings": {
				"path": "/socks-ws"
			}
		}
	},
    {
      "listen": "/run/xray/trojan_ws.sock",
      "protocol": "trojan",
      "settings": {
          "decryption":"none",		
           "clients": [
              {
                 "password": "${uuid}"
#trojanws
              }
          ],
         "udp": true
       },
       "streamSettings":{
           "network": "ws",
           "wsSettings": {
               "path": "/trojan-ws"
            }
         }
     },
    {
         "listen": "127.0.0.1",
        "port": "30300",
        "protocol": "shadowsocks",
        "settings": {
           "clients": [
           {
           "method": "aes-128-gcm",
          "password": "${uuid}"
#ssws
           }
          ],
          "network": "tcp,udp"
       },
       "streamSettings":{
          "network": "ws",
             "wsSettings": {
               "path": "/ss-ws"
           }
        }
     },	
      {
        "listen": "/run/xray/vless_grpc.sock",
        "protocol": "vless",
        "settings": {
         "decryption":"none",
           "clients": [
             {
               "id": "${uuid}"
#vlessgrpc
             }
          ]
       },
          "streamSettings":{
             "network": "grpc",
             "grpcSettings": {
                "serviceName": "vless-grpc"
           }
        }
     },
     {
      "listen": "/run/xray/vmess_grpc.sock",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "${uuid}",
                 "alterId": 0
#vmessgrpc
             }
          ]
       },
       "streamSettings":{
         "network": "grpc",
            "grpcSettings": {
                "serviceName": "vmess-grpc"
          }
        }
     },
     {
        "listen": "/run/xray/trojan_grpc.sock",
        "protocol": "trojan",
        "settings": {
          "decryption":"none",
             "clients": [
               {
                 "password": "${uuid}"
#trojangrpc
               }
           ]
        },
         "streamSettings":{
         "network": "grpc",
           "grpcSettings": {
               "serviceName": "trojan-grpc"
         }
      }
  },
  {
		"listen": "127.0.0.1",
		"port": "30002",
		"protocol": "socks",
		"settings": {
			"auth": "password",
			"accounts": [
				{
					"user": "socks-grpc",
					"pass": "${uuid}"
#socksgrpc
				}
			],
			"level": 0,
			"udp": true
		},
		"streamSettings":{
     "network": "grpc",
        "grpcSettings": {
           "serviceName": "socks-grpc"
			}
		}
	},
   {
    "listen": "127.0.0.1",
    "port": "30310",
    "protocol": "shadowsocks",
    "settings": {
        "clients": [
          {
             "method": "aes-128-gcm",
             "password": "${uuid}"
#ssgrpc
           }
         ],
           "network": "tcp,udp"
      },
    "streamSettings":{
     "network": "grpc",
        "grpcSettings": {
           "serviceName": "ss-grpc"
          }
       }
    }	
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}
END

cat <<EOF> /etc/systemd/system/xray.service
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE                                 AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

EOF

sleep 1
echo -e "[ ${green}INFO$NC ] Installing bbr.."
wget -q -O /usr/bin/bbr "https://raw.githubusercontent.com/kacalayar/vipes/main/dll/bbr.sh"
chmod +x /usr/bin/bbr
bbr >/dev/null 2>&1
rm /usr/bin/bbr >/dev/null 2>&1


sudo netfilter-persistent save >/dev/null 2>&1
sudo netfilter-persistent reload >/dev/null 2>&1
echo -e "$yell[SERVICE]$NC Restart All service"
systemctl daemon-reload
sleep 1
echo -e "[ ${green}ok${NC} ] Enable & restart xray "
systemctl enable xray >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Enable & restart trojan-go "
systemctl enable trojan-go >/dev/null 2>&1
systemctl restart trojan-go >/dev/null 2>&1

sleep 1
echo -e "[ ${green}ok${NC} ] Downloading files for trojan-go... "
wget -q -O /usr/bin/add-ws "https://raw.githubusercontent.com/kacalayar/vipes/main/xray/add-ws.sh" && chmod +x /usr/bin/add-ws
wget -q -O /usr/bin/add-vless "https://raw.githubusercontent.com/kacalayar/vipes/main/xray/add-vless.sh" && chmod +x /usr/bin/add-vless
wget -q -O /usr/bin/add-tr "https://raw.githubusercontent.com/kacalayar/vipes/main/xray/add-tr.sh" && chmod +x /usr/bin/add-tr
wget -q -O /usr/bin/del-user "https://raw.githubusercontent.com/kacalayar/vipes/main/xray/del-ws.sh" && chmod +x /usr/bin/del-ws
wget -q -O /usr/bin/cek-user "https://raw.githubusercontent.com/kacalayar/vipes/main/xray/cek-ws.sh" && chmod +x /usr/bin/cek-ws
wget -q -O /usr/bin/renew-user "https://raw.githubusercontent.com/kacalayar/vipes/main/xray/renew-ws.sh" && chmod +x /usr/bin/renew-ws
wget -q -O /usr/bin/trial-ws "https://raw.githubusercontent.com/kacalayar/vipes/main/xray/trial-ws.sh" && chmod +x /usr/bin/trial-ws
wget -q -O /usr/bin/trial-vless "https://raw.githubusercontent.com/kacalayar/vipes/main/xray/trial-vless.sh" && chmod +x /usr/bin/trial-vless
wget -q -O /usr/bin/trial-tr "https://raw.githubusercontent.com/kacalayar/vipes/main/xray/trial-tr.sh" && chmod +x /usr/bin/trial-tr
wget -q -O /usr/bin/renewcert "https://raw.githubusercontent.com/kacalayar/vipes/main/xray/cert.sh" && chmod +x /usr/bin/renewcert
wget -q -O /usr/bin/v2ray-menu "https://raw.githubusercontent.com/kacalayar/vipes/main/menu_all/v2ray-menu.sh" && chmod +x /usr/bin/v2ray-menu
wget -q -O /usr/bin/trojan-menu "https://raw.githubusercontent.com/kacalayar/vipes/main/menu_all/trojan-menu.sh" && chmod +x /usr/bin/trojan-menu
wget -q -O /usr/bin/ssgrpc-menu "https://raw.githubusercontent.com/kacalayar/vipes/main/menu_all/ssgrpc-menu.sh" && chmod +x /usr/bin/ssgrpc-menu
wget -q -O /usr/bin/add-ssws "https://raw.githubusercontent.com/kacalayar/vipes/main/xray/add-ssws.sh" && chmod +x /usr/bin/add-ssws
wget -q -O /usr/bin/del-ssws "https://raw.githubusercontent.com/kacalayar/vipes/main/xray/del-ssws.sh" && chmod +x /usr/bin/del-ssws
wget -q -O /usr/bin/renew-ssws "https://raw.githubusercontent.com/kacalayar/vipes/main/xray/renew-ssws.sh" && chmod +x /usr/bin/renew-ssws
sleep 1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "xray/Vmess"
yellow "xray/Vless"
yellow "Trojan-GFW"
yellow "Trojan-GO install successfully"

mv /root/domain /etc/xray/ >/dev/null 2>&1
if [ -f /root/scdomain ];then
rm /root/scdomain > /dev/null 2>&1
fi
clear
rm -f ins-xray.sh >/dev/null 2>&1
