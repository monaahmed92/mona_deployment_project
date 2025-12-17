Docker images :
1) backend: docker build -t monaahmed/backend:health .
2) frontend:  docker build -t monaahmed/frontend .
3) push images:   docker push monaahmed/frontend && docker push  monaahmed/backend:health
4) k8 deployment files:   kubectl apply -f .

5) docker links:
6) https://hub.docker.com/repository/docker/monaahmed/backend/general
7) https://hub.docker.com/repository/docker/monaahmed/frontend/general
-----------------------Push images from dockerhub to ECR-------------------------
   1) Login to aws account:
      aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 134667369554.dkr.ecr.us-east-1.amazonaws.com
   3) create repo FE:  aws ecr create-repository --repository-name frontend
   4) create repo BE:  aws ecr create-repository --repository-name backend
   5) Tag images:
   *  docker tag monaahmed/backend:health 134667369554.dkr.ecr.us-east-1.amazonaws.com/backend:latest
   *  docker tag monaahmed/frontend:latest 134667369554.dkr.ecr.us-east-1.amazonaws.com/frontend:latest
   5)PUSH TO ECR:
   * docker push 134667369554.dkr.ecr.us-east-1.amazonaws.com/backend:latest
   * docker push 134667369554.dkr.ecr.us-east-1.amazonaws.com/frontend:latest
6) Create Kubernetes secret:
✅ This creates a Kubernetes secret named ecr-registry using your AWS ECR credentials in a single command.
** aws ecr get-login-password --region us-east-1 | kubectl create secret docker-registry ecr-registry --docker-server=134667369554.dkr.ecr.us-east-1.amazonaws.com --docker-username=AWS --docker-password-stdin

------------------------------------------------------------------------------------
** configure aws : aws eks update-kubeconfig --region us-east-1 --name depi-cluster


