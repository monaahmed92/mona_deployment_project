Docker images :
1) backend: docker build -t monaahmed/backend:health .
2) frontend:  docker build -t monaahmed/frontend .
3) push images:   docker push monaahmed/frontend && docker push  monaahmed/backend:health
4) k8 deployment files:   kubectl apply -f .   


