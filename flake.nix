{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      ...
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = self.packages.${system}.aws-cdk;
          aws-cdk = pkgs.buildNpmPackage {
            pname = "aws-cdk";
            version =
              (builtins.fromJSON (builtins.readFile ./package-lock.json)).packages."node_modules/aws-cdk".version;
            src = self;
            npmDeps = pkgs.importNpmLock { npmRoot = self; };
            npmConfigHook = pkgs.importNpmLock.npmConfigHook;
            dontNpmBuild = true;
            NPM_CONFIG_PACKAGE_LOCK_ONLY = "false";
            meta.mainProgram = "cdk";
          };
        }
      );
    };
}
