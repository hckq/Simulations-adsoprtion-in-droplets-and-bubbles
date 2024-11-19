#!/bin/bash
#SBATCH --job-name=JobXX
#SBATCH --time=120:00:00
#SBATCH --ntasks=8
##SBATCH --constraint=rack-3
#SBATCH --nodes=1
#SBATCH --mem=4000


source .../gromacs-2019.4B/bin/GMXRC  # add source path
GMXpath= .../gromacs-2019.4B/bin/ # add GROMACS path

water_box_size=5
boxlength=14
boxx=7
boxy=7
#boxlength=10
#boxx='4.50320'
#boxy='5.20000'
nmol=32
pdbfile='propanol_aaop'
system='water_propanol_slab' 
realiz=1
seed=3729

realizname='_'${realiz}

if [ "${nmol}" -gt 0 ]
then
    echo 'Initialize a configuation of '$nmol ' molecules in a box of size: ' ${boxx}  ${boxy}  $boxlength
    if [ -f init_n${nmol}_l${boxlength}_${system}${realizname}.gro  ]
    then
        ${GMXpath}gmx insert-molecules -f init_n${nmol}_l${boxlength}_${system}${realizname}.gro -ci  ${pdbfile}.pdb -seed ${seed} -o init_n${nmol}_l${boxlength}_${system}${realizname}.gro -nmol $nmol -box  ${boxx}   ${boxy} ${water_box_size}
    else
        ${GMXpath}gmx insert-molecules -ci  ${pdbfile}.pdb -o init_n${nmol}_l${boxlength}_${system}${realizname}.gro -nmol $nmol -box  ${boxx}   ${boxy} ${water_box_size}
    fi
fi

echo 'Solvate a box of size: '$water_box_size


if [ -f init_n${nmol}_l${boxlength}_${system}${realizname}.gro  ]
then
    ${GMXpath}gmx solvate -cp init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o init_n${nmol}_l${boxlength}_${system}${realizname}.gro  -box  ${boxx}   ${boxy} ${water_box_size}
else
    ${GMXpath}gmx solvate -p topol_n${nmol}_l${boxlength}${realizname}.top -o init_n${nmol}_l${boxlength}_${system}${realizname}.gro  -box  ${boxx}   ${boxy} ${water_box_size}
fi

${GMXpath}gmx editconf -f init_n${nmol}_l${boxlength}_${system}${realizname}.gro -o init_n${nmol}_l${boxlength}_${system}${realizname}.gro -nopbc -box ${boxx}   ${boxy}  ${boxlength} 


if [ -f topol_n${nmol}_l${boxlength}${realizname}.tpr ]
then
    echo "The system is already equilibrated, will not run the simulation with smaller timestep"
else
    echo 'First steps with smaller timestep'
    if [ "${nmol}" -gt 0 ]
    then
        ${GMXpath}gmx grompp -f TI_init.mdp -c init_n${nmol}_l${boxlength}_${system}${realizname}.gro -r init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o topol_n${nmol}_l${boxlength}${realizname}.tpr -maxwarn 3
    else
        ${GMXpath}gmx grompp -f TI0_init.mdp -c init_n${nmol}_l${boxlength}_${system}${realizname}.gro -r init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o topol_n${nmol}_l${boxlength}${realizname}.tpr -maxwarn 3
    fi

    ${GMXpath}gmx mdrun  -s topol_n${nmol}_l${boxlength}${realizname}.tpr -nt 8 -cpt 1 -maxh 24 -deffnm evol_num${nmol}_len${boxlength}${realizname} -cpi state_n${nmol}_l${boxlength}${realizname}.cpt -cpo state_n${nmol}_l${boxlength}${realizname}.cpt -noappend 1> mdrun_n${nmol}_l${boxlength}${realizname}.stdout 2> mdrun_n${nmol}_l${boxlength}${realizname}.stderr
fi


if [ "${nmol}" -gt 0 ]
then
    ${GMXpath}gmx grompp -f TI.mdp -c evol_num${nmol}_len${boxlength}${realizname}.part0001.gro -r init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o topol_n${nmol}_l${boxlength}${realizname}.tpr -maxwarn 3
else
    ${GMXpath}gmx grompp -f TI0.mdp -c evol_num${nmol}_len${boxlength}${realizname}.part0001.gro -r init_n${nmol}_l${boxlength}_${system}${realizname}.gro -p topol_n${nmol}_l${boxlength}${realizname}.top -o topol_n${nmol}_l${boxlength}${realizname}.tpr -maxwarn 3
fi
${GMXpath}gmx mdrun  -s topol_n${nmol}_l${boxlength}${realizname}.tpr -nt 8 -cpt 1 -maxh 120 -deffnm evol_num${nmol}_len${boxlength}${realizname} -cpi state_n${nmol}_l${boxlength}${realizname}.cpt -cpo state_n${nmol}_l${boxlength}${realizname}.cpt -noappend 1> mdrun_n${nmol}_l${boxlength}${realizname}.stdout 2> mdrun_n${nmol}_l${boxlength}${realizname}.stderr

