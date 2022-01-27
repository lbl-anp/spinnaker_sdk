# spinnaker_sdk

The FLIR Spinnaker SDK is hosted on Box [here](https://flir.app.boxcn.net/v/SpinnakerSDK/file/864155138818). It used to be hosted [here](https://meta.box.lenovo.com/v/link/view/a1995795ffba47dbbe45771477319cc3) and before that [here](https://flir.app.boxcn.net/v/SpinnakerSDK/folder/74729115388). This repo contains various versions of this for easy download. **Note the separate packages for `amd64` and `arm64` architectures.**

## Automatically accept EULA (for noninteractive building)

```bash
cat debconfig.dat >> /var/cache/debconf/config.dat
```
