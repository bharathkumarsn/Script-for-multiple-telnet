#!/bin/bash
path=`pwd`;
touch $path/test_telnet.out || exit;
touch $path/success.log || exit;
touch $path/failed.log || exit;
echo "10.192.168.1 1200
google.com 80
10.220.2.8 6090
10.220.2.9 6090" | ( while read host port; do
        telnet $host $port </dev/null > $path/test_telnet.out 2>&1 & sleep 1; kill $!;
        if grep Connected $path/test_telnet.out >/dev/null;
            then
                echo @ $(date +"%b %d %H:%M %Y") $host:$port [ OPEN ] | tee -a $path/success_log.txt;
            elif grep refused $path/telnet_test.txt >/dev/null; then
                echo @ $(date +"%b %d %H:%M %Y") $host:$port [ REFUSED ] | tee -a $path/success_log.txt; #DisplaySuccess logs and append output to success file
            else
                echo @ $(date +"%b %d %H:%M %Y") $host:$port [ TIMEOUT ] | tee -a $path/failed_log.txt; #Display failed logs and append to failed file
        fi;
 cp /dev/null $path/test_telnet.out;
 done
 ) 2>/dev/null
