# Kubeadm Ansible Playbook

Build a Kubernetes cluster using Ansible with kubeadm.

  - Ubuntu 16.04
  - CentOS 7

System requirements:

  - Deployment environment must have Ansible `2.4.2.0`
  - Master and nodes must have passwordless SSH access

# Usage

Add the system information gathered above into a file called `inventory`. For example:
```
[master]
192.168.21.194

[node]
192.168.21.226

[kube-cluster:children]
master
node
```

After going through the setup, run the `site.yaml` playbook:

```sh
$ ansible-playbook -i inventory site.yaml
```


# Resetting the environment

Finally, reset all kubeadm installed state using `reset-site.yaml` playbook:

```sh
$ ansible-playbook -i inventory reset-site.yaml
```


# 总结:
### Kubeadm init
- Kubernetes根据在/etc/kubernetes/manifests目录下的manifests生成API server, controller manager and scheduler等静态pod。

```
$ sudo ls /etc/kubernetes/manifests
etcd.yaml  kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml
```

- kube-apiserver.yaml文件内容为例，可以查看到启动kube-apiserver需要的参数

- kube-apiserver yaml文件kube-apiserver.yaml中的选项--insecure-port设置为0，说明kube-apiserver并未监听默认http 8080端口，而是监听了https 6443端口

注：从上面信息可知kube-dns已经以pod形式运行但处于pending状态，主要因为pod网络flannel还未部署>，另外因下文中的Master Isolation特性导致kube-dns无节点可部署。加入节点以及解除Master Isolation均可以使kube-dns成功运行、处于running状态


注：如果之前用`sudo kubeadm init`或`sudo kubeadm join`.已经初始化过集群或加过节点，预检查会失
败，需用`sudo kubeadm reset`命令来revert：

```
$ sudo kubeadm reset
```
- 由于安全原因，默认情况下pod不会被schedule到master节点上，可以通过下面命令解除这种限制：

```
$ kubectl taint nodes --all node-role.kubernetes.iomv/master
```

### ansible

- ANSIBLE_CFG 环境变量，可以定义配置文件的位置
- ansible.cfg 存在于当前工作目录
- ansible.cfg 存在与当前用户家目录
- /etc/ansible/ansible.cfg

ansible 配置文件默认存使用 `/etc/ansible/ansible.cfg`,
hosts文件默认存使用 `/etc/ansible/hosts`

配置文件里面的配置，根据自己情况，自行修改

```
#control_path_dir = /tmp/.ansible/cp

#control_path_dir = ~/.ansible/cp
```
以上默认是注释掉，开启后会执行 ansible 时只会在某一个节点上执行脚本。