#!/bin/bash
# include functions to be tested

IPV6=$(if cat /proc/cmdline | grep -oq "ipv6.disable=1"; then echo "Disabled"; else echo "Enabled"; fi)

DIG=$(if command -v dig >/dev/null 2>&1; then echo "Yes"; else echo "No"; fi)
IFCON=$(if command -v ifconfig >/dev/null 2>&1; then echo "Yes"; else echo "No"; fi)
NETSTAT=$(if command -v netstat >/dev/null 2>&1; then echo "Yes"; else echo "No"; fi)
SS=$(if command -v ss >/dev/null 2>&1; then echo "Yes"; else echo "No"; fi)
LSOF=$(if command -v lsof >/dev/null 2>&1; then echo "Yes"; else echo "No"; fi)
TRACE=$(if command -v traceroute >/dev/null 2>&1; then echo "Yes"; else echo "No"; fi)
TOP=$(if command -v top >/dev/null 2>&1; then echo "Yes"; else echo "No"; fi)
FREE=$(if command -v free >/dev/null 2>&1; then echo "Yes"; else echo "No"; fi)
PS=$(if command -v ps >/dev/null 2>&1; then echo "Yes"; else echo "No"; fi)
IOSTAT=$(if command -v iostat >/dev/null 2>&1; then echo "Yes"; else echo "No"; fi)
VMSTAT=$(if command -v vmstat >/dev/null 2>&1; then echo "Yes"; else echo "No"; fi)


FILENAME=result.txt

function checkNetwork
{
    echo -e "\n$TextDIV\n\t/etc/resolv.conf\n`date '+%X %Z %z'`\n$TextDIV\n" >> ./$FILENAME
    cat /etc/resolv.conf >>./$FILENAME
    Resolv=$(grep -oPm 1  '(?<=^nameserver ).*' /etc/resolv.conf)
    if [ $? -eq 1 ]; then
        echo "Test failed! : resolving the Name Server"
        exit 1
    else
        echo "Test passed! : resolving the Name Server"
    fi

    command sudo apt-get install -y net-tools  >/dev/null 2>&1

    command dig  google.com @$Resolv 2>/dev/null |grep -i google.com >> $FILENAME
    if [ $? -eq 1 ]; then
        echo "Test failed! : dig to 'google.com'"
        exit 1
    else
        echo "Test passed! : dig to 'google.com'"
    fi

    command sudo apt-get install -y traceroute  >/dev/null 2>&1

    command ping -c 10 -q  google.com 2>/dev/null |grep -i "0% packet loss" >> $FILENAME
    if [ $? -eq 1 ]; then
        echo "Test failed! : ping to 'google.com'"
        exit 1
    else
        echo "Test passed! : ping to 'google.com'"
    fi


}

checkNetwork
