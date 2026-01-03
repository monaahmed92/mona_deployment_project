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

-------------------------------------------deploy the manifest files----------------------------------------------
1) kubectl apply -f postgres.yaml
2) kubectl apply -f backend.yaml
3) kubectl apply -f frontend.yaml
   
   -------------------------------------------------------
1) get the url of the FE
 kubectl get svc frontend -w
   
NAME       TYPE           CLUSTER-IP       EXTERNAL-IP                                                                    PORT(S)        AGE
frontend   LoadBalancer   172.20.117.207   k8s-default-frontend-8f155aede8-f9d443aa23919101.elb.us-east-1.amazonaws.com   80:32250/TCP   34m

---------------------------------------------------------------------------------------------------------------------------------------------------------------------






 

Project Structure: 



 

 

 

 

Test using docker_compose: 


 

 

Terraform: 

 

Configuring: VPC ,Subnets , ECR private repositories(Frontend& Backend), EKS cluster  

 

Providers: 



 

 

Variables: 


 

1) VPC: 


 

2)ECR Private Repos(FE& BE): 


 

 

3)EKS: 

 


 

 

Terraform commands: 

terraform init 

terraform validate 

terraform apply 

 

--------------------------------------------------Jenkin Pipeline------------------------------------------- 

 

1. Install Jenkins Plugins 

Pipeline 

Credentials Binding 

AWS Credentials 

2- Add AWS credentials(Access key & Secret key) 

 


 

3-Add  "Jenkinsfile" in terraform directory  

 


 

 

4- Set Up GitHub Webhook 


 

 

5- Add Jenkins Pipeline: 



 

 

 

 


 

 

AWS Infra : 

------------ 



 

 

 

 

 

Question: should I add the approval stage in Jenkins file or not? 

 

 


 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

----------------------------------K8 deployment files------------------------------ 


 

 

Backend manifest file: 



 

Frontend manifest file: 

 

 


 


 

Postgres manifest file: 

 


 


 

 

 

Jenkins: 

 

 

-------------------------Jenkins Pipelines (Terraform & FE & BE) --------------- 

 


 

BE Pipeline: 

 


 


 

 


 

Jenkin file: 

 


 

 

 

FE Pipeline: 


 

Jenkin file: 

 


 
