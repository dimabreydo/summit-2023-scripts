#Add API application to gitops-workloads
 
export KNOWN_HOSTS=$(head -1 ~/.ssh/codecommit_known_hosts)
 
cd ~/environment
eks-multi-cluster-gitops/bin/add-cluster-app.sh \
  ./gitops-workloads \
  commercial-staging \
  product-catalog-api \
  staging \
  main \
  eks-multi-cluster-gitops/initial-setup/secrets-template/git-credentials.yaml \
  ~/.ssh/gitops \
  ~/.ssh/gitops.pub \
  "$KNOWN_HOSTS" \
  ./sealed-secrets-keypair-public.pem

# Push Add API application to gitops-workloads


# cd ~/environment
# cd gitops-workloads
# git add .
# git commit -m "Add product-catalog-api to commercial-staging"
# git branch -M main
# git push --set-upstream origin main

 #Add FE application to gitops-workloads

cd ~/environment
eks-multi-cluster-gitops/bin/add-cluster-app.sh \
  ./gitops-workloads \
  commercial-staging \
  product-catalog-fe \
  staging \
  main \
  eks-multi-cluster-gitops/initial-setup/secrets-template/git-credentials.yaml \
  ~/.ssh/gitops \
  ~/.ssh/gitops.pub \
  "$KNOWN_HOSTS" \
  ./sealed-secrets-keypair-public.pem

#Push Add FE application to gitops-workloads
#Change Dynamo IAM Policy
cd ~/environment
printf -v policy "{\"Version\": \"2012-10-17\",\"Statement\": [{\"Sid\": \"AllowDynamoDB\",\"Action\": \"dynamodb:*\",\"Effect\": \"Allow\",\"Resource\": \"arn:aws:dynamodb:${AWS_REGION}:${ACCOUNT_ID}:table/products-staging\"}]}" ;\
policy="$policy" yq -i 'select(.kind == "Policy") |= .spec.forProvider.document=strenv(policy)' gitops-workloads/commercial-staging/product-catalog-api/app-iam.yaml

cd ~/environment
cd gitops-workloads
# git add .
# git commit -m "Add product-catalog to commercial-staging"
# git push
source ../setup/aliases.sh
cdgw
