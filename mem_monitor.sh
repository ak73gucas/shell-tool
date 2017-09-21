#!/bin/bash
#
# Copyright (c) 2017 Ak73gucas, Inc. All Rights Reserved
#
# Author: ak73gucas
# Date: 2017/9/21
# Brief:
#   Monitor memory of the machine is safe, check memory used ratio is more than
#   maximum or not, check memory left is less than minimum or not.
# Globals:
#   MONITOR_ROOT_DIR
#   MAIL_LIST
#   MAX_MEMORY_USED_RATIO
#   MIN_LEFT_MEMORY
#   LOG_PATH
# Arguments:
#   None
# Returns:
#   succ:0
#   fail:1 -- memory used ratio exceed maximum
#        2 -- memory left less than minimum

MONITOR_ROOT_DIR=/
MAIL_LIST=ak73gucas@163.com
MAX_MEMORY_USED_RATIO=85
#unit is MB
MIN_LEFT_MEMORY=10000
#log output file is ../$LOG_PATH/run_$0.log
LOG_PATH=log

# Write Log
function WriteLog ()
{
	local fntmp_date=`date`
	local fnMSG=$1
	local fnLOG=$2
	[[ -z $fnLOG || -z $fnMSG ]] && return 1
	echo "[$fntmp_date] $fnMSG" >> $fnLOG
}

#
# Brief: check left disk memory is safe or not
# @param alarm_ratio, ratio * 100, exam. 10% * 100 = 10, if null donot check
# @param alarm_left_disk_mem, size of the disk left, unit is M, if null donot check
# return 0: safe, 1: ratio exceed alarm threshold, 2: absolute left memory is less than alarm size threshold
function check_left_disk_mem() {
    [ $# -lt 1 ] && echo "Usage: check_left_disk_mem alarm_used_ratio [alarm_left_disk_mem]"
    local alarm_used_ratio=$1
    local alarm_left_disk_mem=$2
    if [ "x$alarm_used_ratio" != "x" ]
    then
        content=`df -h`
        ratio=`echo $content | awk -v monitor_disk=$MONITOR_ROOT_DIR 'monitor_disk == $NF {print $(NF-1)}' |sed "s/%//"`
        if [[ $alarm_used_ratio -lt $ratio ]]
        then
            echo "mem used ratio exceed $alarm_used_ratio, deltail below:\n\n $content"
            return 1
        fi
    fi
    if [ "x$alarm_left_disk_mem" != "x" ]
    then
        content=`df`
        left_mem=`echo $content | awk '"/home" == $NF {print $(NF-2)}'`
        left_mem_min=$(($alarm_left_disk_mem*1024))
        if [[ $left_mem_min -gt $left_mem ]]
        then
            echo "disk memory left less than $alarm_left_disk_mem MB, deltail below:\n\n $content"
            return 2
        fi
    fi
    #safe
    return 0
}

function main() {
    work_path=`pwd`/`dirname $0`"/.."
    cd $work_path
    cur_file_name=`echo $0 |awk -F "/" '{print $NF}'`
    [ -d $LOG_PATH ] || mkdir $LOG_PATH
    log_file=$LOG_PATH/run_$cur_file_name.log

    ret=0
    msg=`check_left_disk_mem $MAX_MEMORY_USED_RATIO $MIN_LEFT_MEMORY`
    ret=$?
    if [ $ret -ne 0 ]
    then
        echo "$msg" |mail -s "`hostname` memory alarm" $MAIL_LIST
        WriteLog "$msg" $log_file
    fi
    WriteLog "run monitor finished, errno[$ret]" $log_file
    return $ret
}

main $*

