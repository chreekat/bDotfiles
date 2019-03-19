{ config, lib, pkgs, ... }:

{
  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Use tmpfs tmp
    tmpOnTmpfs = true;
    cleanTmpDir = true;
  };

  # Include man section 3. >:(
  documentation.dev.enable = true;

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
        drive
        syncthing-cli
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
        manpages # OBVIOUSLY
        ncdu
        nix-bash-completions
        nmap
        openssl
        pandoc
        par
        perlPackages.vidir
        python
        qdirstat
        sqlite
        sshuttle
        tree
        unzip
        # yq # Missing from 17.09
      # Xorg (in concert with enabling xmonad)
        dmenu
        flameshot
        pavucontrol
        rxvt_unicode
        xcape
        xclip
        xorg.xev
        xorg.xmessage
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
        wire-desktop
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

  fonts.fonts = [ pkgs.fira-mono pkgs.fira-code pkgs.open-dyslexic ];
  fonts.fontconfig.defaultFonts.monospace = [ "Fira Mono" ];

  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  i18n.consoleUseXkbConfig = true;

  networking.networkmanager.enable = true;

  # Let commands use these caches if they want.
  nix.trustedBinaryCaches = [
    "http://devdatabrary2.home.nyu.edu:5000/"
  ];
  nix.binaryCachePublicKeys = [
    "devdatabrary2.home.nyu.edu-1:xpI1XOvf7czNv0+0/1ajpgotpOnUMTUBBF9v97D5/yk="
    "databrary.cachix.org-1:jOz34d80mzekR2pjkK9JCczPi2TKeifQ/OHYcg8I6tg="
  ];

  ## Configure programs.
  programs = {
    bash.enableCompletion = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    xss-lock = {
      enable = true;
      lockerCommand =
        lib.concatStringsSep " " [
          "--notifier=${pkgs.xsecurelock}/libexec/xsecurelock/dimmer"
          "--transfer-sleep-lock --"
          "env XSECURELOCK_BLANK_TIMEOUT=5 ${pkgs.xsecurelock}/bin/xsecurelock"
        ];
    };
  };

  services = {
    keybase.enable = true;
    kbfs.enable = true;

    printing.enable = true;

    # Redshift + Geoclue
    redshift = {
        enable = true;
        #provider = "geoclue2"; # Broken for now
        latitude = "60.2443";
        longitude = "24.8800";
    };

    syncthing.enable = true;

    # Allow the video group to change backlight brightness
    udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
        ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';

    urxvtd.enable = true;

    # Enable the X11 windowing system.
    xserver = {
        enable = true;
        layout = "dvorak";
        xkbOptions = "eurosign:e";
        libinput.enable = true;
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
    };
  };

  time.timeZone = "Europe/Helsinki";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraGroups.b = {
    gid = 1000;
  };
  users.users.b = {
    isNormalUser = true;
    uid = 1000;
    group = "b";
    extraGroups = ["users" "wheel" "video"];
  };
}
