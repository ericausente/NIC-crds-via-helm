# kubernetes-ingress-crds
Script that will run ingress controller along with the CRD Examples


# Helm Installation (If you have not installed yet)
from: https://helm.sh/docs/intro/install/

```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

# Installation of k8s-ingress with Helm
https://docs.nginx.com/nginx-ingress-ontroller/installation/installation-with-helm/

Go back to your home directory: 
```
$ cd ~
```

Clone the Ingress Controller repo:
```
$ git clone https://github.com/nginxinc/kubernetes-ingress.git --branch v2.3.0
```

Change your working directory to /deployments/helm-chart:
```
$ cd kubernetes-ingress/deployments/helm-chart
```

# Adding the Helm Repository
This step is required if you’re installing the chart via the helm repository.
```
$ helm repo add nginx-stable https://helm.nginx.com/stable
$ helm repo update
```

# Using the NGINX IC Plus JWT token in a Docker Config Secret

Purpose: NGINX Plus Ingress Controller image from the F5 Docker registry in your Kubernetes cluster by using your NGINX Ingress Controller subscription JWT token 
Refer to https://docs.nginx.com/nginx-ingress-controller/installation/using-the-jwt-token-docker-secret/

1. Create a docker-registry secret on the cluster using the JWT token as the username, and none for password (password is unused). The name of the docker server is private-registry.nginx.com. Optionally namespace the secret.

Make sure to save your nginx-repo.jwt in /tmp/ directory. 

```
kubectl create secret docker-registry regcred --docker-server=private-registry.nginx.com --docker-username=$(cat /tmp/nginx-repo.jwt) --docker-password=none
```

Confirm the details of the created secret by running:
```
kubectl get secret regcred --output=yaml
```


