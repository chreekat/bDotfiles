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
        <<EOF cat | ${pkgs.xorg.xkbcomp}/bin/xkbcomp - $DISPLAY
        xkb_keymap {
                xkb_keycodes  { include "evdev+aliases(qwerty)"	};
                xkb_types     { include "complete"	};
                xkb_compat    { include "complete"	};
                xkb_symbols   {
                    include "pc+us(dvorak)+inet(evdev)"
                    include "ctrl(nocaps)+compose(lctrl)+level3(ralt_switch)"
                    include "eurosign(4)"

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
in
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
        drive
        freecad
        nethack
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
        audacity
        beets
        digikam
        ghostscript
        gimp
        gitAndTools.git-annex
        graphviz
        handbrake # Rips DVD to video files
        imagemagick
        inkscape
        ktorrent
        vlc
        transmission
        tor-browser-bundle-bin
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
        arandr
        dmenu
        flameshot
        pavucontrol
        rekey
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

  fonts.fonts = [ pkgs.fira-mono pkgs.noto-fonts-emoji pkgs.noto-fonts ];
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
        temperature = {
          day = 6500;
          night = 6000;
        };
    };

    syncthing.enable = true;

    # Allow the video group to change backlight brightness
    udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
        ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';

    urxvtd.enable = true;

    # Enable and configure the X11 windowing system.
    xserver = {
      enable = true;
      autoRepeatDelay = 300;
      autoRepeatInterval = 10;
      libinput.enable = true;
      multitouch = {
        enable = true;
        ignorePalm = true;
      };
      wacom.enable = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
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
