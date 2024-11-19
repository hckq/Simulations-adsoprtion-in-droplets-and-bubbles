#!/bin/bash
#SBATCH --time=440:00:00
#SBATCH --mem=2048 
#SBATCH --partition=long
#SBATCH --ntasks=8
#SBATCH --nodes=1

echo $HOME

source .../gromacs-2023.3_gcc/bin/GMXRC  # add source path
GMXpath=.../gromacs-2023.3_gcc/bin/    # add GROMACS path

boxx=11
boxy=5
boxz=11
nmol=38
insertsurf=0
pdbfile='propanol_aaop'
system='cylindrical_bubble_in_propanol_water' 
realiz=1
seed=4368

realizname='_'${realiz}

${GMXpath}gmx insert-molecules -ci  ${pdbfile}.pdb -seed ${seed}  -o init_n${nmol}_l${boxz}_${system}${realizname}6.gro -nmol $nmol  -box  ${boxx}   ${boxy}  ${boxz} 

${GMXpath}gmx solvate -cp init_n${nmol}_l${boxz}_${system}${realizname}6.gro -p topol_n${nmol}_l${boxz}${realizname}.top -o init_n${nmol}_l${boxz}_${system}${realizname}6.gro  -box  ${boxx}   ${boxy}  ${boxz} 

${GMXpath}gmx grompp -f TI_cmrem.mdp -c init_n${nmol}_l${boxz}_${system}${realizname}6.gro -r init_n${nmol}_l${boxz}_${system}${realizname}6.gro -p topol_n${nmol}_l${boxz}${realizname}.top -o topol_n${nmol}_l${boxz}${realizname}.tpr -maxwarn 3

${GMXpath}gmx select -f init_n${nmol}_l${boxz}_${system}${realizname}6.gro -s topol_n${nmol}_l${boxz}${realizname}.tpr  -on output.ndx -select 'x > 7 or z > 7' -selrpos res_com -os size.xvg -oi index.dat

${GMXpath}gmx editconf -f init_n${nmol}_l${boxz}_${system}${realizname}6.gro -o init_n${nmol}_l${boxz}_${system}${realizname}6.gro -pbc -translate  '-3.5' '0' '-3.5' 

${GMXpath}gmx trjconv -f init_n${nmol}_l${boxz}_${system}${realizname}6.gro -s topol_n${nmol}_l${boxz}${realizname}.tpr -n output.ndx -pbc res -o init_n${nmol}_l${boxz}_${system}${realizname}7.gro

${GMXpath}gmx convert-tpr -s topol_n${nmol}_l${boxz}${realizname}.tpr  -n output.ndx -o topol_n${nmol}_l${boxz}${realizname}_new.tpr 

${GMXpath}gmx editconf -f init_n${nmol}_l${boxz}_${system}${realizname}7.gro  -resnr 0 -o init_n${nmol}_l${boxz}_${system}${realizname}7.gro

${GMXpath}gmx editconf -f init_n${nmol}_l${boxz}_${system}${realizname}7.gro -o init_n${nmol}_l${boxz}_${system}${realizname}7.pdb

${GMXpath}gmx make_ndx -f init_n${nmol}_l${boxz}_${system}${realizname}7.gro  -o output2.ndx < comm1.txt

${GMXpath}gmx trjconv -f init_n${nmol}_l${boxz}_${system}${realizname}7.gro -s topol_n${nmol}_l${boxz}${realizname}_new.tpr -n output2.ndx -pbc res -o init_n${nmol}_l${boxz}_${system}${realizname}8.gro <<< "6"

${GMXpath}gmx editconf -f init_n${nmol}_l${boxz}_${system}${realizname}8.gro  -resnr 0 -o init_n${nmol}_l${boxz}_${system}${realizname}8.gro

${GMXpath}gmx editconf -f init_n${nmol}_l${boxz}_${system}${realizname}8.gro -o init_n${nmol}_l${boxz}_${system}${realizname}8.pdb

${GMXpath}gmx convert-tpr -s topol_n${nmol}_l${boxz}${realizname}_new.tpr -n output2.ndx -o topol_n${nmol}_l${boxz}${realizname}_new2.tpr <<< "6"

${GMXpath}gmx make_ndx -f init_n${nmol}_l${boxz}_${system}${realizname}8.gro -n output2.ndx  -o output3.ndx < comm2.txt

${GMXpath}gmx trjconv -f init_n${nmol}_l${boxz}_${system}${realizname}8.gro -s topol_n${nmol}_l${boxz}${realizname}_new2.tpr -n output3.ndx -pbc res -o init_n${nmol}_l${boxz}_${system}${realizname}9.gro  <<< "7"

${GMXpath}gmx editconf -f init_n${nmol}_l${boxz}_${system}${realizname}9.gro  -resnr 0 -o init_n${nmol}_l${boxz}_${system}${realizname}9.gro

${GMXpath}gmx editconf -f init_n${nmol}_l${boxz}_${system}${realizname}9.gro -o init_n${nmol}_l${boxz}_${system}${realizname}9.pdb

${GMXpath}gmx convert-tpr -s topol_n${nmol}_l${boxz}${realizname}_new2.tpr -n output3.ndx -o topol_n${nmol}_l${boxz}${realizname}_new3.tpr   <<< "7"

${GMXpath}gmx mdrun  -s topol_n${nmol}_l${boxz}${realizname}_new3.tpr -nt 8 -cpt 1 -maxh 24 -deffnm evol_num${nmol}_len${boxz}${realizname} -cpi state_n${nmol}_l${boxz}${realizname}.cpt -cpo state_n${nmol}_l${boxz}${realizname}.cpt -noappend 1> mdrun_n${nmol}_l${boxz}${realizname}.stdout 2> mdrun_n${nmol}_l${boxz}${realizname}.stderr

${GMXpath}gmx grompp -f TI_init.mdp -c  init_n${nmol}_l${boxz}_${system}${realizname}9.gro -p topol_n${nmol}_l${boxz}${realizname}_new4.top -o topol_n${nmol}_l${boxz}${realizname}_new4.tpr -maxwarn 3

${GMXpath}gmx mdrun  -s topol_n${nmol}_l${boxz}${realizname}_new4.tpr -nt 8 -cpt 1 -maxh 24 -deffnm evol_num${nmol}_len${boxz}${realizname} -cpi state_n${nmol}_l${boxz}${realizname}.cpt -cpo state_n${nmol}_l${boxz}${realizname}.cpt -noappend 1> mdrun_n${nmol}_l${boxz}${realizname}.stdout 2> mdrun_n${nmol}_l${boxz}${realizname}.stderr

${GMXpath}gmx grompp -f TI.mdp -c  init_n${nmol}_l${boxz}_${system}${realizname}9.gro -p topol_n${nmol}_l${boxz}${realizname}_new4.top -o topol_n${nmol}_l${boxz}${realizname}_new7.tpr -maxwarn 3

${GMXpath}gmx mdrun  -s topol_n${nmol}_l${boxz}${realizname}_new7.tpr -nt 8 -cpt 1 -maxh 336 -deffnm evol_num${nmol}_len${boxz}${realizname} -cpi state_n${nmol}_l${boxz}${realizname}.cpt -cpo state_n${nmol}_l${boxz}${realizname}.cpt -noappend 1> mdrun_n${nmol}_l${boxz}${realizname}.stdout 2> mdrun_n${nmol}_l${boxz}${realizname}.stderr

