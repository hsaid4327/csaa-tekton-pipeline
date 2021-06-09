# csaa-tekton-pipeline
This project setups up an openshift pipeline (OC tekton) for building the image and deploying the application.
# setup
The tekton pipeline is setup by executing the following steps:
```
git clone https://github.com/hsaid4327/csaa-tekton-pipeline.git 
oc new-project csaa-tekton-pipeline
oc adm policy add-scc-to-user privileged -z pipeline

```
### Build the resources
```
cd resources
oc apply -n csaa-tekton-pipeline -f build-resources.yaml
tkn ls
```
