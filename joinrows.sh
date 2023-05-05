#!/bin/bash

usage() {
  echo "sh $0 file_name"
  echo "cat temp"
  echo "  1\n  2\n  3"
  echo "sh $0 temp"
  echo "#result:"
  echo "1,2,3"
}

[ $# -lt 1 ] && usage && exit 0

awk '{
if(s=="") {
s= $1
next
} 
s=s","$1
}
END{print s}' $1
