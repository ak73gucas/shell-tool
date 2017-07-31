#!/bin/bash
function usage(){
    echo "Note: 建立本地到目标机器的信任关系，使得本地登录目标机器不需要密码"
    echo " Usage: sh $0 make"
    echo " step1: 在本地运行 本脚本"
    echo " step2: 如遇提示，一直enter"
    echo " step3: 将最后的提示命令，在目标机器上执行"
}
[ "x$1" != "xmake" ] && usage && exit 255
cd ~
[ -d .ssh ] || mkdir .ssh
cd .ssh
if ! [ -e id_rsa ]
then
    echo "create rsa key, please enter always"
    ssh-keygen -t rsa
fi
#chmod +600 id_rsa

pub_key=`cat id_rsa.pub`
echo ""
echo " Please add content below to dst machine's ~/.ssh/authorized_keys"
echo ""
echo $pub_key
echo ""
echo " Or run cmd below"
echo ""
echo "echo \"$pub_key\" >> ~/.ssh/authorized_keys"
echo ""
