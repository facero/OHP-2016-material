#!/bin/sh

exposure=100000
#exposure=`perl -e "print ${texp}*1000."`

for nh in 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0; do

  for kT in 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0; do
#for kT in 0.25 0.5 0.75 1.25 1.5 1.75 2; do
#   for tau in 1e8 2e8 3e8 5e8 1e9 1.2e9 1.5e9 2e9 3e9 4e9 5e9 6e9 7e9 8e9 9e9 1e10 1.2e10 1.5e10 2e10 3e10 4e10 5e10 6e10 7e10 8e10 9e10 1e11 1.2e11 1.5e11 2e11 3e11 4e11 5e11 6e11 7e11 8e11 9e11 1e12 1.2e12 1.5e12 2e12 3e12 5e12 1e13 5e13; do
    for tau in 1e8 1e9 1e10 1e11 1e12 1e13; do

xspec << EOF

  method leven 10000 0.0001
  abund wilm
  xsect bcmc
  cosmo 70 0 0.73
  xset delta -1
  xset NEIVERS  3.0
  systematic 0

  setplot energy

  model  phabs*nei
              0.5      0.001          0          0     100000      1e+06
                1       0.01     0.0808     0.0808       79.9       79.9
                1      -0.01          0          0       1000      10000
            1e+10      1e+08      1e+08      1e+08      5e+13      5e+13
                0      -0.01     -0.999     -0.999         10         10
                1       0.01          0          0      1e+20      1e+24

  newpar 1 $nh
  newpar 2 $kT
  newpar 4 $tau


  fakeit nowrite none
  /Users/facero/Documents/Work/RXJ1713/XMM-obs/0502080101/phac/M1.rmf
  /Users/facero/Documents/Work/RXJ1713/XMM-obs/0502080101/phac/M1.arf
  y

  toto.fak
  $exposure, 1.0, 1.0


  iplot
  WData data/xspec_nei_nh${nh}_kT${kT}_tau${tau}.dat

  exit
  exit

EOF

    gzip data/xspec_nei_nh${nh}_kT${kT}_tau${tau}.dat


    done
  done
done
