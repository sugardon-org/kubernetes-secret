# kubernetes-secret

## Create dockerconfigjsonn

<https://github.com/docker/for-mac/issues/4100#issuecomment-648977556>
```bash
$ DOCKER_CONFIG=$(cat <<EOS
{
    "auths": {
        "https://index.docker.io/v1/" : {         
            "auth" : "$(echo -n user:password | base64)"
        }
    }
}
EOS
)
$ echo $DOCKER_CONFIG | base64
```
