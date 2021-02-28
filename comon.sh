#!/bin/bash
function getip() {
i=0;while :;do let i++;var=$(curl --stderr /dev/null ident.me)&>/dev/null &&echo -e "[$(date "+%H:%M:%S")|IP info]Your IP${i}:\033[32m$var\033[0m" && sleep 9.5;done;
}
export http_proxy='http://127.0.0.1:8118'
export https_proxy='https://127.0.0.1:8118'

