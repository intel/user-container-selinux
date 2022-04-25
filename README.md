# Overview
This repository contains a user tailored container SELinux policies and the method for deploying these policies on Red Hat OpenShift Container Platform. This SELinux policy is required for the plugins in [intel-device-plugins-for-kubernetes](https://github.com/intel/intel-device-plugins-for-kubernetes) to deploy on Red Hat OpenShift with proper SELinux permissions.

This policy creates a new domain called container_device_t and the device plugins run as that label and have all the necessary privileges.
The policy is derived from the [container-selinux](https://github.com/containers/container-selinux) project.

## Building policy

The policy is part of the image and is built during docker build. To build the policy:
- install selinux-policy development package `dnf -y selinux-policy-devel`
- run make `make -f /usr/share/selinux/devel/Makefile`

## Deploying the SELinux policy

- To deploy the policy, run `oc apply -f https://raw.githubusercontent.com/mregmi/user-container-selinux/main/policy-deployment.yaml`


## License

All of the source code required to build user-container-selinux
is available under Open Source licenses. Binaries are distributed as container images on
Red Hat Container Registry. Those images contain license texts under `/licenses`.
