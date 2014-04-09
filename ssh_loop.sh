#!/bin/bash

SSH_OPTIONS="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "

INTERPRETER=""
SCRIPT_FILE_FLAG=0
DELETE_SCRIPT_FILE=0
DELETE_HOSTS_FILE=0

usage(){
    echo "----------------------------------------------------"
    echo "Usage: "
    echo "    $0 host_list_file [-h|-t] xxx -e xxx"
    echo "----------------------------------------------------"
    exit 0
}

excute(){
# excute $host
    local host=$1

    echo "==========$host============="
    if [[ $SCRIPT_FILE_FLAG -eq 1 ]]; then
        cat $script | ssh $SSH_OPTIONS $host "cat |$INTERPRETER"
    else
        ssh -n $SSH_OPTIONS $host "$script"
    fi
    echo
}

[[ $# < 2 ]] && usage
while getopts h:e:r: arg;do
    case $arg in
    h)
        hosts=$OPTARG
    ;;
    e)
        script=$OPTARG
    ;;
    r)
        render="$OPTARG"
        script="${render%% *}`date +%s`"_c
        ([[ ${render:0:1} == "/" ]] || \
        [[ ${render:0:2} == "./" ]] || \
        [[ ${render:0:3} == "../" ]]) || render="./$render"
        eval "$render" > $script
    DELETE_SCRIPT_FILE=1
    ;;
    :)
        usage
    ;;
    \?)
        usage
    ;;
    esac
done

if [[ -e "$script" ]]; then
    SCRIPT_FILE_FLAG=1
    INTERPRETER=`head -n1 $script | sed 's/^#!//g'`
    [[ -z "$INTERPRETER" ]] && echo "Please set interpreter of your script" && usage
fi

if [[ -e "$hosts" ]]; then
    awk '{print $1}' $hosts | while read host; do
        excute $host
    done
else
    excute $hosts
fi

[[ $DELETE_HOSTS_FILE == 1 ]] && rm $hosts
#[[ $DELETE_SCRIPT_FILE == 1 ]] && rm $script
