#!/bin/bash
usage() {
  echo "sh $0 file_in1 file_in2 out_file key_colums1 key_colums2"
}

[ $# -lt 3 ] && usage && exit 255
file_in1=$1
file_in2=$2
file_out=$3

key_colums1="1"
key_colums2="1"
[ $# -ge 4 ] && key_colums1=$4
[ $# -ge 5 ] && key_colums2=$5

awk -F "\t"  -v OFS="\t" -v keys1=$key_colums1 -v keys2=$key_colums2 'BEGIN{
    split(keys1, keys1_list, ",")
    split(keys2, keys2_list, ",")
}
NR==FNR{
    key=""
    for(k in keys2_list) {
        i = keys2_list[k]
        if(i==""){
            next
        }
        key=key","$i;
    }
    if(key=="") {
        next
    }

    s[key]=$0
}
NR>FNR{
    key=""
    for(k in keys1_list) {
        i = keys1_list[k]
        if(i==""){
            next
        }
        key=key","$i;
    }

    if(key=="") {
        next
    }

    print $0,s[key]
}' $file_in2 $file_in1
