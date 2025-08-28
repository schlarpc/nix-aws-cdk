# nix-aws-cdk

Automatically updated Nix flake that builds the latest version of the AWS CDK.

The AWS CDK in nixpkgs is often outdated and can lead to Cloud Assembly version
mismatches when using the latest `aws-cdk-lib`. This flake uses Dependabot
and GitHub Actions to automatically ingest updates daily.

## Usage

Add to your flake inputs:

```nix
{
  inputs.nix-aws-cdk.url = "github:schlarpc/nix-aws-cdk";

  outputs = { nix-aws-cdk, ... }: {
    # Use the CDK package
    packages.x86_64-linux.default = nix-aws-cdk.packages.x86_64-linux.aws-cdk;
  };
}
```
