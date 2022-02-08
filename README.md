
## __Algorand node deployment in Docker__

This simple Dockerfile is intended to run an Algorand node in a local environment, in no more than 5 minutes, assuming you have the basic knowledge on how to use this tool.

## Requirements
- Internet connectivity
- Docker ready to be used on your computer/mac

## Installation

Copy the contents of this GIT repository manually to your device, or using the following command

example: git clone git@github.com:vipeeerr/algorand-node-docker.git my-algorand-node
```sh
git clone git@github.com:vipeeerr/algorand-node-docker.git [destination-folder]
```
Go to the folder where you downloaded the content

example: cd algorand/my-algorand-node
```sh
cd [destination-folder]
```
Inside the folder, we run the necessary Docker commands.

- Docker build will create the image with a friendly tag called "algorand-node"
- Docker images will show us the ID of the newly created image, among other data
- Docker run with its parameters will give us access to the ports configured in the dockerfile to use the node API from outside the docker

An example of the last command would be:
__docker run -p 4001:4001 AABBFF4431AA__
```sh
docker build --tag=algorand-node .
docker images
docker run -p 4001:4001 IMAGE_ID_OF_ALGORAND_NODE_OBTAINED_FROM_DOCKER_IMAGES
```

With the node up and running, we can start updating it. 

We first run "docker ps" to get the ID of our running algorand-node container, then we open a console inside our docker using the desktop application, or with the following command:
```sh
docker ps
docker exec -it [container-id] /bin/bash
```
In our computers, we go to this [Algorand URL](https://algorand-catchpoints.s3.us-east-2.amazonaws.com/channel/mainnet/latest.catchpoint) and copy the content that it will give us

Today, January 08, the result returned is: "19120000#QI3FLJXOZ376PJQRG7VAZPUEH6EGOSUA23Q3KBHLPKYHABZEL5WA"

Then, back in our docker container console we do:
```sh
goal node catchup 19120000#QI3FLJXOZ376PJQRG7VAZPUEH6EGOSUA23Q3KBHLPKYHABZEL5WA
```
With this command executed with the most recent result you could get from the Algorand URL, the node will start updating to the most recent block. Once this process is completed, you will be able to use it normally.

To monitor the node, you can run inside the container:
```sh
goal node status -w 100
```
When the node has finished synchronizing, inside our container, we can obtain the token to use it with the following command:
```sh
cat data/algod.token
```
The IP to use it is __0.0.0.0:4001__

The last section of the IP is the port, which was configured in the Dockerfile, and at the time of running our container with "Docker run".

We can access a basic response with an application such as Postman by making a GET request to the following address:
```sh
http://0.0.0.0:4001/swagger.json
```
Finally, if we want to use the node to consume one of the many available Algorand SDKs, we can follow this example in Python with our IP and port, plus our token obtained with "cat data/algod.token".
```PYTHON
    algod_address = "http://localhost:4001" #node ip
    algod_token = "a12d99fcadfs9372z1ax1924xc5130b3e6nvcd3d429c2ffdfvbvc01h6f" #node token
    headers = {
        "X-API-Key": algod_token,
    }
    algod_client = algod.AlgodClient(algod_token, algod_address, headers)
```
__With all this commented, the node should be enabled to be used by API or with the Algorand SDKs.__

It is important to note that if you shut down the computer, or close the Docker container, the node will lose its synchronization and it will take a few minutes, hours or days to get it back in sync. If too much time has passed, you can always re-run "goal node catchup" with the information received from the Algorand URL to update the node faster.


