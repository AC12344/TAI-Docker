# Docker image for TAI course

## Update submodules
```bash
git submodule uodate --init --recursive
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

