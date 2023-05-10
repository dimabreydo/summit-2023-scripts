export CLUSTER_NAME=mgmt
 
cd ~/environment/gitops-system
 
kubectl apply -f ./clusters/${CLUSTER_NAME}/flux-system/gotk-components.yaml
 
kubectl create secret generic flux-system -n flux-system \
    --from-file=identity=${HOME}/.ssh/gitops \
    --from-file=identity.pub=${HOME}/.ssh/gitops.pub \
    --from-file=known_hosts=${HOME}/.ssh/codecommit_known_hosts
 
kubectl apply -f ./clusters/${CLUSTER_NAME}/flux-system/gotk-sync.yaml
