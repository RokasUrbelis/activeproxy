#!/bin/bash
set -e
trap "echo 'Bye~'" EXIT
function start_up() {
#declare -i time
while true; do
	printf "\n"
	read -p 'How many seconds to change the IP(min=10,Defalut=10):' time
	if [ ! -n "${time}" ]; then
	        time="10"	
        elif ! grep -Po '(?m)(?i)\s*\d+\s*'< <(printf "%s\n" ${time}) &>/dev/null; then
		printf "[\033[0ERROR\033[0m]: Sorry,%s not correct.\n"
		continue
	fi
	printf "Switch IP every \033[32m%s\033[0m seconds	          [\033[32m OK \033[0m]\n" ${time}
	break
done
sleep 1
sudo pkill -TERM "tor|privoxy" &&\
sudo \cp conf/privoxy.conf /etc/privoxy/config &&\
sudo \cp conf/torrc.conf /etc/tor/torrc &&\
sudo sed -ri "s/(^MaxCir.*s\s*)([0-9]+)/\1${time}/g" /etc/tor/torrc &&\
sudo chown -R $USER.$USER /var/lib/tor

{ nohup tor & } &>/dev/null && echo -e "[info $(date "+%m-%d %H:%M:%S")] Tor is starting     [\033[32m OK \033[0m]" || echo -e "$(date "+%m-%d %H:%M:%S")service is stop [\033[32m failed \033[0m]"

sudo privoxy /etc/privoxy/config && echo -e "[info $(date "+%m-%d %H:%M:%S")] Privoxy is starting [\033[32m OK \033[0m]" || echo -e "$(date "+%m-%d %H:%M:%S")service is stop [\033[32m failed \033[0m]" 

}

function stop_service() {
	 {
	   sleep 1;
	   sudo pkill tor;
	   sudo pkill privoxy; 
         } &&\
	  printf "STOP SERVICE   	  		          [\033[32m OK \033[0m]\n" ||\
          printf "STOP SERVICE	      	                 [\033[0;31m FAILED \033[0m]\nMaybe service not running?\n"
    
}

function check_port() {
	declare -i ssport
	local port
	while :; do
        	read -p 'Plese input socks(shadowsocks or others) listening port(Default 1080):' port;
		ssport=${port}	
		if [ ! -n "${port}" ]; then
			readonly ssport=1080
			printf "Default Port=\033[32m1080\033[0m\n"
		fi

		if ! ss -lnt | grep "${ssport}"  &>/dev/null; then
			sleep 1
			printf "Listening Port=\033[32m%s\033[0m	      	        [\033[0;31mFAILED\033[0m]\n" ${ssport}
			printf "[\033[0ERROR\033[0m]: Sorry,not found listen port '%s',please input again\n" ${ssport}
			continue
		else
			sleep 1
			printf "Listening Port=\033[32m%s\033[0m 			  [\033[32m OK \033[0m]\n" ${ssport}
		fi
		break
	done
	sudo sed -ri "s/(^Socks.*:)([0-9]+)/\1${ssport}/g" /etc/tor/torrc
#return ${ssport}
}

function getip() {
 i=0
 while :;do
   let i++;var=$(curl ident.me)&>/dev/null && echo -e "[$(date "+%H:%M:%S")|IP info]Your IP${i}:\033[32m$var\033[0m" && sleep 9.5;
 done; 
i=0;while :;do let i++;var=$(curl --stderr /dev/null ident.me)&>/dev/null &&echo -e "[$(date "+%H:%M:%S")|IP info]Your IP${i}:\033[32m$var\033[0m" && sleep 9.5;done; 
}

echo    '               m  '                                                  
echo    'mmm   m   m  mm#mm   mmm          mmmm    m mm   mmm   m   m  m   m' 
echo   '"   #  #   #    #    #" "#         #" "#   #"  " #" "#   #m#   "m m"' 
echo   'm"""#  #   #    #    #   #         #   #   #     #   #   m#m    #m#  '
echo  ' "mm"#  "mm"#    "mm  "#m#"         ##m#"   #     "#m#"  m" "m   "#   '
echo  '                                    #                            m"   '
echo  '                            """"""  "                           '
echo '#######################################################################'
while :;do
cat <<- EOF 
1.start service
2.getip
3.stop service
4.exit
EOF
printf "\nshell>"
read opt
	case $opt in
		1)
	 		check_port
	 		start_up
			break
	 		;;
       	        2) 
	 		source comon.sh
	 		getip
	        	;;
		3)      
			stop_service
			exit
			;;
		4)
	 		exit 0;;
 		*)
	 		printf "'%s' option not found,please input again" $opt 
			continue
			;;
	esac
done

