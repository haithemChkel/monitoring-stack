
cd ./DotNetOtelExample

#docker build -t dotnet-otel-example:latest .
#docker tag dotnet-otel-example:latest forlink/monitoring-tests:latest
#docker login
#docker push forlink/monitoring-tests:latest


cd ../k8s/

minikube stop
minikube delete
minikube start

kubectl apply -f dotnet-webapi-deployment.yaml

kubectl apply -f grafana-datasources.yaml
kubectl apply -f grafana-deployment.yaml

kubectl apply -f otel-collector-config.yaml
kubectl apply -f otel-collector-deployment.yaml
kubectl apply -f otel-collector-service.yaml

kubectl apply -f loki-deployment.yaml

kubectl apply -f tempo-config.yaml
kubectl apply -f tempo-deployment.yaml

kubectl port-forward service/dotnet-webapi 8080:8080

minikube service grafana

# registry   ClusterIP   10.109.84.137   <none>        80/TCP,443/TCP   20s