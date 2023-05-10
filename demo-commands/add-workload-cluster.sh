cd ~/environment
./eks-multi-cluster-gitops/bin/add-cluster.sh gitops-system commercial-staging 

cd ~/environment/gitops-system
git pull —rebase origin main
git add .
git commit -m "Added cluster commercial-staging"
git push 