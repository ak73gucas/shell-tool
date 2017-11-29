#!/bin/bash
#Brief generate ftp path of a file or directory
#version 1.0.0
function usage() {
    echo "Usage: $0 [filename|dirname]"
    echo "Exam1: $0 ./"
    echo "Exam2: $0 $0"
}

function genftpath() {
    filename=$1
    if [ -d $filename ]
    then
        filepath=`readlink -f $filename`
        cut_dir_number=`echo $filepath | awk -F "/" '{print NF-1}'`
        echo "wget `hostname`:`readlink -f $1` -rnH --cut-dir=$cut_dir_number"
    else
        echo "wget `hostname`:`readlink -f $1`"
    fi
}
function main() {
    [ $# -lt 1 ] && usage && exit 255
    [ $1 == '-h' ] && usage && exit 0
    [ $1 == '--help' ] && usage && exit 0
    genftpath "$1"
}
main $*
