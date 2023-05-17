source ~/environment/eks-multi-cluster-gitops/bin/connect-to-cluster.sh commercial-staging
kubectl -nproduct-catalog-fe port-forward svc/product-catalog-fe-staging 8080:80