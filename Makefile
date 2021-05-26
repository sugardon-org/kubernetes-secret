CONTROLLER_NAMESPACE=sealed-secrets


# Get sealed-secrets public key
pub-cert.pem:
	kubeseal --fetch-cert \
	  --controller-namespace=${CONTROLLER_NAMESPACE} \
	  --controller-name=sealed-secrets-controller \
	  > pub-cert.pem

# encrypt $ENCRYPT file
# example:
# $ make encrypt TARGET_NAME=./sealed-secrets-client-side/sugardon01/tekton-cicd/sugardon-dockerhub
encrypt:
	kubeseal -o=yaml --cert=./pub-cert.pem < ${TARGET_NAME}.yaml > ${TARGET_NAME}-sealedsecret.yaml

# Backup private key
# You can recover following
# $ kubectl apply -f master.key
backup:
	kubectl get secret -n ${CONTROLLER_NAMESPACE} -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml > master.key

# example:
# make recovery TARGET_NAME=./sealed-secrets-client-side/sugardon01/tekton-cicd/sugardon-dockerhub
recovery:
	kubeseal --recovery-unseal --recovery-private-key master.key -o yaml < ${TARGET_NAME}-sealedsecret.yaml > ${TARGET_NAME}-recovery.yaml
