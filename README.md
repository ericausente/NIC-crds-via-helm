# kubernetes-ingress-crds
Script that will run ingress controller along with the CRD Examples

Clean the conflicting resources (if there are any): 
```
kubectl delete ingressclass nginx
kubectl delete secret regcred
```

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

Go back to your home directory: 
```
cd ~
```

Clone the below repository and run the script
```
git clone https://github.com/ericausente/kubernetes-ingress-crds.git
cd kubernetes-ingress-crds
chmod +x ic-creation-with-crd.sh
./ic-creation-with-crd.sh
```

## If you have chosen to deploy the "basic configuration" example, copy paste the exact sample folder name. 

It will do the following (as it will apply all the yaml files contained in that folder):
Deploy the Cafe Application
Configure Load Balancing and TLS Termination
Create the VirtualServer resource:

## Then you can answer no to the confirmatory question. You can th open a new terminal or a client terminal that can talk to your K8s Cluster and follow the below to test: 

Prerequisites

    Save the public IP address of the Ingress Controller into a shell variable:

    $ IC_IP=XXX.YYY.ZZZ.III

    Save the HTTPS port of the Ingress Controller into a shell variable:

    $ IC_HTTPS_PORT=<port number>


Test the Configuration

    Check that the configuration has been successfully applied by inspecting the events of the VirtualServer:

    $ kubectl describe virtualserver cafe
    . . .
    Events:
      Type    Reason          Age   From                      Message
      ----    ------          ----  ----                      -------
      Normal  AddedOrUpdated  7s    nginx-ingress-controller  Configuration for default/cafe was added or updated

    Access the application using curl. We'll use curl's --insecure option to turn off certificate verification of our self-signed certificate and --resolve option to set the IP address and HTTPS port of the Ingress Controller to the domain name of the cafe application:

    To get coffee:

    $ curl --resolve cafe.example.com:$IC_HTTPS_PORT:$IC_IP https://cafe.example.com:$IC_HTTPS_PORT/coffee --insecure
    Server address: 10.16.1.182:80
    Server name: coffee-7dbb5795f6-tnbtq
    ...

If your prefer tea:

$ curl --resolve cafe.example.com:$IC_HTTPS_PORT:$IC_IP https://cafe.example.com:$IC_HTTPS_PORT/tea --insecure
Server address: 10.16.0.149:80
Server name: tea-7d57856c44-zlftd
...




