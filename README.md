# debug-k8s-pipeline

Code examples for my
[Interactive debugging within a Jenkins container running on Kubernetes](https://adamrushuk.github.io/interactive-debugging-within-a-jenkins-container-running-on-kubernetes/) blog post.

## Demo Notes

### Problem - Why debug within the pipeline?

Several main issues:

- Some pipelines (like Golden Images) could take an hour or more between builds:
  - very slow to develop and troubleshoot
- Couldn't debug within pipeline using standard methods:
  - debugging individual scripts fine outside of the pipeline
  - what if we need the full build environment?
- Packer and Ansible dont allow interactive debugging within build container:
  - no "pause on error" functionality
  - need terminal session attached

### Solution

The solution was to follow these steps:

1. Install a terminal multiplexer (like `screen`) within the build container, which allowed sessions you can attach to.
1. Use Packer's new `error-cleanup-provisioner` to pause the build.
1. Connect to the build container within Kubernetes:
   1. `kubectl exec --namespace jenkins -it <pod_name> -- /bin/sh`
1. Attach to the screen session.
1. Use an interactive debugger, like the Ansible playbook debugger.

### Live Demo - Debugging within a Jenkins pipeline running on Kubernetes

1. VSCode: `F1 > Screencast Mode`
1. Start Jenkins pipeline:  
  *(This takes about 3 mins to spin up a build container and stop on error)*
1. Discuss the problems / solution, whilst Jenkins job is running.
1. Open the [Microsoft Kubernetes extension](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools) view in VSCode and select `jenkins` namespace in `k8s-cluster` AKS cluster.
1. Expand `Workloads > Pods` and refresh view to see the Jenkins pod named `debug-k8s-pipeline...`.
1. Right-click pod, select `Terminal`, then select the `builder` container from the drop-down list.
1. Debug using commands within `/notes/debug_jenkins_container.sh`.
