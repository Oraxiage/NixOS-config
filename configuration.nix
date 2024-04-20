# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
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

  # Enable and configure Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  # Otherwise swaylock won't unlock...
  security.pam.services.swaylock = {};

  networking.hostName = "tetrodotoxin"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.adriaan = {
    isNormalUser = true;
    description = "Adriaan Brumsen";
    extraGroups = [ "networkmanager" "wheel" "wireshark" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # List installed fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = [ "JetBrainsMono" ]; })
  ];

  environment.variables = {
    EDITOR = "nvim";
  };
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.tlp = {
    enable = true;
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
