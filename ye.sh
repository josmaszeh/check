#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
colornow=$(cat /etc/yokkovpn/theme/color.conf)
export NC="\e[0m"
export YELLOW='\033[0;33m';
export RED="\033[0;31m" 
export COLOR1="$(cat /etc/yokkovpn/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
export COLBG1="$(cat /etc/yokkovpn/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"                    
###########- END COLOR CODE -##########
tram=$( free -h | awk 'NR==2 {print $2}' )
uram=$( free -h | awk 'NR==2 {print $3}' )


BURIQ () {
    curl -sS https://raw.githubusercontent.com/josmaszeh/check/main/access > /root/tmp
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
Name=$(curl -sS https://raw.githubusercontent.com/josmaszeh/check/main/access | grep $MYIP | awk '{print $2}')
Isadmin=$(curl -sS https://raw.githubusercontent.com/josmaszeh/check/main/access | grep $MYIP | awk '{print $5}')
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
    IZIN=$(curl -sS https://raw.githubusercontent.com/josmaszeh/check/main/access | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}

x="ok"


PERMISSION

if [ "$res" = "Expired" ]; then
Exp="\e[36mExpired\033[0m"
rm -f /home/needupdate > /dev/null 2>&1
else
Exp=$(curl -sS https://raw.githubusercontent.com/josmaszeh/check/main/access | grep $MYIP | awk '{print $3}')
fi
export RED='\033[0;31m'
export GREEN='\033[0;32m'

# // SSH Websocket Proxy
ssh_ws=$( systemctl status ws-stunnel | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
    status_ws="${GREEN}ON${NC}"
else
    status_ws="${RED}OFF${NC}"
fi

# // nginx
nginx=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
    status_nginx="${GREEN}ON${NC}"
else
    status_nginx="${RED}OFF${NC}"
fi

# // SSH Websocket Proxy
xray=$( systemctl status xray | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $xray == "running" ]]; then
    status_xray="${GREEN}ON${NC}"
else
    status_xray="${RED}OFF${NC}"
fi
clear
ISP=$(curl -sS http://ip-api.com/php/?fields=isp | cut -d : -f 7 | sed 's/";}//g' | sed 's/"//g')
CITY=$(curl -sS http://ip-api.com/php/?fields=city | cut -d : -f 7 | sed 's/";}//g' | sed 's/"//g')
IPVPS=$(curl -s ipinfo.io/ip )
upsc=$( curl -sS https://raw.githubusercontent.com/joasmaszeh/check/main/version)
echo -e "${COLOR1}═════════════════════════════════════════════════════════${NC}"
echo -e " Current IP     : $IPVPS"
echo -e " Current Domain : $(cat /etc/xray/domain)"
echo -e " City & ISP     : $ISP / $CITY"
echo -e " Memory Usage   : $tram MB / $uram MB"
echo -e "${COLOR1}═════════════════════════════════════════════════════════${NC}"
echo -e "${COLBG1}                      ADMIN PANEL MENU                   ${NC}"
echo -e "${COLOR1}═════════════════════════════════════════════════════════${NC}"
echo -e ""
echo -e " ($YELLOW}01${NC}) × Menu Sshws             ($YELLOW}05${NC}) × Add New Domain"
echo -e " ($YELLOW}02${NC}) × Menu Vmess             ($YELLOW}06${NC}) × Menu System"
echo -e " ($YELLOW}03${NC}) × Menu Vless             ($YELLOW}07${NC}) × Menu Backup"
echo -e " ($YELLOW}04${NC}) × Menu Trojan            ($YELLOW}08${NC}) × Pilihan Theme"
echo -e " ($YELLOW}05${NC}) × Renew Cert             ($YELLOW}08${NC}) × Monitoring Vps"
echo -e ""
echo -e " [A] • INFO PORT               [B] • INFO VPS"
echo -e "${COLOR1}═════════════════════════════════════════════════════════${NC}"
if [ "$Isadmin" = "ON" ]; then
uis="${GREEN}Premium User$NC"
else
uis="${RED}Free Version$NC"
fi
echo -e " Username  : $Name"
echo -e " User Type : $uis"
echo -e " Version   : $upsc"
echo -e " License   : admin"
echo -e "${COLOR1}═════════════════════════════════════════════════════════${NC}"
echo -e ""
echo -ne " Input Your Choose : "; read opt
case $opt in
01 | 1) clear ; menu-ssh ;;
02 | 2) clear ; menu-vmess ;;
03 | 3) clear ; menu-vless ;;
04 | 4) clear ; menu-trojan ;;
05 | 5) clear ; menu-ss ;;
06 | 6) clear ; menu-dns ;;
06 | 7) clear ; menu-theme ;;
07 | 8) clear ; menu-backup ;;
09 | 9) clear ; add-host ;;
10) clear ; crtxray ;;
11) clear ; menu-set ;;
12) clear ; info ;;
13) clear ; $ressee ;;
14) clear ; $bottt ;;
100) clear ; $up2u ;;
00 | 0) clear ; menu ;;
*) clear ; menu ;;
esac
