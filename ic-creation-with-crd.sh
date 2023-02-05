#!/bin/bash

#helm install mbs-ingress nginx-stable/nginx-ingress --set controller.image.repository=private-registry.nginx.com/nginx-ic-nap/nginx-plus-ingress --set controller.nginxplus=true --set controller.appprotect.enable=true --set controller.image.tag=2.3.0 --set controller.serviceAccount.imagePullSecretName=regcred --set controller.service.type=NodePort --set controller.service.httpsPort.nodePort=32137 --set prometheus.create=true

## With External Traffic Policy set to Cluster (since by default it is set to Local)

#helm install mbs-ingress nginx-stable/nginx-ingress --set controller.image.repository=private-registry.nginx.com/nginx-ic-nap/nginx-plus-ingress --set controller.nginxplus=true --set controller.appprotect.enable=true --set controller.image.tag=2.3.0 --set controller.serviceAccount.imagePullSecretName=regcred --set controller.service.type=NodePort --set controller.service.httpsPort.nodePort=32137 --set controller.service.externalTrafficPolicy=Cluster --set prometheus.create=true

#removal of cluster as externaltrafficpolicy type and adding the replica as 2 and daemonset kind

helm install mbs-ingress nginx-stable/nginx-ingress --set controller.image.repository=private-registry.nginx.com/nginx-ic-nap/nginx-plus-ingress --set controller.nginxplus=true --set controller.appprotect.enable=true --set controller.image.tag=2.3.0 --set controller.serviceAccount.imagePullSecretName=regcred --set controller.service.type=NodePort --set controller.service.httpsPort.nodePort=32137 --set controller.replicaCount=3 --set controller.kind=daemonset --set prometheus.create=true --set controller.readyStatus.initialDelaySeconds=30

echo
echo
echo "Here are the available resources":
ls /home/ericausente/kubernetes-ingress/examples/custom-resources/

echo
echo "===================="
echo "===================="
echo

echo What ready-made example would you like to deploy? Paste the exact name:

read path
echo You chose: $path
echo Now applying all the yaml resources under /home/ericausente/kubernetes-ingress/examples/custom-resources/$path
#echo Your second car was: $car2
#echo Your third car was: $car3

for i in /home/ericausente/kubernetes-ingress/examples/custom-resources/$path/*.yaml
do kubectl apply -f $i
done


while true; do

read -p "Are you done with the test? Do you wish to delete the resources created? (yes/no) " yn

case $yn in
        yes ) echo ok, we will proceed;
                for j in /home/ericausente/kubernetes-ingress/examples/custom-resources/$path/*.yaml;
                        do kubectl delete -f $j;
                        helm uninstall mbs-ingress -n default 2>/dev/null;
                        done;
                break;;
        no ) echo exiting...;
                exit;;
        * ) echo invalid response;;
esac

done
