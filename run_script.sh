#!/bin/bash
echo "Post steps"

old_pid=$(ps -ef|grep "java -jar gmall"|grep -v "grep"| awk '{print $2}')
if [ -n "$old_pid" ]; then
    kill "$old_pid" &> /dev/null
    echo "kill old gmall[$old_pid]"
else
    echo "no old gmall is running"
fi

cd "/var/lib/jenkins/workspace/maven_gmall/target"
[[ -f "gmall.log" ]] || { echo "no gmall.log file, to be created."; touch gmall.log; }

# nohup java -jar gmall*jar >> gmall.log 2>&1 &
nohup java -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8060 -Djava.rmi.server.hostname=111.231.59.249 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -jar gmall*jar >> gmall.log 2>&1 &
sleep 5


new_pid=$(ps -ef|grep "java -jar gmall"|grep -v "grep"| awk '{print $2}')
[[ -n "$new_pid" ]] && { echo "new gmall[$new_pid] restarted."; exit 0; }
