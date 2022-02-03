{ pkgs, config, lib, ... }: {

  imports = [ ./hwCfg.nix ];

  modules.hardware = {
    pipewire.enable = true;
    bluetooth.enable = true;
    touchpad.enable = true;
    openrazer.enable = true;
  };

  modules.networking = {
    enable = true;
    networkManager.enable = true;

    wireGuard = {
      enable = true;
      akkadianVPN.enable = true;
    };
  };

  modules.desktop = {
    envDisplay.sddm.enable = true;
    envManager.xmonad.enable = true;

    inputMF = {
      fcitx5.enable = true;
      spellCheck.enable = true;
    };

    envExtra = {
      gtk.enable = true;
      rofi.enable = true;
      dunst.enable = true;

      picom.enable = true;
      taffybar.enable = true;
      customLayout.enable = true;
    };

    envScript = {
      volume.enable = true;
      battery.enable = true;
      brightness.enable = true;
      microphone.enable = true;
      screenshot.enable = true;
    };
  };

  modules.themes = { active = "catppuccin"; };

  modules.fonts = {
    minimal.enable = true;
    nerdFonts.enable = true;

    settings = {
      family = "VictorMono Nerd Font";
      monospace = "VictorMono Nerd Font Mono";
      style = "SemiBold";
      size = 13;
    };
  };

  modules.appliances = {
    termEmu = {
      default = "alacritty";
      alacritty.enable = true;
    };

    termUI = {
      htop.enable = true;
      neofetch.enable = true;
      printTermColor.enable = true;
    };

    editors = {
      default = "emacs";
      emacs.enable = true;
      neovim.enable = true;
    };

    browsers = {
      default = "firefox";
      firefox.enable = true;
      unGoogled.enable = true;
    };

    extras = {
      docViewer.enable = true;
      transmission.enable = true;

      chat = {
        enable = true;
        mobile.enable = true;
      };
    };

    media = {
      mpv.enable = true;
      spotify.enable = true;
      graphics.enable = true;
    };

    philomath.aula = {
      anki.enable = true;
      # libre.enable = true;
      # zoom.enable = true;
    };
  };

  modules.develop = {
    python.enable = true;
    haskell.enable = true;
    rust.enable = true;
  };

  modules.containers.transmission = {
    enable = false; # TODO: Once fixed -> enable = true;
    username = "alonzo";
    password = builtins.readFile config.age.secrets.torBylon.path;
  };

  modules.services = {
    # ssh.enable = true;
    kdeconnect.enable = true;
    laptop.enable = true;
  };

  modules.shell = {
    git.enable = true;
    fish.enable = true;
    tmux.enable = true;
    gnupg.enable = true;
    direnv.enable = true;
  };

  boot.kernel.sysctl."abi.vsyscall32" = 0; # League of Legends..
  boot.kernelParams = [ "acpi_backlight=native" ];

  # Hide HW-Devices from Nautilus:
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    options = [ "noatime, x-gvfs-hide" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/home";
    fsType = "ext4";
    options = [ "noatime, x-gvfs-hide" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [ "x-gvfs-hide" ];
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    opengl.extraPackages =
      [ pkgs.amdvlk pkgs.driversi686Linux.amdvlk pkgs.rocm-opencl-icd ];
  };

  systemd.services.systemd-udev-settle.enable = false;

  services = {
    avahi.enable = false;
    gvfs.enable = true;
  };

  services.xserver = {
    videoDrivers = [ "amdgpu" ];
    deviceSection = ''
      Option "TearFree" "true"
    '';
  };

  services.xserver.libinput = {
    touchpad.accelSpeed = "0.5";
    touchpad.accelProfile = "adaptive";
  };
}
