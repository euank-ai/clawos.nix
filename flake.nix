{
  description = "NixOS configuration for clawmachine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, sops-nix }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.clawmachine = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hardware-configuration.nix
          sops-nix.nixosModules.sops
          ./configuration.nix
        ];
      };
    };
}
