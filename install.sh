#! /bin/bash

# This file does nothing but call each step of each file in the install directory
# and checks if everything is OK
# If you want to do the process manually, the only steps important are
# 
# STEP2 : prepare the environment (files 20_*           )
# STEP3 : set compilators flags   (files 00_, 20_* and 99_    )
# STEP5 : libs setup              (files 1?_*.conf      )
# STEP7 : compile saturne         (file  19_SATURNE.conf)

#The meaning of the steps are :

#STEP0 : define machine name
#STEP1 : define what libs and what compilator collection to use
#STEP2 : setup the environment (modules, export and paths)
#STEP3 : sets compilators options
#STEP5 : libs setup
#STEP6 : patch saturne sources
#STEP7 : compile saturne
#STEP8 : patch saturne
#STEP9 : debriefing


#========================================================= Test STEP0
#======================================================= Machine name
TEST_STEP0(){ DEBUG="TEST_STEP0"
  RES="KO"
  for TEST in $LIST_MACHINE;do
    if [ "$MACHINE" = "$TEST" ]; then
      RES="OK"
    fi
  done
  if [ "$RES" = "KO" ]; then
    echo -e -n "\e[31m\e[1m**** WARNING ****\e[21m\e[0m : "
    echo "Machine $MACHINE unknown. Are you sure you want to continue (y/n)"
    read CONFIRM
    if [ ! "$CONFIRM" = "y" ]; then exit 1 ; fi
  fi
  echo
  echo "Setup of Code_Saturne_$VERSION_SATURNE on $MACHINE"
}


#========================================================= Test STEP1
#===================================== libs and compilator collection
TEST_STEP1(){ DEBUG="TEST_STEP1"
  LIST_TEST="ICC GCC"  # TEST the compilator type
  RES="KO"
  for TEST in $LIST_TEST;do
    if [ "$COMP" = "$TEST" ]; then
      RES="OK"
    fi
  done
  if [ "$RES" = "KO" ]; then STOP "Compilator $COMP unknown. Unable to continue" ;fi

  LIST_TEST="YES NO" # test openmp choice
  RES="KO"
  for TEST in $LIST_TEST;do
    if [ "$OPENMP" = "$TEST" ]; then
      RES="OK"
    fi
  done
  if [ "$RES" = "KO" ]; then STOP "OPENMP choice $OPENMP unknown. Unable to continue" ;fi

  LIST_TEST="YES NO" # test openmp choice
  RES="KO"
  for TEST in $LIST_TEST;do
    if [ "$DOWN" = "$TEST" ]; then
      RES="OK"
    fi
  done
  if [ "$RES" = "KO" ]; then STOP "DOWN choice $DOWN unknown. Unable to continue" ; fi
  echo -n "Compilation with $COMP"
  if [ "$OPENMP" = "YES" ]; then echo " with OpenMP" ;fi
  if [ "$OPENMP" = "NO" ]; then echo " without OpenMP";fi
  echo 'Using the following libraries :'
  for PKG in $LIST_PKG; do
    eval PKG1='$'$PKG
    eval PKG2='$VERSION_'$PKG
    echo " "$PKG" "$PKG1" "$PKG2
  done | awk '{printf "%8s %3s %10-s\n",$1,$2,$3 }'
}

#========================================================= Test STEP2
#======================================================== Environment
TEST_STEP2(){ DEBUG="TEST_STEP2"
[[ -n "$MODULES_LIST" ]] && echo &&  echo $MODULES_LIST | sed 's:\ :\n:g' | sed 's/.*/module load &/'
}

#========================================================= Test STEP3
#================================================== Compilator option
TEST_STEP3(){ DEBUG="TEST_STEP3"
  echo
  echo "     Seqential compilators    Parallel compilators"
  echo " C   $S_CC  $P_CC"  | awk '{printf " %4-s %20s %23s\n",$1,$2,$3 }'
  echo " C++ $S_CXX $P_CXX" | awk '{printf " %4-s %20s %23s\n",$1,$2,$3 }'
  echo " FC  $S_FC  $P_FC"  | awk '{printf " %4-s %20s %23s\n",$1,$2,$3 }'
  echo " F77 $S_F77 $P_F77" | awk '{printf " %4-s %20s %23s\n",$1,$2,$3 }'
[[ -n "$EXPORT_LIST" ]] && echo
EXPORT_LIST=$(echo $EXPORT_LIST | sed 's:\ :\n:g' | sort | uniq)
for var in $(echo $EXPORT_LIST | sed 's:\ :\n:g' | grep "FLAGS"); do
  eval value='$'$var
  echo " "$var"|"$value
done | awk -F"|" '{printf "%16s=%-s\n",$1,$2 }'
for var in $(echo $EXPORT_LIST | sed 's:\ :\n:g' | grep -v "FLAGS"); do
  eval value='$'$var
  echo " "$var"|"$value
done | awk -F"|" '{printf "%16s=%-s\n",$1,$2 }'
}

TEST_STEP4(){ DEBUG="TEST_STEP4"
}

#========================================================= Test STEP5
#================================================ Compilation of libs
TEST_STEP5(){ DEBUG="TEST_STEP5"
  echo 
  echo -e "Compilation of the libs \e[32m\e[1mOK\e[21m\e[0m"
}

#========================================================= Test STEP6
#=========================================== patch code_saturne source
TEST_STEP6(){ DEBUG="TEST_STEP6"
  echo -e "Sources of code_saturne \e[32m\e[1mready\e[21m\e[0m"
}

#========================================================= Test STEP7
#======================================== Compilation of code_saturne
TEST_STEP7(){ DEBUG="TEST_STEP7"
  echo -e "Compilation of code_saturne \e[32m\e[1mOK\e[21m\e[0m"
}

#========================================================= Test STEP8
#================================================= patch code_saturne
TEST_STEP8(){ DEBUG="TEST_STEP8"
  echo -e "\e[32m\e[1mCode_saturne ready to use\e[21m\e[0m"
}

#========================================================= Test STEP9
#========================================================== Debiefing
TEST_STEP9(){ DEBUG="TEST_STEP9"
  echo
  echo -e "\e[32m\e[1mEND\e[21m\e[0m"
  echo
}


#============================================================== Catch
#============================================================== Error
STOP(){
  echo
  echo
  echo -e "\e[31m\e[1m*** Error ***\e[21m\e[0m : "
  echo $1
  echo " in $DEBUG"
  if [ -n "$EXPORT_LIST$MODULES_LIST" ]; then
    echo " to reproduce the environment :"
    [[ -n "$MODULES_LIST" ]] &&    echo && echo $MODULES_LIST | sed 's:\ :\n:g' | sed 's/.*/module load &/'
    if [ -n "$EXPORT_LIST" ]; then
      echo
      EXPORT_LIST=$(echo $EXPORT_LIST | sed 's:\ :\n:g' | sort | uniq)
      for var in $EXPORT_LIST; do
        eval value='$'$var
        echo "export "$var"="$value
      done
    fi
  fi
  exit 1
}


#=========================================================== Download
#=========================================================== Function
download(){
  if [ ! -e  $PREFIX/pkg/$1 ] ; then # Download only if not already here
    cd $PREFIX/pkg
    if [ $DOWN == "NO" ] ; then STOP "Can't Download here, put your packages in pkg" ; fi
    echo -n " - Downloading"
    wget -O $1 $2 > /dev/null 2>&1 || STOP
  fi
  cd $PREFIX/src
  if [ -d $PREFIX/src/$(basename $1 .tar.gz) ] ; then
    rm -rf $PREFIX/src/$(basename $1 .tar.gz) # Remove the sources to clean it
  fi
  echo -n " - Unpacking"
  tar -zxvf $PREFIX/pkg/$1 > /dev/null 2>&1 || STOP "Decompress the package, redownload it"
}

usage(){
             echo 'use -p PATH to specify the prefix of installation'
             echo 'use -m MACHINE to specify the machine'
}


while getopts “hm:p:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         p)
             PREFIX=$OPTARG
             ;;
         m)
             MACHINE=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done



#====================================================================
#============================================================== Start
#====================================================================


#STEP0 : machine name
#STEP1 : what libs and what compilator collection
#STEP2 : environment (modules, export and paths)
#STEP3 : compilators options
#STEP5 : libs setup
#STEP6 : patch saturne sources
#STEP7 : compile saturne
#STEP8 : patch saturne
#STEP9 : debriefing
LIST_STEP="0 1 2 3 4 5 6 7 8 9"
for STEP in $LIST_STEP;do
  for FILE in $(ls install/*.conf);do
    unset STEP$STEP
    source $FILE $STEP
  done
  TEST_STEP$STEP
done


