<p align="center"><img src="art/banner-2x.png"></p>

My dotfiles for setting up a new macOS machine.

I opted to not use mackup, and instead I'm making use of GNU stow for symlinking config files to my dotfiles.

I recommend forking this repository to track and save your personal dotfiles configuration.

## `stow` usage

`stow` is used to easily get you up and running by symlinking all subfolders based on their folder structure relative to `$HOME` (by default `~/`).

An example with `ghostty`. ghostty reads user config from `$XDG_CONFIG_HOME/ghostty/config` (or `~/.config/ghostty/config`). Stow accepts a `--target` option that specifies a directory as the base (in our case, and by default, its `$HOME` or `~/`). It then symlinks, following the directory structure we specify.

Therefore, our `ghostty` directory structure is the following:

```
ghostty
└── .config
    └── ghostty
        └── config
```

which when running `stow` symlinks into `~/.config/ghostty/config`.

This is the same with e.g. the `git` module, where we have our `.gitconfig` - since we want it to be present in our home directory `~/.gitconfig`, we don't need any specific subfolder structure - its all relative to `~/`.

The upside here is you have a single source of truth for all your configuration in this folder, which is also tracked via git. Any changes can be made here, e.g. adding an alias to your `.zshrc` or maybe changing your `ghostty` config, and they will be reflected automatically due to the symlinking. Plus you can push them to your own github repo.

This allows for instantly setting up all your config with a single command - it can be found in [fresh.sh](./fresh.sh)

##### adding new packages to stow

If you want to add your own packages to `stow` you can do so as such:

If the file you want to symlink already exists in its final destination - you can either back it up, e.g. `mv <original> <original>.bak`, then add the required folder structure and run `stow ~ <package>` OR you can `adopt` the original file by using the `--adopt` flag with stow. [Here's](https://stackoverflow.com/a/76414466) a good example from SO, make sure to read the docs for `--adopt` first

I recommend doing a dry run first for whatever you're doing with `stow -vt <command>`.

I have a helper script in [zshrc](./zsh/.zshrc) called `stowify`, which attempts to adopt a package in `~/.config/<package>` by creating the respective folder in `~/.dotfiles/<package>`, copy files over, and then executes a dry run to show the changes.

## Personal and Work separation

Since this is meant to be a dev/work machine setup, the `git/` and `ssh/` folders are specific to my use case - they include a global `.gitignore`, as well as separate configurations for personal and work git/ssh setups.

The [.github-personal](./git/.github-personal) file will be loaded only in specific folders, which are setup in [.gitconfig](./git/.gitconfig) - this allows for using your private GH profile and any other git configuration for these dotfiles, as well as any personal projects. By default it's loaded for `~/.dotfiles` and `~/personal/`, you can change that easily in the `.gitconfig` above.

Similarly, the ssh config in [github-personal.conf](./ssh/ssh/config.d/github-personal.conf) includes a 1password oriented config you can reference and plug in to your main `~/.ssh/config`, allowing you to use 1password stored SSH keys for your personal repositories - more info on how to do that is in that file itself. The reason for this simple - I already had my ssh keys setup "manually" for work, but wanted a clear separation for my personal keys. Therefore IdentityFile loading (ssh key files) are used for work, while 1password keys are for personal use.

Additionally, you can use a `zsh/zshrc.private` file for private or sensitive info - that is git ignored by default and is sourced from within our `.zshrc` automatically! Check out the example at [zsh/.zshrc.private.example](./zsh/.zshrc.private.example)

## Additional info and Customization

[.macos](./.macos) includes MacOS specific configuration for system wide properties, such as key repeat rate, locale, wake on lid open, disabling certain animations and so on. You can read up a bit more here [Kevin Suttle's macOS Defaults project](https://github.com/kevinSuttle/MacOS-Defaults).

[.clone.sh](./clone.sh) contains any additional repositories to be cloned durign the installation process - for example, I use it to install [LazyVim](https://www.lazyvim.org/).

For more info and specifics, I recommend reading the original README below .

## Install

The install process is pretty straightforward and is mostly orchestrated through `fresh.sh`.

It will install everything in `Brewfile` as well as setup symlinks via stow, respecting the `.stow-local-ignore`.

1. Clone this repo to `~/.dotfiles` with:

    ```zsh
    git clone --recursive git@github.com:scyhhe/dotfiles.git ~/.dotfiles
    ```

2. Customize the setup to your needs, such as adding your packages to [Brewfile](./Brewfile).
3. Run the installation with:

    ```zsh
    cd ~/.dotfiles && ./fresh.sh
    ```

4. ???
5. Profit

Original README from [driesvints/dotfiles](https://github.com/driesvints/dotfiles) below - worth a read if you want to use mackup or want a deeper dive into customizing your dotfiles.

<blockquote>

## Introduction

This repository serves as my way to help me setup and maintain my Mac. It takes the effort out of installing everything manually. Everything needed to install my preferred setup of macOS is detailed in this readme. Feel free to explore, learn and copy parts for your own dotfiles. Enjoy!

📖 - [Read the blog post](https://driesvints.com/blog/getting-started-with-dotfiles)  
📺 - [Watch the screencast on Laracasts](https://laracasts.com/series/guest-spotlight/episodes/1)  
💡 - [Learn how to build your own dotfiles](https://github.com/driesvints/dotfiles#your-own-dotfiles)

If you find this repo useful, [consider sponsoring me](https://github.com/sponsors/driesvints) (a little bit)! ❤️

## A Fresh macOS Setup

These instructions are for setting up new Mac devices. Instead, if you want to get started building your own dotfiles, you can [find those instructions below](#your-own-dotfiles).

### Backup your data

If you're migrating from an existing Mac, you should first make sure to backup all of your existing data. Go through the checklist below to make sure you didn't forget anything before you migrate.

- Did you commit and push any changes/branches to your git repositories?
- Did you remember to save all important documents from non-iCloud directories?
- Did you save all of your work from apps which aren't synced through iCloud?
- Did you remember to export important data from your local database?
- Did you update [mackup](https://github.com/lra/mackup) to the latest version and ran `mackup backup`?

### Setting up your Mac

After backing up your old Mac you may now follow these install instructions to setup a new one.

1. Update macOS to the latest version through system preferences
2. Setup an SSH key by using one of the two following methods  
   2.1. If you use 1Password, install it with the 1Password [SSH agent](https://developer.1password.com/docs/ssh/get-started/#step-3-turn-on-the-1password-ssh-agent) and sync your SSH keys locally.  
   2.2. Otherwise [generate a new public and private SSH key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) by running:

   ```zsh
   curl https://raw.githubusercontent.com/driesvints/dotfiles/HEAD/ssh.sh | sh -s "<your-email-address>"
   ```

3. Clone this repo to `~/.dotfiles` with:

    ```zsh
    git clone --recursive git@github.com:driesvints/dotfiles.git ~/.dotfiles
    ```

4. Run the installation with:

    ```zsh
    cd ~/.dotfiles && ./fresh.sh
    ```

5. Start `Herd.app` and run its install process
6. After mackup is synced with your cloud storage, restore preferences by running `mackup restore`
7. Restart your computer to finalize the process

Your Mac is now ready to use!

> 💡 You can use a different location than `~/.dotfiles` if you want. Make sure you also update the references in the [`.zshrc`](./.zshrc#L2) and [`fresh.sh`](./fresh.sh#L20) files.

### Cleaning your old Mac (optionally)

After you've set up your new Mac you may want to wipe and clean install your old Mac. Follow [this article](https://support.apple.com/guide/mac-help/erase-and-reinstall-macos-mh27903/mac) to do that. Remember to [backup your data](#backup-your-data) first!

## Your Own Dotfiles

**Please note that the instructions below assume you already have set up Oh My Zsh so make sure to first [install Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh#getting-started) before you continue.**

If you want to start with your own dotfiles from this setup, it's pretty easy to do so. First of all you'll need to fork this repo. After that you can tweak it the way you want.

Go through the [`.macos`](./.macos) file and adjust the settings to your liking. You can find much more settings at [the original script by Mathias Bynens](https://github.com/mathiasbynens/dotfiles/blob/master/.macos) and [Kevin Suttle's macOS Defaults project](https://github.com/kevinSuttle/MacOS-Defaults).

Check out the [`Brewfile`](./Brewfile) file and adjust the apps you want to install for your machine. Use [their search page](https://formulae.brew.sh/cask/) to check if the app you want to install is available.

Check out the [`aliases.zsh`](./aliases.zsh) file and add your own aliases. If you need to tweak your `$PATH` check out the [`path.zsh`](./path.zsh) file. These files get loaded in because the `$ZSH_CUSTOM` setting points to the `.dotfiles` directory. You can adjust the [`.zshrc`](./.zshrc) file to your liking to tweak your Oh My Zsh setup. More info about how to customize Oh My Zsh can be found [here](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization).

When installing these dotfiles for the first time you'll need to backup all of your settings with Mackup. Install Mackup and backup your settings with the commands below. Your settings will be synced to iCloud so you can use them to sync between computers and reinstall them when reinstalling your Mac. If you want to save your settings to a different directory or different storage than iCloud, [checkout the documentation](https://github.com/lra/mackup/blob/master/doc/README.md#storage). Also make sure your `.zshrc` file is symlinked from your dotfiles repo to your home directory.

```zsh
brew install mackup
mackup backup
```

You can tweak the shell theme, the Oh My Zsh settings and much more. Go through the files in this repo and tweak everything to your liking.

Enjoy your own Dotfiles!

## Thanks To

I first got the idea for starting this project by visiting the [GitHub does dotfiles](https://dotfiles.github.io/) project. Both [Zach Holman](https://github.com/holman/dotfiles) and [Mathias Bynens](https://github.com/mathiasbynens/dotfiles) were great sources of inspiration. [Sourabh Bajaj](https://twitter.com/sb2nov/)'s [Mac OS X Setup Guide](http://sourabhbajaj.com/mac-setup/) proved to be invaluable. Thanks to [@subnixr](https://github.com/subnixr) for [his awesome Zsh theme](https://github.com/subnixr/minimal)! Thanks to [Caneco](https://twitter.com/caneco) for the header in this readme. And lastly, I'd like to thank [Emma Fabre](https://twitter.com/anahkiasen) for [her excellent presentation on Homebrew](https://speakerdeck.com/anahkiasen/a-storm-homebrewin) which made me migrate a lot to a [`Brewfile`](./Brewfile) and [Mackup](https://github.com/lra/mackup).

In general, I'd like to thank every single one who open-sources their dotfiles for their effort to contribute something to the open-source community.

</blockquote>
