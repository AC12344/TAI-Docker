# Docker image for TAI course

For available commands type
``` bash
make help
```

## Update submodules
```bash
git submodule update --init --recursive
```

## Quick test

``` bash
git clone https://github.com/pmanoonpong/gorobots_edu.git
make init
make enter
cp /lpzrobots/ode_robots/simulations/template_amosii/Makefile gorobots_edu/practices/amosii
cd gorobots_edu/practices/amosii
make -j4
./start
```
Window with balls should appear

## Make it usefull from anywhere
``` bash
alias tai='make -f /home/me/Git/TAI-Docker/Makefile'
```

## Clangd support
	
To have clangd support for the host editor make the tai-clangd script executable,
owned by the docker group and set the setgid bit.
``` bash
sudo chown $USER:docker tai-clangd
sudo chmod a+x,s+g tai-clangd
```

### YouCompleteMe in vim
When starting vim do
``` vimscript
:let g:ycm_clangd_binary_path='<absolute path to this dir>/tai-clangd'
:YcmRestartServer
```

