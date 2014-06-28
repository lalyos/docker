# Getting latest dev binaries

Sometimes i want to check how docker works at the bleeding edge.
So I need the latest binaries build from github master.

## Linux
Inside of boot2docker:
```
curl -o /tmp/docker https://s3-eu-west-1.amazonaws.com/sequenceiq/builds/linux/amd64/docker-1.0.1-dev
```

## OSX
On my macbook:
```
curl -o /tmp/docker https://s3-eu-west-1.amazonaws.com/sequenceiq/builds/darwin/amd64/docker-1.0.1-dev
```

# Build an upload to s3

The process below builds the latest binaries (linux/darwin) and uploads them to
the `s3://sequencei3` bucket.

```
git clone git@github.com:lalyos/docker.git docker_hack
cd docker_hack
./deploy-dev.sh
```
