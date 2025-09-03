# Run below commands to
1. Configure proper VPC + subnets (public and private) 
2. Create an EKS cluster with at least 2 nodes in 2 AZs.

terraform workspace list

terraform workspace select dev

terraform init

terrafrom fmt

terraform validate

terraform plan -target=module.vpc -var-file=dev.tfvars

terraform apply -target=module.vpc -var-file=dev.tfvars

terraform plan -target=module.eks -var-file=dev.tfvars

terraform apply -target=module.eks -var-file=dev.tfvars

# switch to k8s-manifests directory and run below command to

1. Deploy 5 demo services (simple apps like nginx or httpbin) to show the cluster is working.

   kubectl apply -f .

# switch to istio directory and run below command to

1. Install Istio with Ambient profile.

2. Expose one service externally via Istio.

  kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
  kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml

  curl -L https://istio.io/downloadIstio | sh -

  cd istio-1.27.0  # Or the version you downloaded

  export PATH=$PWD/bin:$PATH

  istioctl install --set profile=ambient --skip-confirmation

  kubectl get pods -n istio-system

  helm install istio-ingressgateway istio/gateway \
  --namespace istio-system
  
  kubectl apply -f ingress-gateway.yaml
  
  kubectl apply -f nginx-virtualservice.yaml
  
  kubectl get svc istio-ingressgateway -n istio-system

# switch to elastic directory and run below command to
1. Deploy ELK stack (Elasticsearch + Kibana) for logs.

  helm repo add elastic https://helm.elastic.co

  helm repo update
  
  helm install elasticsearch elastic/elasticsearch --namespace elk --create-namespace --version 8.13.4 -f elastic-values.yaml
  
  kubectl get secret elasticsearch-es-elastic-user -o go-template='{{.data.elastic | base64decode}}' --namespace elk
  
  helm install kibana elastic/kibana --namespace elk --version 8.13.4 -f kibana-values.yaml

  helm install filebeat elastic/filebeat \
  --namespace elk \
  --set "daemonset.enabled=true" \
  --set "podSecurityContext.enabled=true" \
  --set "podSecurityContext.runAsUser=0" \
  -f filebeat-values.yaml \
  --set "output.elasticsearch.hosts[0]=http://elasticsearch-master.logging.svc.cluster.local:9200"
  
  kubectl port-forward service/kibana-kb-http 5601:5601 --namespace elk

# now you may login at 127.0.0.1:5601 and access kibana UI

# switch to signoz directory and run below command to
1. Deploy SigNoz for dashboards/APM.

  helm repo add signoz https://charts.signoz.io

  helm repo update

  helm install signoz signoz/signoz \
  --namespace platform --create-namespace \
  -f signoz-values.yaml
  
  kubectl -n platform get pods
  
  export SERVICE_NAME=$(kubectl get svc --namespace platform -l "app.kubernetes.io/component=frontend" -o jsonpath="{.items[0].metadata.name}")
  
  kubectl --namespace platform port-forward svc/$SERVICE_NAME 3301:3301

# now you may login at 127.0.0.1:3301 and access Signoz UI
