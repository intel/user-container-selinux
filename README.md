# Overview
This repository contains SElinux policy and a method for deploying this policy in RedHat OpenShift Container Platform for Intel Device Plugins Operator. This SELinux policy is required for the plugins in [intel-device-plugins-for-kubernetes](https://github.com/intel/intel-device-plugins-for-kubernetes) to work correctly in RedHat OpenShift.

In RedHat OpenShift, the SELinux is in enforcing mode by default. Containers run in the container_t domain by default, but containers running device plugins do not have enough access to run correctly. This policy grants the necessary privileges to those policies.

This policy creates a new domain called container_sr_t and the device plugins run as that label and have all the necessary privileges.


## Deploying the SELinux policy

- clone this repository
- run `oc apply -f policy-deployment.yaml` to deploy the policy


## License

All of the source code required to build user-container-selinux
is available under Open Source licenses. Binaries are distributed as container images on
RedHat Container Registry. Those images contain license texts under `/licenses`.
