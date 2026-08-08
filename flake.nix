{
  description = "NixOS configuration for clawmachine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    ankiweb-cli.url = "github:euank-ai/ankiweb-cli";
    ankiweb-cli.inputs.nixpkgs.follows = "nixpkgs";
    hermes-agent.url = "github:NousResearch/hermes-agent";
  };

  outputs = { self, nixpkgs, sops-nix, ankiweb-cli, hermes-agent }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.clawmachine = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hardware-configuration.nix
          sops-nix.nixosModules.sops
          hermes-agent.nixosModules.default
          ./configuration.nix
          {
            environment.systemPackages = [
              ankiweb-cli.packages.${system}.default
              nixpkgs.legacyPackages.${system}.oath-toolkit
            ];
          }
        ];
      };
    };
}
