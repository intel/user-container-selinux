# Overview
This repository contains user tailored container SELinux policies and the method for deploying these policies on Red Hat* OpenShift* Container Platform. These SELinux policies are required for the device plugins and the workloads leveraging these device plugins in [intel-device-plugins-for-kubernetes](https://github.com/intel/intel-device-plugins-for-kubernetes) to deploy on Red Hat OpenShift Container Platform. So the device plugin and workload don't have to run as the privileged container.

These policies create new domains called `container_device_t` for user workloads, `container_device_plugin_t` for device plugins and `container_device_plugin_init_t` for init containers. The device plugins are labeled as container_device_plugin_t by SELinux so it can be assigned the proper permissions to access the resources on the host.
These policies are derived from the corresponding policies in [container-selinux](https://github.com/containers/container-selinux) project.

## Building and Installing the SELinux policies in RHEL

We have only verified these on `RHEL 8.5`. To build the policies, please follow the steps below:

Get source code
```
$ git clone https://github.com/intel/user-container-selinux.git
$ export USER_CONTAINER_SELINUX_SRC=/path/to/user-container-selinux
$ cd $USER_CONTAINER_SELINUX_SRC
```
```
$ sudo dnf -y install make selinux-policy selinux-policy-devel container-selinux
$ make -f /usr/share/selinux/devel/Makefile
```
The above command creates a policy binary file named `container_device.pp`. To install the policy run:
```
$ sudo semodule -i container_device.pp
```
To verify that it is installed proper run the command below and verify that it lists `container_device`.
```
$ sudo semodule -l | grep container_device 
```
The `container_device` policy shows that the policy is properly installed.

## Deploying the SELinux policy on a Red Hat OpenShift cluster

Before deploying, make sure you have `oc` command installed in your work machine and your cluster is up and running. The instructions for downloading `oc` command can be found [here]{https://docs.openshift.com/container-platform/4.10/cli_reference/openshift_cli/getting-started-cli.html}. This policy is tested on Red Hat OpenShift version 4.10. Also make sure the user has cluster-administrator priviledges. To deploy the policies on OpenShift Container Platform, run:
```
$ oc login (if you are not already logged in)
$ oc apply -f https://raw.githubusercontent.com/intel/user-container-selinux/main/policy-deployment.yaml
```
To verify that it is installed properly run the command below and verify that it lists `container_device`.
```
$ oc debug node/<node-name>
$ chroot /host
$ semodule -l | grep container_device
```
Notes: change the node-name to the name of the node you want to check the SELinux policy statues.

## License
user-container-selinux is under GNU GPL v2.0 license. See the [LICENSE](/LICENSE) file for details.

## Security
If you discover any potential security vulnerability, please follow the instructions in the [security.md](/security.md) file.

*Other names and brands may be claimed as the property of others.
