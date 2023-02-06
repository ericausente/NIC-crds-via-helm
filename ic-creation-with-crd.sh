#!/bin/bash

#helm install my-ingress nginx-stable/nginx-ingress --set controller.image.repository=private-registry.nginx.com/nginx-ic-nap/nginx-plus-ingress --set controller.nginxplus=true --set controller.appprotect.enable=true --set controller.image.tag=2.3.0 --set controller.serviceAccount.imagePullSecretName=regcred --set controller.service.type=NodePort --set controller.service.httpsPort.nodePort=32137 --set prometheus.create=true

## With External Traffic Policy set to Cluster (since by default it is set to Local)

#helm install my-ingress nginx-stable/nginx-ingress --set controller.image.repository=private-registry.nginx.com/nginx-ic-nap/nginx-plus-ingress --set controller.nginxplus=true --set controller.appprotect.enable=true --set controller.image.tag=3.0.1 --set controller.serviceAccount.imagePullSecretName=regcred --set controller.service.type=NodePort --set controller.service.httpsPort.nodePort=32137 --set controller.service.externalTrafficPolicy=Cluster --set prometheus.create=true

#removal of cluster as externaltrafficpolicy type and adding the replica as 2 and daemonset kind

helm uninstall my-ingress

helm install my-ingress nginx-stable/nginx-ingress --set controller.image.repository=private-registry.nginx.com/nginx-ic-nap/nginx-plus-ingress --set controller.nginxplus=true --set controller.appprotect.enable=true --set controller.image.tag=3.0.1 --set controller.serviceAccount.imagePullSecretName=regcred --set controller.service.type=NodePort --set controller.service.httpsPort.nodePort=32137 --set controller.replicaCount=1 --set controller.kind=deployment --set prometheus.create=true --set controller.readyStatus.initialDelaySeconds=30 --set controller.service.externalTrafficPolicy=Cluster

echo
echo
echo "Here are the available resources":
ls ../kubernetes-ingress/examples/custom-resources/

echo
echo "===================="
echo "===================="
echo

echo What ready-made example would you like to deploy? Paste the exact name:

read path
echo You chose: $path
echo Now applying all the yaml resources under ../kubernetes-ingress/examples/custom-resources/$path

for i in ../kubernetes-ingress/examples/custom-resources/$path/*.yaml
do kubectl apply -f $i
done


while true; do

read -p "Note that HTTPS is listening on NodePort 32137. If you are done with the test, do you wish to delete the resources created? (yes/no) " yn

case $yn in
        yes ) echo ok, we will proceed;
                for j in ../kubernetes-ingress/examples/custom-resources/$path/*.yaml;
                        do kubectl delete -f $j;
                        helm uninstall my-ingress -n default 2>/dev/null;
                        done;
                break;;
        no ) echo exiting...;
                exit;;
        * ) echo invalid response;;
esac

done
