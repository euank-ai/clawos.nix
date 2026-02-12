# clawos.nix

NixOS flake configuration for `clawmachine`.

## What this repo contains

- `flake.nix` / `flake.lock`: flake definition and pinned inputs
- `configuration.nix`: main system configuration
- `hardware-configuration.nix`: hardware-generated config
- `secrets/openclaw.yaml`: **SOPS-encrypted** secret material
- `.sops.yaml`: SOPS creation rules (public key recipients only)

## Secrets policy

This repository is intended to be safe to push:

- No plaintext tokens/passwords should be committed.
- Runtime secrets are managed with `sops-nix` + `age`.
- Encrypted files in `secrets/` are expected in git; private keys are not.

## Apply config

```bash
sudo nixos-rebuild switch --flake .#clawmachine
```

## Notes

If you rotate a secret, re-encrypt `secrets/openclaw.yaml` with `sops` and commit the updated ciphertext.
