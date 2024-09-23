PROJECT NOT UNDER ACTIVE MANAGEMENT

This project will no longer be maintained by Intel.

Intel has ceased development and contributions including, but not limited to, maintenance, bug fixes, new releases, or updates, to this project.  

Intel no longer accepts patches to this project.

If you have an ongoing need to use this project, are interested in independently developing it, or would like to maintain patches for the open source software community, please create your own fork of this project.  

Contact: webadmin@linux.intel.com
# Overview
This repository contains user-tailored container SELinux policies and the method for deploying these policies on Red Hat OpenShift Container Platform. These SELinux policies are required for the device plugins and the workloads leveraging these device plugins in [intel-device-plugins-for-kubernetes](https://github.com/intel/intel-device-plugins-for-kubernetes) to deploy on Red Hat OpenShift Container Platform. So the device plugin and workload do not have to run as the privileged container, see [issue](https://github.com/intel/intel-device-plugins-for-kubernetes/issues/762).

These policies create a new domain called `container_device_t` for user workloads, `container_device_plugin_t` for device plugins, and `container_device_plugin_init_t` for init containers. The device plugins are labeled as `container_device_plugin_t` by SELinux so they can be assigned the proper permissions to access the resources on the host.
These policies are derived from the corresponding policies in [container-selinux](https://github.com/containers/container-selinux) project.

## Building and Installing the SELinux policies in RHEL

The following steps have been verified on `RHEL 8.5`. To build the policies, perform the following steps:
```
$ git clone https://github.com/intel/user-container-selinux.git
$ export USER_CONTAINER_SELINUX_SRC=/path/to/user-container-selinux
$ cd $USER_CONTAINER_SELINUX_SRC
```
Install necessary packages: 
```
$ sudo dnf -y install make selinux-policy selinux-policy-devel container-selinux
```
Build policy binary:
```
$ make -f /usr/share/selinux/devel/Makefile
```
The command above creates a policy binary file named `container_device.pp`. To install the policy, run the following command:
```
$ sudo semodule -i container_device.pp
```
To verify that the policy is installed properly, run the command below to verify that it lists `container_device`.
```
$ sudo semodule -l | grep container_device 
```
The grep result of container_device shows that the policy is installed correctly.

## Deploying the SELinux policy on a Red Hat OpenShift cluster

Before deploying the SELinux policy, make sure `oc` OpenShift CLI commands are installed on the development environment and verify that the OpenShift cluster is up and running. Also, make sure that the user has `cluster-administrator` privileges. The instructions for installing `oc` OpenShift CLI commands can be found [here](https://docs.openshift.com/container-platform/4.10/cli_reference/openshift_cli/getting-started-cli.html). This policy is tested on Red Hat OpenShift version 4.10. To deploy the policies on OpenShift Container Platform, run the following commands:
```
$ oc login (if not already logged in)
$ oc apply -f https://raw.githubusercontent.com/intel/user-container-selinux/main/policy-deployment.yaml
```
To verify that it is installed properly, run the command below and verify that it lists `container_device`.
```
$ oc debug node/<node-name>
$ chroot /host
$ semodule -l | grep container_device
```
**Note:** Replace `<node-name>` with the name of the node on which you would like to check SELinux policy status.

## License
user-container-selinux policy code is under GNU GPL v2.0 license. See the [LICENSE](/LICENSE) file for details.

## Security
If any potential security vulnerabilities are discovered, please follow the guidelines in the [security.md](/security.md) file.

