#!/usr/bin/python3
import os
import re
import time
import datetime
torrc="/etc/tor/torrc"
privoxy="/etc/privoxy/config"
def input_time(time=60):
    while True:
        time=input("How many seconds to change the IP(min=10,default=60):")
        if time.replace('.','',1).isdigit():
            if int(time)>int(9):
                return time
            else:
                print("Min value is 10,please input again")
                continue
        elif time=="":
             time=60
             return time
        else:
             printf("input error,please input again",+"\n")
             continue

seconds=int(input_time())
old_file='/etc/tor/torrc'
fopen=open(old_file,'r')
 
w_str=""
for line in fopen:
         if re.search('MaxCircuitDirtiness',line):
                 line=re.sub('^MaxCircuitDirtiness.*','MaxCircuitDirtiness '+str(seconds),line)
                 w_str+=line
         else:
                 w_str+=line
wopen=open(old_file,'w')
wopen.write(w_str)
fopen.close()
wopen.close()

os.system('sudo pkill tor')
os.system('sudo pkill privoxy')
os.system('sudo chown -R $USER.$USER /var/lib/tor')
os.system('{ nohup tor >/dev/null 2>&1; } &')
os.system('sudo privoxy /etc/privoxy/config')
print("[Info:"+datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")+"]"+" privoxy is starting [\033[32mOK\033[0m]")
print("[Info:"+datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")+"]"+" tor is starting [\033[32mOK\033[0m]")
#os.system("sed -ne 's/(test)/\1 " + str(seconds) + "/g' temp.txt")

