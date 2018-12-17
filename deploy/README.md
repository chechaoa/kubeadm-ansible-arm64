
在 `kubeadm-ansible-arm64/roles/commons/pre-install/files` 目录下存放 `kubeadm-images.tar.gz` `kubeadm_1.8.6-00_arm64.deb` `kubectl_1.8.6-00_arm64.deb` `kubernetes_cni_0.5.1-00_arm64.deb` 

注：
images_list
```
quay.io/coreos/flannel:v0.9.1-arm64
gcr.io/google_containers/kube-apiserver-arm64:v1.8.6
gcr.io/google_containers/k8s-dns-sidecar-arm64:1.14.5
gcr.io/google_containers/k8s-dns-dnsmasq-nanny-arm64:1.14.5
gcr.io/google_containers/kube-scheduler-arm64:v1.8.6
gcr.io/google_containers/heapster-arm64:v1.4.3
gcr.io/google_containers/pause-arm64:3.0
gcr.io/google_containers/kube-controller-manager-arm64:v1.8.6
gcr.io/google_containers/kube-proxy-arm64:v1.8.6
gcr.io/google_containers/etcd-arm64:3.0.17
gcr.io/google-containers/addon-resizer-arm64:2.1
quay.io/calico/node:v3.2.3-arm64
quay.io/calico/cni:v3.2.3-arm64
quay.io/coreos/flannel:v0.9.1-arm64
cargo.caicloudprivatetest.com/caicloud/dashboard:v2.1.1.0-arm64

```

```
cat images.list | xargs -L 1 docker pull 
docker save `cat images.list` | gzip -c > kubeadm-images.tar.gz
```
 
在 `kubeadm-ansible-arm64/roles/commons/os-checker/files` 目录下存放 `ebtables` 和 `socat` 

在 `kubeadm-ansible-arm64/roles/docker/files` 目录下存放docker 的安装包

