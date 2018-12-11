#!/bin/bash

# 定义 ansible 的 hosts 位置，如果安装的路径不一样，自行修改
ansible_host='inventory'

#打印错误信息
function print_error {
	info="$1"
	echo -e "\e[1;31m[Error]\e[0m   -   $info"
}

#打印错误信息
function print_Warning {
	info="$1"
	echo -e "\e[1;34m[Warning]\e[0m   -   $info"
}

#打印正常信息
function print_info {
	info="$1"
	echo -e "\e[1;32m[Info]\e[0m   -   $info"
}

#打印询问信息
function print_ask {
	info="$1"
	echo -n -e "\e[1;32m[Info]\e[0m   -   $info"
}

function get_ansible_ips {
    ips=`cat ${ansible_host} | egrep -v "^#|^$" | grep -oP '\d+\.\d+\.\d+\.\d+'`
}

function init_ansible {
    get_ansible_ips
    if [ -z "${ips}" ];then
        print_Warning "没有发现需要 ansible 初始化的 ip,请检查 ${ansible_host} 的主机列表文件！"
        exit 0
    fi

    for ip in ${ips}
    do
        echo ${ip}
    done
    print_info "将对以上展示的 ip,进行 ansble 的初始化:"

    # 设置 ssh 在首次连接出现检查 keys 的提示，通过设置
    export ANSIBLE_HOST_KEY_CHECKING=False
    if [ $? -eq 0 ];then
        print_info "设置 ANSIBLE_HOST_KEY_CHECKING 为 False ...[成功]" 
    else
        print_error "设置 ANSIBLE_HOST_KEY_CHECKING 为 False ...[失败]" 
        exit 1
    fi

    # 创建 ansible-server 的公钥和私钥
    if [ ! -d /root/.ssh ];then
        mkdir -p /root/.ssh
        if [ $? -ne 0 ];then
            print_error "创建存放 ansible-server 的公私钥目录 ...[失败]"
            exit 1
        fi
    fi
	# 自定义无密码验证需要的 key，采用其他名字形式
	ssh_key=/root/.ssh/id_rsa
        ssh_key_pub=/root/.ssh/id_rsa.pub
	
	if [  -f "$ssh_key" -a -f "$ssh_key_pub" ]; then
		echo '密钥已存在~'
	else
		echo '密钥不存在了，将自动创建！'
        # 这里是为了避免上面公钥私钥存在一个，反正都要重新建立，就删了，反正不影响用户的 key
        rm -rf ${ssh_key}
        rm -rf ${ssh_key_pub}
		ssh-keygen -t rsa -b 2048 -P '' -f ${ssh_key}
		if [ $? -eq 0 ];then
			print_info "创建新的 ansible-server 的公私钥 ...[成功]"
		else
			print_error "创建新的 ansible-server 的公私钥 ...[失败]"
			exit 1
		fi
	fi
    
    
    for ip in ${ips}
    do
        init_action "${ip}"
        if [ $? -ne 0 ];then
            exit 1
        fi
    done

    # 运行 playbook
    ansible-playbook -i inventory ssh-addkey.yml
}

function init_action {
    local ansible_ip=${1}
    ssh-keyscan ${ansible_ip} >> /root/.ssh/known_hosts
    if [ $? -eq 0 ];then
        print_info "ssh-keyscan ${ansible_ip} ...[成功]"
    else
        print_error "ssh-keyscan ${ansible_ip} ...[失败]"
        return 1
    fi

}

init_ansible
