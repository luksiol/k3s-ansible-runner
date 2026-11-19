# K3s Ansible runner

For K3s on Ovirt, prepared for Github Actions, Gitlab CI and local make.

Built-in:
* Ansible:
    * ansible.posix
    * kubernetes.core
    * ovirt.ovirt
    * ansible.utils
    * community.general
    * community.vmware
* Helm
* Helm diff


## Build local
This will build local image with ansible and helm and required modules for ansible:
```
make
```


