{ config, lib, pkgs, ... }:

let
  rekey =
    # Actual keyboard config
    #
    # Add some Nordic characters to an otherwise US-Dvorak layout.
    #
    # Run at the beginning of an X Session (see below). Bundled as a script so I
    # can rerun it when I plug in a keyboard.
    #
    # Fuck me, right?
    pkgs.writeShellScriptBin "rekey"
      ''
        <<EOF cat | ${pkgs.xorg.xkbcomp}/bin/xkbcomp - $DISPLAY &>/dev/null
        xkb_keymap {
                xkb_keycodes  { include "evdev+aliases(qwerty)"	};
                xkb_types     { include "complete"	};
                xkb_compat    { include "complete"	};
                partial xkb_symbols   {
                    include "pc+us(dvorak)+inet(evdev)"
                    include "ctrl(nocaps)+compose(lctrl)+level3(ralt_switch)"

                    key <AE04> { [ NoSymbol, NoSymbol, EuroSign, sterling ] };
                    key <AD01> { [ NoSymbol, NoSymbol, aring, Aring ] };
                    key <AD11> { [ NoSymbol, NoSymbol, dead_acute ] };
                    key <AC01> { [ NoSymbol, NoSymbol, adiaeresis, Adiaeresis ] };
                    key <AC02> { [ NoSymbol, NoSymbol, odiaeresis, Odiaeresis ] };
                    key <AB01> { [ NoSymbol, NoSymbol, Greek_lambda, NoSymbol ] };
                };
                xkb_geometry  { include "pc(pc104)"	};
        };
        EOF
      '';

  # Handy tool for tracking works in progress
  bugs =
    let
      losh-t = pkgs.pythonPackages.buildPythonApplication {
        pname = "losh-t";
        version = "1.2.0";
        src = fetchGit {
          url = "https://github.com/sjl/t";
        };
      };

    in
    pkgs.writeScriptBin "b" ''
      set -Eeou pipefail
      topLevel=$(git rev-parse --git-common-dir)
      ${losh-t}/bin/t --task-dir $topLevel --list bugs $@
    '';
in
{
  #imports = [./notion-4.0.nix];
  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Don't use tmpOnTmpfs, because I actually use all that ram when compiling
    # Haskell
    tmpOnTmpfs = false;
    cleanTmpDir = true;
  };

  # 20.03
  console.useXkbConfig = true;
  # 19.09
  # i18n.consoleUseXkbConfig = true;

  # Include man section 3. >:(
  documentation.dev.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    (with pkgs.haskellPackages; [
      cabal-install
      cabal2nix
      fast-tags
      # Haskell Platform-lite
      (ghcWithPackages (p: with p; [
        QuickCheck
        containers
        lens
        megaparsec
        nonempty-containers
        placeholders
        pretty-simple
        req
        scalpel-core
        servant
        template-haskell
        text
        turtle
        ]))
      hasktags
      hlint
      hledger
      hledger-ui
      hpack
      stack
      # stylish-haskell # broken on 2020-02-21. Still broken on 2020-04-28
      (pkgs.haskell.lib.dontCheck (callPackage /home/b/Projects/usort/package.nix {}))
    ]) ++ (with pkgs; [
      # categories suck
        anki
        drive
      # personal admin tools
        bup
        keepassxc
        pass
      # development
        bugs
        cachix
        direnv
        entr
        ghcid
        git
        git-crypt
        lorri
        nix-prefetch
        nix-prefetch-docker
        nix-prefetch-github
        nix-prefetch-scripts
        ripgrep
        tmux
        universal-ctags
        vim_configurable
      # media
        aegisub
        audacity
        # beets - broken dep python3.7-soco in 20.03
        #digikam
        ghostscript
        gimp
        gitAndTools.git-annex
        graphviz
        gv
        handbrake # Rips DVD to video files
        imagemagick
        inkscape
        transmission
        vlc
        (callPackage ./terminal-image-viewer {})
      # linux
        (sox.override { enableLame = true; })
        atop
        bc
        eplot # Fast command line plotter
        fd
        file
        fzf
        gdb
        gnumake
        htop
        jq
        jre
        lshw
        manpages # OBVIOUSLY
        ncdu
        nix-bash-completions
        pandoc
        par
        python
        qdirstat
        sqlite
        sshuttle
        tree
        unzip
        yq
      # Xorg (in concert with enabling xmonad)
        arandr
        dmenu
        flameshot
        networkmanagerapplet
        notify-osd
        pavucontrol
        peek # gif casts
        rekey
        trayer
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
      # Email
        extract_url
        lmdb # Header cache for neomutt
        neomutt
        notmuch
        offlineimap
        vcal
      # social
        gnupg1compat
        keybase-gui
        mumble
        riot-desktop
        signal-desktop
        weechat
        wire-desktop
      # networking
        bind
        nethogs
        nmap
        speedometer
        tcpdump
      # devops
        awscli
        dive
        kubectl
        kubectx
        minikube
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

  fonts.fonts = [ pkgs.fira-mono pkgs.noto-fonts-emoji pkgs.noto-fonts ];
  fonts.fontconfig.defaultFonts.monospace = [ "Fira Mono" ];

  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;
    pulseaudio.enable = true;
    pulseaudio.package = pkgs.pulseaudioFull;
  };

  location = {
    # .provider = "geoclue2";
    latitude = 60.2443;
    longitude = 24.8800;
  };

  networking.networkmanager = {
    enable = true;
    packages = [
      pkgs.openconnect_pa
    ];
  };

  nix = {
    gc = {
      automatic = true;
      dates = "11:30";
      # Bumped from 2w to 4w on the 50th of March 2020 because channels were
      # moving slowly.
      options = "--delete-older-than 4w";
    };
    # Needed for various good things
    trustedUsers = ["b"];
    # Let commands use these caches if they want.
    trustedBinaryCaches = [
      "http://devdatabrary2.home.nyu.edu:5000/"
    ];
    binaryCachePublicKeys = [
      "devdatabrary2.home.nyu.edu-1:xpI1XOvf7czNv0+0/1ajpgotpOnUMTUBBF9v97D5/yk="
      "databrary.cachix.org-1:jOz34d80mzekR2pjkK9JCczPi2TKeifQ/OHYcg8I6tg="
    ];
  };

  ## Configure programs.
  programs = {
    bash.enableCompletion = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    xss-lock = {
      enable = true;
      extraOptions = [
        "--notifier=${pkgs.xsecurelock}/libexec/xsecurelock/dimmer"
        "--transfer-sleep-lock"
      ];
      lockerCommand =
        lib.concatStringsSep " " [
          "env XSECURELOCK_PASSWORD_PROMPT=disco"
          "    XSECURELOCK_BLANK_TIMEOUT=10"
          "    XSECURELOCK_BLANK_DPMS_STATE=off"
          # Need to escape the % because they get interpreted by systemd.
          "    XSECURELOCK_DATETIME_FORMAT='%%a %%d %%b %%Y, %%R %%Z, W%%V'"
          "    XSECURELOCK_SHOW_DATETIME=1"
          "${pkgs.xsecurelock}/bin/xsecurelock"
        ];
    };
  };

  services = {
    autorandr.enable = true;
    fwupd.enable = true;
    keybase.enable = true;
    kbfs.enable = true;
    localtime.enable = true;

    printing.enable = true;

    # Redshift + Geoclue
    redshift = {
        enable = true;
        brightness.night = "0.5";
        temperature = {
          day = 6500;
          night = 3500;
        };
    };

    # Allow the video group to change backlight brightness
    udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
        ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';

    unclutter-xfixes.enable = true;

    urxvtd.enable = true;

    # Enable and configure the X11 windowing system.
    xserver = {
      enable = true;
      autoRepeatDelay = 300;
      autoRepeatInterval = 10;
      libinput.enable = true;
      windowManager.notion = {
        enable = true;
      };

      ## X KEYBOARD MAP

      # Basic keyboard setup that gets reused by the console via
      # i18n.consoleUseXkbConfig.
      layout = "dvorak";
      xkbOptions = "ctrl:nocaps";

      # NixOS' support for xkeyboard-config has a high impedance mismatch.
      # See the definition for rekey above.
      displayManager.sessionCommands = "rekey";
    };
  };


  system = {
    autoUpgrade = {
      enable = true;
      dates = "12:30";
    };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraGroups.b = {
    gid = 1000;
  };
  users.users.b = {
    isNormalUser = true;
    uid = 1000;
    group = "b";
    extraGroups = ["users" "wheel" "video" "systemd-journal"];
  };
}
