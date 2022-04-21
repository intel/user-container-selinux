# Overview
This repo contains a Selinux policy and the method to deploy it in openshift for Intel device plugins operator. For the plugins in [intel-device-plugins-for-kubernetes](https://github.com/intel/intel-device-plugins-for-kubernetes) to work properly in openshift, this selinux policy is required.

In openshift, the selinux is in enforcing mode by default. The containers run in container_t domain by default but the containers running device plugins do not have enough access to run properly. This policy gives proper required access to those policies.

This policy creates a new domain called container_sr_t and the device plugins run as that label and have all the necessary access.


# Deploying this plugin

- clone this repo
- run 'oc apply -f rbac.yaml'
- run 'oc apply -f policy-deployment.yaml'

