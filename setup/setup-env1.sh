cd ~/environment
cp -r eks-multi-cluster-gitops/repos/gitops-system/* gitops-system/
cp -r eks-multi-cluster-gitops/repos/gitops-workloads/* gitops-workloads/
 
sed -i "s/AWS_REGION/$AWS_REGION/g" \
   gitops-system/clusters-config/template/def/eks-cluster.yaml \
   gitops-system/tools-config/external-secrets/sealed-secrets-key.yaml
 
sed -i "s~REPO_PREFIX~$REPO_PREFIX~g" \
     gitops-system/workloads/template/git-repo.yaml
 
sed -i "s~REPO_PREFIX~$REPO_PREFIX~g" \
     gitops-system/clusters/mgmt/flux-system/gotk-sync.yaml \
     gitops-system/clusters/template/flux-system/gotk-sync.yaml
 
sed -i "s~REPO_PREFIX~$REPO_PREFIX~g" \
     gitops-workloads/template/app-template/git-repo.yaml
 
if [[ "$REPO_PREFIX" == *"git-codecommit"* ]]; then
  LIBGIT2='. |= (with(select(.kind=="GitRepository");.spec |= ({"gitImplementation":"libgit2"}) + .))'
  yq -i e "$LIBGIT2" \
    gitops-system/workloads/template/git-repo.yaml
  yq -i e "$LIBGIT2" \
    gitops-system/clusters/mgmt/flux-system/gotk-sync.yaml
  yq -i e "$LIBGIT2" \
    gitops-system/clusters/template/flux-system/gotk-sync.yaml
  yq -i e "$LIBGIT2" \
    gitops-workloads/template/app-template/git-repo.yaml
fi
 
sed -i "s~EKS_CONSOLE_IAM_ENTITY_ARN~$EKS_CONSOLE_IAM_ENTITY_ARN~g" \
  gitops-system/tools-config/eks-console/aws-auth.yaml
sed -i "s~EKS_CONSOLE_IAM_ENTITY_ARN~$EKS_CONSOLE_IAM_ENTITY_ARN~g" \
  gitops-system/tools-config/eks-console/role-binding.yaml
 
kubeseal --cert sealed-secrets-keypair-public.pem --format yaml <git-creds-system.yaml >git-creds-sealed-system.yaml
cp git-creds-sealed-system.yaml gitops-system/clusters-config/template/secrets/git-secret.yaml
cp git-creds-system.yaml git-creds-workloads.yaml
yq e '.metadata.name="gitops-workloads"' -i git-creds-workloads.yaml
kubeseal --cert sealed-secrets-keypair-public.pem --format yaml <git-creds-workloads.yaml >git-creds-sealed-workloads.yaml
cp git-creds-sealed-workloads.yaml gitops-system/workloads/template/git-secret.yaml
 
cd ~/environment/gitops-system
git add .
git commit -m "initial commit"
git push origin main
 
cd ~/environment/gitops-workloads
git add .
git commit -m "initial commit"
git push origin main
 
 
cd ~/environment
cp -r eks-multi-cluster-gitops/repos/apps-manifests/product-catalog-fe-manifests/* product-catalog-fe-manifests/

cd ~/environment
cp -r eks-multi-cluster-gitops/repos/apps-manifests/product-catalog-api-manifests/v1/* product-catalog-api-manifests/
cd ~/environment
cp -r eks-multi-cluster-gitops/repos/apps-manifests/product-catalog-api-manifests/v2-staging/* product-catalog-api-manifests/kubernetes/

cd ~/environment
cd product-catalog-api-manifests
git add .
git commit -m "baseline version"
git push origin main


cd ~/environment
cd product-catalog-fe-manifests
git add .
git commit -m "baseline version"
git push origin main

wget https://github.com/fluxcd/flux2/releases/download/v0.41.2/flux_0.41.2_linux_amd64.tar.gz
tar -xvf flux_0.41.2_linux_amd64.tar.gz
flux —version
ls -la
which flux
sudo cp flux /usr/local/bin/
flux —version
flux get kustomization

cd ~/environment/gitops-system
git pull —rebase origin main
