# napari-clemreg-empanada

Container images for [napari](https://github.com/napari/napari) with the
[napari-clemreg](https://github.com/krentzd/napari-clemreg) and
[empanada-napari](https://github.com/volume-em/empanada-napari) plugins,
maintained by the Rosalind Franklin Institute and the Collaborative
Computational Project for Volume Electron Microscopy (CCP-volumeEM).

- User documentation for container: [rosalindfranklininstitute.github.io/volume-em-container-documentation/software/napari/](https://rosalindfranklininstitute.github.io/volume-em-container-documentation/software/napari)
- napari: [napari.org/stable](https://napari.org/stable/index.html)
- clemreg: [napari-hub.org/plugins/napari-clemreg.html](https://napari-hub.org/plugins/napari-clemreg.html)
- empanada: [empanada.readthedocs.io/en/latest](https://empanada.readthedocs.io/en/latest/index.html)


## Images

Images are published to
[quay.io/rosalindfranklininstitute/napari-clemreg-empanada](https://quay.io/repository/rosalindfranklininstitute/napari-clemreg-empanada).

| Tag | Contents |
|---|---|
| `<napari>-<clemreg>-<empanada>` | napari, clemreg and empanada versions |
| `<napari>-<clemreg>-<empanada>-vgl` | As above, plus [VirtualGL](https://virtualgl.org) |
| `latest`, `latest-vgl` | The most recent release marked latest |

## Building a new image version

The images are built and pushed by the GitHub Actions workflow
`.github/workflows/build-publish.yml`, run manually with the napari, clemreg,
empanada and (optionally) VirtualGL versions as inputs.

Currently `napari-clemreg` is limiting the version of `napari <= 0.5.0` and so `empanada`.
As dependency resolution between different versions of the plugins can be difficult and require manual changes to the Dockerfile,
it is recommend to build the main image locally first: 

```bash
docker build -t napari-clemreg-empanada --build-arg NAPARI_VERSION=... --build-arg CLEMREG_VERSION=... --build-arg EMPANADA_VERSION .
```

Once you have determined a working combination, push any changes and then manual dispatch the build-publish workflow in Actions.

### Other maintainence
Occasionally, action versions in the GitHub workflow may need updating.

### Verifying signatures

Images are signed in the build workflow using [cosign](https://docs.sigstore.dev/cosign/) keyless signing. To verify a particular `<tag>`:

```bash
cosign verify quay.io/rosalindfranklininstitute/napari-clemreg-empanada:<tag> \
  --certificate-identity "https://github.com/rosalindfranklininstitute/napari-clemreg-empanada/.github/workflows/build-publish.yml@refs/heads/main" \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```


## Licences

The files in this repository (Dockerfiles, workflow and documentation) are
licensed under an Apache-2.0 license whilst for the software components:

| Software | Licence |
|---|---|
| [napari](https://github.com/napari/napari) | BSD-3-Clause |
| [empanada-napari](https://github.com/volume-em/empanada-napari) | BSD-3-Clause |
| [napari-clemreg](https://github.com/krentzd/napari-clemreg) | MIT |
| [VirtualGL](https://virtualgl.org) (`-vgl` images only) | LGPL-2.0-or-later |

