{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.callPackage (
          { buildNpmPackage, importNpmLock }:
          buildNpmPackage {
            pname = "aws-cdk";
            version =
              (builtins.fromJSON (builtins.readFile ./package-lock.json)).packages."node_modules/aws-cdk".version;
            src = self;
            npmDeps = importNpmLock { npmRoot = self; };
            npmConfigHook = importNpmLock.npmConfigHook;
            dontNpmBuild = true;
            NPM_CONFIG_PACKAGE_LOCK_ONLY = "false";
            meta.mainProgram = "cdk";
          }
        ) { };
      }
    );
}
