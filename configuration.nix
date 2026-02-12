# NixOS configuration for clawmachine

{ config, lib, pkgs, ... }:

let
  euankKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMdxqFTG7bPey17ZWg6LbonqASSNJnlmdMg3yiYPuNu6/b4Ffe4iycGAwVl/ODKnEzLZ2aWUhiVrLMv4Z6vml3/l/qU3PPeQRe+TY0afXLbT05xDG2HS/y5SE/6qoynKb2FzJ8YCpI3xdoJ3E4L5+a5vZ1yjknaFcHcL0/g5GCsKo0QpO6dH9Tz+W36Ua/kGXmqMzDaOraXLvTc2TBJ4Mm/CRy6zL773V4GE5e+w4MxdYGpaGZ2EaKw37xFAyx2lH2/RbRt+qTsvGOjfhXuMyOEtsrDEkM7mbRdjuC8WzlutTrDESRJuVAu47HEZjMKCaQ05wgI/LYS3CeolorGDf9tahnjS5s0x7X+NIRkEA0qgpxUwr5T9Z7JKWIIOV90Rbu6CFEfhldNtfA5uD8RLufIiiQTsTZmHjHaPWi98iphb+wMpy8yB4lPPzoWfSuofPVcWaLFoFzGwKkP38XLyeKXEyUgGJPTLPLkGNjQgTBqZlOTL06UR8GNKPtWo5dMCvsFuz0+u34LaeyNg+2i7gvhWZakDZ1EAqWdtj6A+8oAlIEa04OR09xlfdjA9BMA4xGyq9sOKn99tV5qTIZl3X+MIxxPUm0TYXulM4kByeKROAvQhgwSUJAE63qVddBnl+PAsUZPREl8l/ccuytZIlnDn2RY0LlIXGYb0tIEykSqw=="
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCyFcdo10FvG1lxiUKjccK2agmIIm13w0XmtftjI36q+7tg6ULrbFRdk/XITucTfSet/0y9Kup8QJM00i8k9EGD5SGcULhDX6p/mc0YTI1DeOHauAU3y7hlsE0a13sm5kg7XZ1dDqb5nY+8I6ZjHc5FlbjatAKHOSosljjIeOSvgg/tKJGf8qna4pzlgfhN4bf8jbK4ZJ6JoTVD9ulQqKKcwLdJFIxxKR4VxXVxGHiH8dvP3oPzhQ6W9GAc0yfBl8kIxJdzvEd5h7vX9b93ZFWolkkZYpyxbvapeeLmNX4e5TexWPUU1kT7jIi/rvTrSow5iYGu5rgwgqy6Ey37jhpQKQUgwkLPH1mt/9vg4WlpbPEk0TihDmW0yJ8CwHetZAs4cjSbiuMGopBf2rCEIrjyflKIiy/Of7MVp3NVEPVDOu3VEH/khxrHR5KC9XKOg4jhcsQBj0t+i1iJCmi981sXzXLHmmXZMNlcf0jFSG4TwApyc1+hJIBladsSZ12mLY1lFCTx/Yx3ztoNPqGPLAkNYuj3z50jL/Jdj2oVNcQqNpxb6bHmW416LcuUGQ9DSIJUJLxmv/CXW5Wpepm30KTumJSy6G6bBCe4b+Gw2g74K6uwjEaX2uGXNJvRNE+ftDf23fy1orO3HLncY23Du/R6iDcMj/coMMlkAES1AdxEFw=="
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHZieKHSGXJWFqI7+lAS/DW7DsRRD0PnsdDEFBliMlkzonvQABgIdz+5Q8eQUv1cpfb/s9EcltO2d+i7S5BesafkBXPBXg4XAGp3lNqPN0TuLZyPwSwCCazi3zGs2VgnLrUVDX3RmDqBbxfJaU5x6Y1lurwBGbSpsAL7SQ1+PnVXk9Shvrk0lAJtbpQcn5JluCk/9Go0HUVHvwL2WjaRKEnTp8L+v7FUdoOtfnVpdV3Z08/0rK8A0rHTSB78YWMrBehzUEN0cweXJu4yOUQKWrep4gKM19cDZd/dLqvlK+tBoZKcPvT2MkBLv3NYDFVAsZWdLQURGqI/WczQa37NHj"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyeivCOXMLvMzKvZjPzNSqD8kvkbsI/Ecdxe7V7HZDG8AfliS68frOZI5pl0uqfBet80e5qH/njDvdfKpKuBiAgUZcBz1+LGdrCr+Tn8Bi0ypu+xSpjJjPT0fVgD9qk0lv5TnUmqZD/BZShQjlp6T0MfETSbGppTxRRZIS2CgjO230fktZST8GUJBX/G0HVupqVdbORVdBkbEx4XfJLrmI3HSuA2drlImhCegrByg8r6k2Q/256myWri8Q2X0bVIg93FqcuLGvngGL8kJinwo/zRPo5ucfH0DWsQWtHo6ayx2FycMsCmd56ZU+FH9PBy73ki4ACqsaGh+T8silAR5R"
  ];
in
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "clawmachine";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tokyo";

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.openssh.enable = true;

  # Stay always-on: disable suspend/hibernate/sleep actions.
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  services.logind.settings.Login = {
    IdleAction = "ignore";
    HandleSuspendKey = "ignore";
    HandleHibernateKey = "ignore";
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # Ensure initrd has NIC drivers so SSH unlock works.
  boot.initrd.availableKernelModules = lib.mkAfter [ "r8169" "mt7925e" ];
  boot.initrd.kernelModules = [ "r8169" "mt7925e" ];

  boot.initrd.network = {
    enable = true;
    udhcpc.enable = true;
    ssh = {
      enable = true;
      authorizedKeys = euankKeys;
      hostKeys = [ "/etc/ssh/initrd_ed25519_key" ];
    };
  };

  users.users.claw = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = euankKeys;
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    codex
    nodejs_22
    cmake
    gcc
    gnumake
    pkg-config
    git
    gh
    firefox
    chromium
    xdg-utils
    sops
    age
  ];

  sops = {
    defaultSopsFile = ./secrets/openclaw.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/claw/.config/sops/age/keys.txt";

    secrets.discord_bot_token = {
      owner = "claw";
      group = "users";
      mode = "0400";
    };

    templates."openclaw-gateway.env" = {
      owner = "claw";
      group = "users";
      mode = "0400";
      content = ''
        DISCORD_BOT_TOKEN=${config.sops.placeholder.discord_bot_token}
      '';
    };
  };

  systemd.user.services.openclaw-gateway = {
    overrideStrategy = "asDropin";
    serviceConfig.EnvironmentFile = [ config.sops.templates."openclaw-gateway.env".path ];
    restartTriggers = [ config.sops.templates."openclaw-gateway.env".file ];
  };

  environment.sessionVariables = {
    NPM_CONFIG_PREFIX = "/home/claw/.npm-global";
  };

  environment.shellInit = ''
    export PATH="/home/claw/.npm-global/bin:$PATH"
  '';

  system.stateVersion = "25.11";
}
