# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # ./hyprland.nix
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "red";
    homeDirectory = "/home/red";
  };

  # Programs
  programs = {
    # chromium
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      extensions =
      let
        createChromiumExtensionFor = browserVersion: { id, sha256, version }:
          {
            inherit id;
            crxPath = builtins.fetchurl {
              url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
              name = "${id}.crx";
              inherit sha256;
            };
            inherit version;
          };
        createChromiumExtension = createChromiumExtensionFor (lib.versions.major pkgs.ungoogled-chromium.version);
      in 
      [
        (createChromiumExtension {
          # ublock origin
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          sha256 = "sha256:1y5bcba6w97mdq0cmw75k25rw7fxnlyy4165vls7vf6xkw9aqy3z";
          version = "1.53.0";
         })
        (createChromiumExtension {
          # proton pass
          id = "ghmbeldphafepmbegfdlkpapadhbakde";
          sha256 = "sha256:1yy03kix9zi1xwnhd7v3bi8q53yhf5h0yhk1b1k53j8xymkydhwl";
          version = "1.8.4";
         })
      ];
    };
    # git
    git = {
      enable = true;
      aliases = {
        co = "checkout";
        cm = "commit";
      };
      userName = "rabedin";
      userEmail = "chromeplated@protonmail.com";
    };
    # kitty
    kitty = {
      enable = true;
      theme = "Catppuccin-Mocha";
    };
    # neovim
    neovim = {
      enable = true;
      vimAlias = true;
    };
    # zsh
    zsh = {
      enable = true;
      shellAliases = {
        updateconfig = "sudo nixos-rebuild switch --flake ~/nixos-config/#nixos";
        updatehome = "home-manager switch --flake ~/nixos-config/#red@nixos";
      };
      # histSize = 10000;
      # histFile = "${config.xdg.dataHome}/zsh/history";
      oh-my-zsh = {
        enable = true;
        plugins = [  ];
        theme = "agnoster";
      };
    };
  };

  # # Kitty
  # programs.kitty = {
  #   enable = true;
  #   theme = "Catppuccin-Mocha";
  # };
  #
  # # Neovim
  # programs.neovim = {
  #   enable = true;
  #   vimAlias = true;
  # };
  #
  # # Zsh
  # programs.zsh = {
  #   enable = true;
  #   shellAliases = {
  #     updateconfig = "sudo nixos-rebuild switch --flake ~/nixos-config/#nixos";
  #     updatehome = "home-manager switch --flake ~/nixos-config/#red@nixos";
  #   };
  #   # histSize = 10000;
  #   # histFile = "${config.xdg.dataHome}/zsh/history";
  #   oh-my-zsh = {
  #     enable = true;
  #     plugins = [  ];
  #     theme = "agnoster";
  #   };
  # };
  #
  # # Ungoogled-chromium stuff
  # programs.chromium = {
  #   enable = true;
  #   package = pkgs.ungoogled-chromium;
  #   extensions =
  #   let
  #     createChromiumExtensionFor = browserVersion: { id, sha256, version }:
  #       {
  #         inherit id;
  #         crxPath = builtins.fetchurl {
  #           url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
  #           name = "${id}.crx";
  #           inherit sha256;
  #         };
  #         inherit version;
  #       };
  #     createChromiumExtension = createChromiumExtensionFor (lib.versions.major pkgs.ungoogled-chromium.version);
  #   in 
  #   [
  #     (createChromiumExtension {
  #       # ublock origin
  #       id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
  #       sha256 = "sha256:1y5bcba6w97mdq0cmw75k25rw7fxnlyy4165vls7vf6xkw9aqy3z";
  #       version = "1.53.0";
  #      })
  #     (createChromiumExtension {
  #       # proton pass
  #       id = "ghmbeldphafepmbegfdlkpapadhbakde";
  #       sha256 = "sha256:1yy03kix9zi1xwnhd7v3bi8q53yhf5h0yhk1b1k53j8xymkydhwl";
  #       version = "1.8.4";
  #      })
  #   ];
  # };

  # Hyprland
  wayland.windowManager.hyprland.extraConfig = ''
# See https://wiki.hyprland.org/Configuring/Monitors/
monitor=,preferred,auto,auto

# See https://wiki.hyprland.org/Configuring/Keywords/ for more

# Execute your favorite apps at launch
# exec-once = waybar & hyprpaper & firefox

# Source a file (multi-file configs)
# source = ~/.config/hypr/myColors.conf

# Some default env vars.
env = XCURSOR_SIZE,24

# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1

    touchpad {
        natural_scroll = no
    }

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

general {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    gaps_in = 5
    gaps_out = 20
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)

    layout = dwindle
}

decoration {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 10
    # blur = yes
    blur {
      size = 3
      passes = 1
      new_optimizations = on
    }
    # blur_size = 3
    # blur_passes = 1
    # blur_new_optimizations = on

    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

animations {
    enabled = yes

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

dwindle {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = yes # you probably want this
}

master {
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    new_is_master = true
}

gestures {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    workspace_swipe = off
}

# Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
device:epic-mouse-v1 {
    sensitivity = -0.5
}

# See https://wiki.hyprland.org/Configuring/Keywords/ for more
$mainMod = SUPER

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mainMod SHIFT, return, exec, kitty
bind = $mainMod SHIFT, C, killactive, 
bind = $mainMod, M, exit, 
bind = $mainMod, E, exec, dolphin
bind = $mainMod, V, togglefloating, 
bind = $mainMod, R, exec, wofi --show drun
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, togglesplit, # dwindle

# Move focus with mainMod + arrow keys
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow
'';

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    wl-clipboard
    gnumake
    iosevka
    nerdfonts
    steam
    pavucontrol
    discord
    remmina
    ranger
    mako
    neofetch
    htop
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
