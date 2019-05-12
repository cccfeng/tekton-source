#!/bin/sh
# buildkitd deamon
buildkitd --addr tcp://0.0.0.0:1234 --oci-worker-snapshotter native --debug & 
# hack for buildkitd started
sleep 3 

sc='buildctl build --exporter=image --frontend dockerfile.v0'
workspace='.'
BUILDKIT_HOST='.'
while [ -n "$1" ]; do
  case "$1" in
    --workspace)
        workspace=$2
	;;
    --buildkit_host)
        export BUILDKIT_HOST=$2
	;;
    --filename)
	sc="$sc --frontend-opt filename=$2"
	;;
    --context)
	sc="$sc --local context=$2"
	;;
    --dockerfile)
	sc="$sc --local dockerfile=$2"
	;;
    --name)
	sc="$sc --exporter-opt name=$2"
	;;
    --push)
	sc="$sc --exporter-opt push=$2"
	;;
  esac
  shift
done

cd $workspace
echo "BUILDKIT_HOST=$BUILDKIT_HOST"
echo "$sc"
$sc
