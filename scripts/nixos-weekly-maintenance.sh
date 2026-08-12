#!/usr/bin/env bash
set -Eeuo pipefail

REPO=/home/claw/nixos-flake
STATE_DIR=/home/claw/.local/share/hermes-agent/maintenance
LOG="$STATE_DIR/nixos-weekly-maintenance.log"
STATUS="$STATE_DIR/nixos-weekly-maintenance.status"
GIT=/run/current-system/sw/bin/git
NIX=/run/current-system/sw/bin/nix
SUDO=/run/wrappers/bin/sudo
REBUILD=/run/current-system/sw/bin/nixos-rebuild
RM=/run/current-system/sw/bin/rm
DATE=/run/current-system/sw/bin/date
MKDIR=/run/current-system/sw/bin/mkdir
FLOCK=/run/current-system/sw/bin/flock

# Nix itself shells out to git while updating/evaluating Git flakes. Keep a
# deterministic PATH even in transient or timer services with a minimal env.
export PATH="/run/current-system/sw/bin:/run/wrappers/bin"

$MKDIR -p "$STATE_DIR"
exec 9>"$STATE_DIR/nixos-weekly-maintenance.lock"
if ! $FLOCK -n 9; then
  printf 'Another NixOS maintenance run is already active.\n' >&2
  exit 75
fi

exec > >(/run/current-system/sw/bin/tee -a "$LOG") 2>&1
started="$($DATE --iso-8601=seconds)"
printf 'RUNNING started=%s\n' "$started" > "$STATUS"
printf '\n=== Weekly NixOS maintenance: %s ===\n' "$started"

finish() {
  rc=$?
  finished="$($DATE --iso-8601=seconds)"
  if (( rc == 0 )); then
    printf 'SUCCESS finished=%s\n' "$finished" > "$STATUS"
    printf 'Maintenance completed successfully at %s\n' "$finished"
  else
    printf 'FAILED exit=%s finished=%s\n' "$rc" "$finished" > "$STATUS"
    printf 'Maintenance failed with exit %s at %s\n' "$rc" "$finished" >&2
  fi
}
trap finish EXIT

cd "$REPO"

# Remove only the known build-result symlink/artifact.
if [[ -L result || -e result ]]; then
  $RM -rf -- result
fi

mapfile -t dirty < <($GIT status --porcelain)
for entry in "${dirty[@]}"; do
  [[ -z "$entry" ]] && continue
  path=${entry:3}
  if [[ "$path" != "flake.lock" ]]; then
    printf 'Refusing maintenance because of unrelated local change: %s\n' "$entry" >&2
    exit 65
  fi
done

$NIX --extra-experimental-features 'nix-command flakes' flake update
$NIX --extra-experimental-features 'nix-command flakes' flake check
$NIX --extra-experimental-features 'nix-command flakes' build \
  .#nixosConfigurations.clawmachine.config.system.build.toplevel \
  --no-link --print-out-paths

# This script must be launched in an independent systemd service, not as a
# child of hermes-agent.service. Activation restarts Hermes; an independent
# cgroup lets this process survive and finish the switch, commit, and push.
case "$(< /proc/$$/cgroup)" in
  *hermes-agent.service*)
    printf 'Refusing an in-cgroup switch; launch this script with systemd-run.\n' >&2
    exit 66
    ;;
esac

$SUDO -n "$REBUILD" switch --flake "$REPO#clawmachine"

if ! $GIT diff --quiet -- flake.lock; then
  $GIT add flake.lock
  $GIT commit -m 'Weekly flake update'
fi

# Push any successful local maintenance commits, including a prior interrupted
# run that was validated and switched before this invocation.
if [[ "$($GIT rev-list --count origin/main..main)" != 0 ]]; then
  $GIT push origin main
fi

$GIT status --short --branch
