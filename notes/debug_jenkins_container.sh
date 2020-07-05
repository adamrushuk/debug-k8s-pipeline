#!/usr/bin/env bash
#
# Attach to Jenkins agent container inside a Kubernetes pod


#region [OPTIONAL] init (use when not using K8s VSCode extension)
# confirm / switch context
kubectl config current-context
kubectl ctx k8s-cluster

# show current pods
kubectl get pod --namespace jenkins

# enter container shell
podname=$(kubectl get pod --namespace jenkins -l jenkins=slave -o jsonpath="{.items[0].metadata.name}")
kubectl exec --namespace jenkins -it "$podname" -- /bin/sh
#endregion init



#region attach to screen session
# show env vars
# note the Jenkinfile job env vars are missing (eg: CI_DEBUG_ENABLED, and PACKER_*)
printenv | sort | grep -E "CI_|PACKER"

# list screen sessions
screen -ls

# attach detached session
screen -r

# show env vars
# now Jenkins job env vars exist
printenv | sort | grep -E "CI_|PACKER"
#endregion attach to screen session



#region log files
# view packer files
ls -l /tmp/ | grep packer

# last packer shell command
cat /tmp/packer-shell*

# main packer log
tail /tmp/packer-log*

# auto-generated ansible inventory file, needed for debugging below
cat /tmp/packer-provisioner-*
#endregion log files



#region debug ansible
# set config
export ANSIBLE_CONFIG="./ansible/ansible.cfg"

# simple ping check
ansible all -m ping --check --user packer -i /tmp/packer-provisioner-*

# run playbook
ansible-playbook ./ansible/playbook-with-error.yml -i /tmp/packer-provisioner-*



#region fix task 1
# (p)rint task and var info
p task
p task_vars['package_name']

# print task results
p result._result

# update task var
task_vars['package_name'] = 'screen'
p task_vars['package_name']
update_task
redo
#endregion fix task 1



#region fix task 2
# (p)rint task and arg info
p task
p task.args['data']

# print task results
p result._result

# update task arg
task.args['data'] = 'test'
p task.args['data']
redo
#endregion fix task 2

#endregion debug ansible
