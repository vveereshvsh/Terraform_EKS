# Autoscaling

## Download example
Download this example on your workspace
```sh
git clone https://github.com/vveereshvsh/Terraform_EKS
cd Terraform_EKS
```

## Setup
[This] is the example of terraform configuration file to create a managed EKS on your AWS account. Check out and apply it using terraform command.

Run terraform:
```
terraform init
terraform apply
```
Also you can use the `-var-file` option for customized paramters when you run the terraform plan/apply command.
```
terraform plan -var-file variables.tfvars
terraform apply -var-file variables.tfvars
```

## Horizontal Pod Autoscaler (HPA)
The [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) automatically scales the number of Pods in a replication controller, deployment, replica set or stateful set based on observed CPU utilization.

This example requires a running Kubernetes cluster and kubectl. [Metrics server](https://github.com/kubernetes-sigs/metrics-server) monitoring needs to be deployed in the cluster to provide metrics through the [Metrics API](https://github.com/kubernetes/metrics). Horizontal Pod Autoscaler uses this API to collect metrics. To learn how to deploy the metrics-server, see the metrics-server documentation.

## Clean up
Delete the example from the kubernetes cluster.
```sh
kubectl delete -f manifests/node-app.yaml
```

To remove all infrastrcuture, run terraform:
```sh
terraform destroy
```
Don't forget you have to use the `-var-file` option when you run terraform destroy command to delete the aws resources created with extra variable files.
```sh
terraform destroy -var-file variables.tfvars
```
# Terraform_EKS
