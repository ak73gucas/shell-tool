#!/bin/bash

Usage(){
 if [ $# -lt 2 ]; then
 echo "Usage: sh $0 file1 file2"
 echo "       output rows in file1 but not in file2"
 exit 255
 fi
 }
 
 Usage $*
 awk -F "$" 'NR==FNR{s[$1]=1}NR>FNR{if(s[$1]!=1)print $1}' $2 $1
