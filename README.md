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
#### Build PipelineResources
The pipelineResources sepcify the image registry for the output of the image and the git repository of the application to be built. The springboot application that is built into an image is located at:
https://github.com/hsaid4327/csaa-tekton-app.git
```
cd resources
oc apply -n csaa-tekton-pipeline -f build-resources.yaml
tkn ls
```
#### Build Task
```
cd tasks
oc apply -n csaa-tekton-pipeline -f build-app-task.yaml
```
# Run Task 
You can run the task independently of the pipleline to verify if it is working as expected
```
tkn task start -n csaa-tekton-pipeline build-app --inputresource='source=git-source' --outputresource='builtImage=tekton-tutorial-greeter-image' --param contextDir='springboot' --showlog

tkn tr ls
tkn taskrun describe <taskrun-name>

--- logs for one task run
tkn tr logs -f -a <taskrun pod>

--- list containers of the task
oc get pods --selector=tekton.dev/task=build-app
oc logs -f <podname>  //get the list of containers

--- logs of the task
oc logs --container=step-build-image -f <podname>
```
# Create Pipeline
## Create openshift client task
This task is already defined and can be used to deploy application using OCP manifests (deployment.xml, service.xml, route.xml)
```
oc create -n csaa-tekton-pipeline -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/openshift-client/0.1/openshift-client.yaml
```
## Implment Pipeline
```
oc apply -n csaa-tekton-pipeline -f svc-deploy.yaml
tkn pipeline ls

```
## Run Pipeline
```
tkn pipeline start svc-deploy --resource="appSource=git-source" --resource="appImage=tekton-tutorial-greeter-image" --param="contextDir=springboot" --showlog
```
You can also run the pipeline from OCP ui by selecting the Project in developer mode and then select pipeline

# Links

--- Installation of tkn cli
https://github.com/tektoncd/cli#installing-tkn


-- Documentation
https://github.com/tektoncd/pipeline/tree/main/docs#learn-more

--- pipeline resources documentation
https://github.com/tektoncd/pipeline/blob/main/docs/resources.md#resource-types

---tekton reference
https://tekton.dev/docs/pipelines/taskruns/


---- openshift 4.7 pipeline docs
https://docs.openshift.com/container-platform/4.7/cicd/pipelines/creating-applications-with-cicd-pipelines.html

--- Tutorial:
https://github.com/openshift/pipelines-tutorial/
https://redhat-scholars.github.io/tekton-tutorial/tekton-tutorial/tasks.html
https://developers.redhat.com/blog/2021/01/13/getting-started-with-tekton-and-pipelines#run_in_parallel_or_sequentially
