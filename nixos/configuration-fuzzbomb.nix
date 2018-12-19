{ config, pkgs, ... }:

{
  networking.hostName = "fuzzbomb";
  system.stateVersion = "17.03";

  imports =
    [ /etc/nixos/hardware-configuration.nix
      /etc/nixos/system-common.nix
    ];

  # LUKS is where root and swap hide.
  boot.initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/a201e00a-e97b-4539-bc9b-462bba2570c6";
}