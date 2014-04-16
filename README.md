install-saturne
===============
Script to install-saturne on various machines around Pprime

Fast-use of the automatic process
---------------------------------
> install.sh -m MACHINE -p PREFIX (Arguments are optionnals)

where MACHINE is one of 

MACHINE           | website
------------------|-------------
LOCAL (default)   |
ADA               | http://www.idris.fr/ada/
CURIE             | http://www-hpc.cea.fr/fr/complexe/tgcc-doc-util.htm
HULK              | http://mc2p.cnrs.pprime.fr/
MC2P              | http://mc2p.cnrs.pprime.fr/

and PREFIX is the path where you want to install saturne (default : pwd)

To have more info :

    > install.sh -h
    use -p PATH to specify the prefix of installation (default : pwd)
        -m MACHINE to specify the machine, Where MACHINE is one of 
           LOCAL (default)
           ADA
           CURIE
           HULK
           MC2P
        -g to enable the GUI
        -v to specify the version of code_saturne to install
        -h this menu

Adaptation of the automatic process
-----------------------------------
If you want to select the package you want to use/install,
if you encounter some difficulties and you want to force some choices (e.g. gcc/icc),
you should use the 40_USER.conf file which is extensively commented.

Manual-use
----------
The only important steps to do the process manually are :

 - STEP2 : prepare the environment (files 20_*              )
 - STEP3 : set compilators flags   (files 00_, 20_* and 99_ )
 - STEP5 : libs setup              (files 1?_*.conf         )
 - STEP7 : compile saturne         (file  19_SATURNE.conf   )

Detailled description
---------------------
List of files :

File                |   Function
--------------------|-----------------
install.sh          | Main script
README.md           | This file
00_PRE_GENERIC.conf | defaults choices
10_OPENMPI.conf     | How to install OPENMPI
11_METIS.conf       | How to install METIS
12_HDF5.conf        | How to install HDF5
13_CGNS.conf        | How to install CGNS
14_SCOTCH.conf      | How to install SCOTCH
19_SATURNE.conf     | How to install SATURNE
20_LOCAL.conf       | Specifities of the local machine 
20_ADA.conf         | Specifities of the machine ADA
20_CURIE.conf       | Specifities of the machine CURIE
20_HULK.conf        | Specifities of the machine HULK
20_MC2P.conf        | Specifities of the machine MC2P
40_USER.conf        | User choices that overwrite default
99_POST_GENERIC.conf| 
RESSOURCES          | Ressources used by this script

The directories that will be used are :

                                        +-----------------+
                                        |     PREFIX      |
                                        +-------+---------+
                                                |
                +--------------------+----------+------+------------------+
                |                    |                 |                  |
    +-----------+-----------+ +------+-------+ +-------+-------+ +--------+--------+
    |__________pkg__________| |_____src______| |______lib______| |__code_saturne___|
    |   Where the source    | |  Where the   | | Where are put | |  Where are put  |
    | package is downloaded | |   sources    | | the BINaries  | |  the BINaries   |
    |   automatically or    | |     are      | |  of the libs  | | of code_saturne |
    |       manually        | | decompressed | +---------------+ +-----------------+
    +-----------------------+ +------+-------+
                                     |
                           +---------+---------+
                           |_______build_______|
                           | Where compilation |
                           |      is done      |
                           +-------------------+

By doing :

    for each STEP
        for each file.conf
            process STEP in file.conf
        endfor
    endfor

The meaning of the steps are :

 - STEP0 : define machine name
 - STEP1 : define what libs and what compilator collection to use
 - STEP2 : setup the environment (modules, export and paths)
 - STEP3 : sets compilators options
 - STEP5 : libs setup
 - STEP6 : patch saturne sources
 - STEP7 : compile saturne
 - STEP8 : patch saturne
 - STEP9 : debriefing

The files are processed alphabetically 

To get the latest version of this script :
> git clone git@github.com:pums974/install-saturne.git

or visit https://github.com/pums974/install-saturne



