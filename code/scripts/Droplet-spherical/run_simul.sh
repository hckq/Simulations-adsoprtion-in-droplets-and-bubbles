#!/bin/bash
#SBATCH --job-name=JobXX
#SBATCH --time=240:00:00
#SBATCH --ntasks=8
##SBATCH --constraint=rack-3
#SBATCH --nodes=1
#SBATCH --mem=4000

source .../gromacs-2019.4B/bin/GMXRC  # add source path
GMXpath= .../gromacs-2019.4B/bin/ # add GROMACS path

water_box_height='6.5'
water_box_depth='6.5'
water_box_length='6.5'
#boxlength=7
#boxx=5
#boxy=5
boxlength=12
boxx_half='4.50320'
boxx_quart='2.25160'
boxx=12
boxy=12
nmol=16
pdbfile='propanol_aaop'
system='sphere_propanol_water' 
realiz=1
seed=99324

realizname='_'${realiz}

if [ -f init_n${nmol}_l${boxlength}_${system}${realizname}.gro ] 
then
    echo "The file init_n${nmol}_l${boxlength}_${system}${realizname}.gro already exists, it will not be created"
else 

    if [ "${nmol}" -gt 0 ]
    then
        echo 'Initialize a configuation of '$nmol ' molecules in a box of size: '  ${water_box_length} ${water_box_depth} ${water_box_height}
        ${GMXpath}gmx insert-molecules -ci  ${pdbfile}.pdb -o init_n${nmol}_l${boxlength}_${system}${realizname}.gro -nmol $nmol  -box  ${water_box_length} ${water_box_depth} ${water_box_height}
        echo 'Solvate a box of size: ' ${water_box_length} ${water_box_depth} ${water_box_height}
        ${GMXpath}gmx solvate -cp init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o init_n${nmol}_l${boxlength}_${system}${realizname}.gro  -box  ${water_box_length}  ${water_box_depth} ${water_box_height}
    else
        echo 'Solvate a box of size: ' ${water_box_length} ${water_box_depth} ${water_box_height}
        ${GMXpath}gmx solvate -p topol_n${nmol}_l${boxlength}${realizname}.top -o init_n${nmol}_l${boxlength}_${system}${realizname}.gro  -box  ${water_box_length}  ${water_box_depth} ${water_box_height}
    fi


    ${GMXpath}gmx editconf -f init_n${nmol}_l${boxlength}_${system}${realizname}.gro -o init_n${nmol}_l${boxlength}_${system}${realizname}.pdb -nopbc -box ${boxx}   ${boxy}  ${boxlength} 
    ${GMXpath}gmx editconf -f init_n${nmol}_l${boxlength}_${system}${realizname}.pdb -o init_n${nmol}_l${boxlength}_${system}${realizname}.pdb -nopbc -translate 0 0 -0.5


    ${GMXpath}gmx editconf -f init_n${nmol}_l${boxlength}_${system}${realizname}.pdb -resnr 0 -o init_n${nmol}_l${boxlength}_${system}${realizname}.gro
    ${GMXpath}gmx editconf -f init_n${nmol}_l${boxlength}_${system}${realizname}.gro -o init_n${nmol}_l${boxlength}_${system}${realizname}.gro  -nopbc -box  ${boxx}   ${boxy} ${boxlength}

fi


echo 'First steps with smaller timestep'
if [ "${nmol}" -gt 0 ]
then
    ${GMXpath}gmx grompp -f TI_cmrem.mdp -c init_n${nmol}_l${boxlength}_${system}${realizname}.gro -r init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o topol_n${nmol}_l${boxlength}${realizname}.tpr -maxwarn 3
else
    ${GMXpath}gmx grompp -f TI0_cmrem.mdp -c init_n${nmol}_l${boxlength}_${system}${realizname}.gro -r init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o topol_n${nmol}_l${boxlength}${realizname}.tpr -maxwarn 3
fi
${GMXpath}gmx mdrun  -s topol_n${nmol}_l${boxlength}${realizname}.tpr -nt 8 -cpt 1 -maxh 24 -deffnm evol_num${nmol}_len${boxlength}${realizname} -cpi state_n${nmol}_l${boxlength}${realizname}.cpt -cpo state_n${nmol}_l${boxlength}${realizname}.cpt -noappend 1> mdrun_n${nmol}_l${boxlength}${realizname}.stdout 2> mdrun_n${nmol}_l${boxlength}${realizname}.stderr

if [ "${nmol}" -gt 0 ]
then
    #${GMXpath}gmx grompp -f TI_init.mdp -c init_n${nmol}_l${boxlength}_${system}${realizname}.gro -r init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o topol_n${nmol}_l${boxlength}${realizname}.tpr -maxwarn 3
    ${GMXpath}gmx grompp -f TI_init.mdp -c  evol_num${nmol}_len${boxlength}${realizname}.part0001.gro  -r init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o topol_n${nmol}_l${boxlength}${realizname}.tpr -maxwarn 3
else
    #${GMXpath}gmx grompp -f TI0_init.mdp -c init_n${nmol}_l${boxlength}_${system}${realizname}.gro -r init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o topol_n${nmol}_l${boxlength}${realizname}.tpr -maxwarn 3
    ${GMXpath}gmx grompp -f TI0_init.mdp -c evol_num${nmol}_len${boxlength}${realizname}.part0001.gro -r init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o topol_n${nmol}_l${boxlength}${realizname}.tpr -maxwarn 3
fi

${GMXpath}gmx mdrun  -s topol_n${nmol}_l${boxlength}${realizname}.tpr -nt 8 -cpt 1 -maxh 24 -deffnm evol_num${nmol}_len${boxlength}${realizname} -cpi state_n${nmol}_l${boxlength}${realizname}.cpt -cpo state_n${nmol}_l${boxlength}${realizname}.cpt -noappend 1> mdrun_n${nmol}_l${boxlength}${realizname}.stdout 2> mdrun_n${nmol}_l${boxlength}${realizname}.stderr

if [ "${nmol}" -gt 0 ]
then
    #${GMXpath}gmx grompp -f TI.mdp -c init_n${nmol}_l${boxlength}_${system}${realizname}.gro -r init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o topol_n${nmol}_l${boxlength}${realizname}.tpr -maxwarn 3
    ${GMXpath}gmx grompp -f TI.mdp -c evol_num${nmol}_len${boxlength}${realizname}.part0002.gro  -r init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o topol_n${nmol}_l${boxlength}${realizname}.tpr -maxwarn 3
else
    #${GMXpath}gmx grompp -f TI0.mdp -c init_n${nmol}_l${boxlength}_${system}${realizname}.gro -r init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o topol_n${nmol}_l${boxlength}${realizname}.tpr -maxwarn 3
    ${GMXpath}gmx grompp -f TI0.mdp -c evol_num${nmol}_len${boxlength}${realizname}.part0002.gro -r init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o topol_n${nmol}_l${boxlength}${realizname}.tpr -maxwarn 3
fi
${GMXpath}gmx mdrun  -s topol_n${nmol}_l${boxlength}${realizname}.tpr -nt 8 -cpt 1 -maxh 168 -deffnm evol_num${nmol}_len${boxlength}${realizname} -cpi state_n${nmol}_l${boxlength}${realizname}.cpt -cpo state_n${nmol}_l${boxlength}${realizname}.cpt -noappend 1> mdrun_n${nmol}_l${boxlength}${realizname}.stdout 2> mdrun_n${nmol}_l${boxlength}${realizname}.stderr
