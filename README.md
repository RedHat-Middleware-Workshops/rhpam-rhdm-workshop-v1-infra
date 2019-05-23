Red Hat Process Automation Manager - Red Hat Decision Manager Workshop Installer v2 [![Build Status](https://travis-ci.org/RedHat-Middleware-Workshops/rhpam-rhdm-workshop-v1-infra.svg?branch=master)](https://travis-ci.org/RedHat-Middleware-Workshops/rhpam-rhdm-workshop-v1-infra)
=========

The provided Ansible Playbook Bundle automates preparing an OpenShift cluster for the Red Hat Process Automation Manager (RHPAM) and Red Hat Decision Manager (RHDM) Labs by deploying required services (lab instructions, Business Central, KIE Server, etc.) which are used during the labs.

The instructions for using this APB are as follows:

Step 1:
Make sure you have the right settings for looking up Quay for the apb
Goto the ansible-service-broker project, and in the configMap add the following entry.

   ```
  - type: quay
    name: openshiftlabs
    url: https://quay.io
    org: openshiftlabs
    tag: ocp-3.11
    white_list:
      - ".*-apb$"
  ```      


If running via your own machine you can run the following command  

  ```
  oc new-project labs-infra

  oc run apb --restart=Never --image="quay.io/openshiftlabs/rhpam-rhdm-workshop-v1-apb:ocp-3.11" \
-- provision -vvv -e namespace="labs-infra" -e openshift_token=$(oc whoami -t) -e user_count=50 -e requested_cpu=2 -e requested_memory=4Gi -e modules=m1,m4
  ```

to follow the logs
  ```
  oc logs apb -f
  ```
