#!/bin/sh




MODEL=SOLAR
#MODEL=FE

for INST in 'ACIS' ; do

case $INST in

MOS) DATA=data/XMM-MOS
     RMF=$WORK/RXJ1713/XMM-obs/0502080101/phac/M1.rmf
     ARF=$WORK/RXJ1713/XMM-obs/0502080101/phac/M1.arf;;

ACIS) DATA=data/ACIS
      RMF=$WORK/Xrays/wavelet-denoise/data/CasA/4638/SNR/weight_PI_rebin3.rmf
      ARF=$WORK/Xrays/wavelet-denoise/data/CasA/4638/SNR/simple_steps.arf;;

XIFU) DATA=data/Athena-XIFU
RMF=$WORK/Athena/responses/athena_xifu_rmf_v20160401.rmf
ARF=$WORK/Athena/responses/athena_xifu_1190_onaxis_pitch249um_v20160401.arf;;

esac


case $MODEL in

SOLAR) XCM=vnei.xcm ;;
FE)    XCM=vnei-Fe-only.xcm ;;

esac

exposure=100000
#exposure=`perl -e "print ${texp}*1000."`

for nh in 0.5 1.0 1.5 2.0 ; do

  for kT in 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0; do

    for tau in 1e8 1e9 1e10 1e11 1e12 1e13; do


OUTFILE=$DATA/xspec_nei_${MODEL}_nh${nh}_kT${kT}_tau${tau}.dat

xspec << EOF

  method leven 10000 0.0001
  abund wilm
  xsect bcmc
  cosmo 70 0 0.73
  xset delta -1
  xset NEIVERS  3.0
  systematic 0

  setplot energy

  @$XCM

  newpar 1 $nh
  newpar 2 $kT
  newpar 16 $tau


  fakeit nowrite none
  $RMF
  $ARF
  y

  toto.fak
  $exposure, 1.0, 1.0


  iplot
  WData $OUTFILE

  exit
  exit

EOF
    cut -d " " -f 1 -f 5 $OUTFILE > temp.dat
    mv temp.dat $OUTFILE
    gzip $OUTFILE


    done
  done
 done

done
