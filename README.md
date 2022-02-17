## About The Project


(P)ersonal (H)ome (M)achines is a simple name I came up with for projects like these that requires me to setup quick, familar, work-ready machines.
You may use it as you wish - modify or get inspiration from.


`The Basic Arch Linux Install Script` i.e. `balis` is a collection of my own work and bits from everywhere else on the web.
See the Acknowledgements for more.  


<p align="right">(<a href="#top">back to top</a>)</p>


## Getting Started

`Balis` assumes that you did a `minimum of prep work` and is run only in the `chroot stage.` It is a `minimal install` with no graphical interface (CLI only).  
See **installation** for the next step.

`Balis +` is an additional script that you can use to get a complete install.
Althought not required - this is the next step to a `full desktop experience` using **my dotfiles**  
see **Usage**.


### Prerequisites

Below is an **example** of an arch install with a step-by-step guide. `Balis` assumes a `setup with UEFI.` For a more detailed guide visit **the arch wiki**.

* **Partition the disks**
   ```sh
   fdisk /dev/the_disk_to_be_partitioned
   ```
* **Format the partitions**  
   EFI :  
   ```sh
   mkfs.fat -F 32 /dev/efi_system_partition
   ```
   Swap :  
   ```sh
   mkswap /dev/swap_partition
   ```
   Root :  
   ```sh
   mkfs.ext4 /dev/root_partition
   ```

* **Mount the file systems**  
   Root :  
   ```sh
   mount /dev/root_partition /mnt
   ```
   EFI :  
   (Create dirs like `/boot/efi` if needed)  
   ```sh
   mount /dev/efi_system_partition /mnt/boot/efi
   ```
   Swap :  
   ```sh
   swapon /dev/swap_partition
   ```

* **Install essential packages (below are all of the needed packages)**  
   You can add a `text editor` such as `vim` or `nano`.
   ```sh
   pacstrap /mnt base linux linux-firmware git
   ```
* **Generate Fstab**
   ```sh
   genfstab -U /mnt >> /mnt/etc/fstab
   ```
* **Chroot**
   ```sh
   arch-chroot /mnt
   ```
   
### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/Niko7334/PHM.git
   ```
2. Make the script executable
   ```sh
   chmod +x balis.sh
   ```
3. Run the script
   ```sh
   ./balis.sh
   ```
4. Make the additional script executable
   ```sh
   chmod +x balis-plus.sh
   ```
5. Run the additional script
   ```sh
   ./balis-plus.sh
   ```

<p align="right">(<a href="#top">back to top</a>)</p>


## Usage

The process is pretty straight forward but I do recommend to check the scripts before executing. Althought it is designed to handle most things like drivers by itself, your **grub path** may need to be specified if your `UEFI mount point` is something other than `/mnt/boot/efi.`  

If you wish to customize packages do it in `pkgs.txt` and `pkgs-plus.txt` for `balis.sh` and `balis-plus.sh` respectivly.

`Fonts` are specified in `fonts.txt`.  

When run, `balis.sh` will create `a custom keymap` that `swaps CAPSLOCK with ESC` to disable this behavior add `--nokeymap` to the script.
```sh
./balis.sh --nokeymap
```
**A brief look at what you get in no particular order:**  
- Optimal downloads (Mirrors)
- More time for your cats \*  
- Firewall setup
- Configuring printers & drivers for most of them
- Graphic drivers (AMD, Nvdia)
- Bluetooth
- Microcodes (AMD, Intel)
- Audio setup (Alsa, Pulseaudio)  
  
  
\* *cats not included*

### A look into Balis +  

[Image showing a Terminal window]()

[Image showing Desktop]()

* **GUI setup**
   - bspwm ( WM )
   - picom
   - polybar
   - dmenu
   - base-devel
   - nitrogen 
   - Alacritty ( Terminal emulator )
   - xorg
   - xinit
   - sxhkd ( Simple X HotKey Daemon )

* **Terminal utilities:**  
   - lf ( File Manager )
   - Yay ( AUR helper )
   - tldr
   - tmux & tmux-bash-completion ( multiplexer )
   - w3m ( Text-based browser )
   - exa ( ls replacement )
   - calc

* **Dev stuff**
   - Python
   - jdk
   - ctags
   - Jupyter-notebook

* **Applications**
   - Firefox ( Web browser )
   - Gimp
   - Inkscape
   - Obsidian ( Markdown Knowledge base )
   - Libre Office
   - zathura + kernel ( document viewer )
   - Spotify
   - fontforge
   - solaar ( for logitech mice )
   - vlc ( video player )
   - obs-studio

* **Terminal fun**
   - cmatrix
   - tty-clock
   - neofetch
   - Spotify-tui (spt)
   - Spotifyd
   - mkinitcpio-colors-git ( tty colors )



_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#top">back to top</a>)</p>


## License

Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>

## Contact

Nikolay Bushilo - bushilo.nikolay1@gmail.com

Project Link: [https://github.com/github_username/repo_name](https://github.com/github_username/repo_name)

<p align="right">(<a href="#top">back to top</a>)</p>


## Acknowledgments

* []()
* []()
* []()

<p align="right">(<a href="#top">back to top</a>)</p>
