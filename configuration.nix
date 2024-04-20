{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable Flakes feature
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Enable SDDM, which requires xserver
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      theme = "where_is_my_sddm_theme";
    };
  };

  # Enable and configure Hyprland with hints for electron apps
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  
  # Add this otherwise swaylock won't unlock...
  security.pam.services.swaylock = {};
  
  # Hostname
  networking.hostName = "tetrodotoxin";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    layout = "be";
    xkbVariant = "";
  };
 
  # Configure console keymap
  console.keyMap = "be-latin1";

  # Enable sound with pipewire
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # User account
  users.users.adriaan = {
    isNormalUser = true;
    description = "Adriaan Brumsen";
    extraGroups = [ "networkmanager" "wheel" "wireshark" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = [ "JetBrainsMono" ]; })
  ];

  # Environment variables
  environment.variables = {
    EDITOR = "nvim";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    (where-is-my-sddm-theme.override {
      themeConfig.General = {
        background = toString ./wallpaper.jpg;
        backgroundMode = "fill";
      };
    })
    mako
    libnotify
    swww
    networkmanagerapplet
    brightnessctl
  ];
  
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  # Services
  services.tlp = {
    enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
