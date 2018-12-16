{ config, lib, pkgs, ... }:

{
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use tmpfs tmp
  boot.tmpOnTmpfs = true;
  boot.cleanTmpDir = true;

  time.timeZone = "Europe/Helsinki";

  fonts.fonts = [ pkgs.fira-mono pkgs.fira-code pkgs.open-dyslexic ];
  fonts.fontconfig.defaultFonts.monospace = [ "Fira Mono" ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    (with pkgs.haskellPackages; [
      cabal-install
      cabal2nix
      # codex ## broken in 18.03
      fast-tags
      ghc
      hasktags
      hledger
      hledger-ui
      hpack
      # hpack-convert ## BUSTED, lol?
      pandoc
      stack
      # stack2nix ## BUSTED lol
      threadscope
    ]) ++ (with pkgs; [
      # categories suck
        anki
        freecad
        nethack
        # steam ## Issues with libvulkan
      # personal admin tools
        bup
        keepassxc
        mpw
      # development
        bats
        bfg-repo-cleaner
        bench
        universal-ctags
        git
        ripgrep
        tmux
        vim_configurable
        virtualbox
        vagrant
      # media
        beets
        digikam
        ghostscript
        graphviz
        imagemagick
        gimp
        inkscape
        ktorrent
        vlc
        handbrake # Rips DVD to video files
        audacity
        gitAndTools.git-annex
      # linux
        (sox.override { enableLame = true; })
        bc
        bind
        binutils
        enscript
        fd
        file
        fzf
        gdb
        gnumake
        gparted
        gv
        html-tidy
        htop
        jq
        jre
        lshw
        moreutils # vidir and other goodies
        ncdu
        nix-bash-completions
        nmap
        openssl
        pandoc
        par
        python
        qdirstat
        sqlite
        sshuttle
        tree
        unzip
        # yq # Missing from 17.09
      # Xorg (in concert with enabling xmonad)
        rxvt_unicode
        xcape
        xclip
        xorg.xev
        xsecurelock
        xss-lock
        dmenu
      # Web
        chromium
        firefox
        w3m
        wget
        youtube-dl
      # social
        gnupg1compat
        mumble
        thunderbird
        weechat
      # devops
        awscli
        nixops
      # .deb is missing as of 2018-09-27 (for 17.09)
        # tor-browser-bundle-bin
        # skypeforlinux # .deb is missing as of 2018-09-27
        # signal-desktop # Missing from 17.09
    ]);

  # Set up the default environment
  environment.variables = {
    EDITOR = "vim";
    PARINIT = "rTbgqR B=.,?_A_a Q=_s>|";
  };

  ## Configure programs.
  programs.bash.enableCompletion = true;

  services.keybase.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;
  virtualisation.virtualbox.host.enable = true;


  # Allow the video group to change backlight brightness
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  # Redshift + Geoclue
  services.geoclue2.enable = true;
  services.redshift = {
    enable = true;
    provider = "geoclue2";
    #latitude = "40.67";
    #longitude = "-73.98";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "dvorak";
    xkbOptions = "eurosign:e";
    libinput.enable = true;
    windowManager.xmonad.enable = true;
  };

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraGroups.b = {
    gid = 1000;
  };
  users.extraUsers.b = {
    isNormalUser = true;
    uid = 1000;
    group = "b";
    extraGroups = ["users" "wheel" "vboxusers" "docker" "video"];
  };

  # Automatic updates.
  system.autoUpgrade.enable = true;

  # Let commands use these caches if they want.
  nix.trustedBinaryCaches = [
    "http://devdatabrary2.home.nyu.edu:5000/"
    "http://nixcache.devs.relexsolutions.com/"
  ];
  nix.binaryCachePublicKeys = [
    "devdatabrary2.home.nyu.edu-1:xpI1XOvf7czNv0+0/1ajpgotpOnUMTUBBF9v97D5/yk="
    "databrary.cachix.org-1:jOz34d80mzekR2pjkK9JCczPi2TKeifQ/OHYcg8I6tg="
    "nixcache.devs.relexsolutions.com-1:PRveyTUC6M1NGXo4Dg29CXsdc+KQOPPa7bRoXeLgGyI="
  ];
  nix.extraOptions = ''
    secret-key-files = /etc/nix/nix-store-key.sec
  '';
}
