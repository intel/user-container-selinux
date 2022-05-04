# Overview
This repository contains user tailored container SELinux policies and the method for deploying these policies on Red Hat OpenShift Container Platform. These SELinux policies are required for the plugins in [intel-device-plugins-for-kubernetes](https://github.com/intel/intel-device-plugins-for-kubernetes) to deploy on Red Hat OpenShift Container Platform with proper SELinux permissions.

These policies create new domains called `container_device_t` for user workloads, `container_device_plugin_t` for device plugins and `container_device_plugin_init_t` for init containers. The device plugins run as that label to have all the necessary privileges.
These policies are derived from the [container-selinux](https://github.com/containers/container-selinux) project.

## Building the SELinux policies (for developer)

The policies are part of the container image and built using `docker build`. To build the policies, install the selinux-policy development package using below commands: 
```
$ sudo dnf -y selinux-policy-devel
$ make -f /usr/share/selinux/devel/Makefile
```

## Deploying the SELinux policy (for end user)

To deploy the policies on OpenShift Container Platform, run: 
```
$ oc apply -f https://raw.githubusercontent.com/intel/user-container-selinux/main/policy-deployment.yaml
```


## License
user-container-selinux is under GNU GPL v2.0 license. See the [LICENSE](/LICENSE) file for details.

## Security
If you discover any potential security vulnerability, please follow the instructions in the [security.md](/security.md) file.