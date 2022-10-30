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

version_up=$( curl -sS https://raw.githubusercontent.com/joasmaszeh/check/main/version)
echo "$version_up" > /opt/.ver
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
User=$( curl -sS https://raw.githubusercontent.com/josmaszeh/check/main/nameuser)
ISP=$(curl -sS http://ip-api.com/php/?fields=isp | cut -d : -f 7 | sed 's/";}//g' | sed 's/"//g')
CITY=$(curl -sS http://ip-api.com/php/?fields=city | cut -d : -f 7 | sed 's/";}//g' | sed 's/"//g')
IPVPS=$(curl -s ipinfo.io/ip )
echo -e ""
echo -e "               ${COLBG1} Base Script : Horasss   ${NC}"
echo -e "               ${COLBG1} Bot Dev     : XolvaDev  ${NC}"
echo -e "               ${COLBG1} Recode      : Dimasnk97 ${NC}"
echo -e "${COLOR1}═════════════════════════════════════════════════════════${NC}"
echo -e "${COLBG1}                      ADMIN PANEL MENU                   ${NC}"
echo -e "${COLOR1}═════════════════════════════════════════════════════════${NC}"
echo -e " Current IP     : ${GREEN}$IPVPS ${NC}"
echo -e " Current Domain : ${GREEN}$(cat /etc/xray/domain) ${NC}"
echo -e " City & ISP     : $ISP / $CITY"
echo -e " Memory Usage   : $tram MB / $uram MB"
echo -e "${COLOR1}═════════════════════════════════════════════════════════${NC}"
echo -e ""
echo -e " (${YELLOW}01${NC}) × Menu Sshws           (${YELLOW}06${NC}) × Add New Domain"
echo -e " (${YELLOW}02${NC}) × Menu Vmess           (${YELLOW}07${NC}) × Menu System"
echo -e " (${YELLOW}03${NC}) × Menu Vless           (${YELLOW}08${NC}) × Menu Backup"
echo -e " (${YELLOW}04${NC}) × Menu Trojan          (${YELLOW}09${NC}) × Pilihan Theme"
echo -e " (${YELLOW}05${NC}) × Renew Cert           (${YELLOW}10${NC}) × Monitoring Vps"
echo -e ""
echo -e " [${YELLOW}A${NC}] • INFO PORT / [${YELLOW}B${NC}] • INFO VPS / [${YELLOW}C${NC}] • BOT XOLPANEL"
echo -e "${COLOR1}═════════════════════════════════════════════════════════${NC}"
echo -e "    [ NGINX : $status_nginx ]   [ SSH-WS : $status_ws ]   [ XRAY : $status_xray ]"
echo -e "${COLOR1}═════════════════════════════════════════════════════════${NC}"
if [ "$Isadmin" = "ON" ]; then
uis="${GREEN}Premium User$NC"
else
uis="${RED}Free Version$NC"
fi
echo -e " Username  : $Name"
echo -e " User Type : $uis"
echo -e " Version   : $User"
echo -e " License   : ${GREEN}admin${NC} (Control)"
echo -e "${COLOR1}═════════════════════════════════════════════════════════${NC}"
echo -e ""
echo -ne " Input Your Choose : "; read opt
case $opt in
01 | 1) clear ; ssh ;;
02 | 2) clear ; vmess ;;
03 | 3) clear ; vless ;;
04 | 4) clear ; trojan ;;
05 | 5) clear ; crtxray ;;
06 | 6) clear ; domain ;;
07 | 7) clear ; system ;;
08 | 8) clear ; backup ;;
09 | 9) clear ; theme ;;
10) clear ; top ;;
00 | 0) clear ; menu ;;
A) clear ; info ;;
B) clear ; vps ;;
C) clear ; wget https://repo.multyc.my.id/panel.sh panel.sh ; chmod +x panel.sh ; ./panel.sh ;;
*) clear ; menu ;;
esac
