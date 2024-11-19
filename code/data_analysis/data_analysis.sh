#!/bin/bash
#SBATCH --time=440:00:00
#SBATCH --mem=2048 
#SBATCH --partition=long
#SBATCH --ntasks=8
#SBATCH --nodes=1

echo $HOME


#sleep 120


#source /home/staniscia/gromacs-2023.3/bin/GMXRC
#GMXpath=/home/staniscia/gromacs-2023.3/bin/

source /home/staniscia/gromacs-2023.3_gcc/bin/GMXRC
GMXpath=/home/staniscia/gromacs-2023.3_gcc/bin/


boxsize=10
group=1
nbin=500
binsize='0.02'
#endloop=10
#begin=5000
#begloop=0 #marin
begloop=10000 #default
#begloop=500
#begloop=20000
endloop=100000 #default
#endloop=20000 
#endloop=25000 
#endloop=95000
#endloop=195000
#endloop=1210000
steploop=10000 #default
#steploop=1000 #marin
#steploop=5000
width=10000 #default
#width=1000 #marin
#width=5000
echo $begloop
echo $endloop
echo $(($endloop+1))


geometry='bubble_cyl'
#geometry='bubble_sph'
#geometry='tube'
#geometry='sphere'
#geometry='slab'
densitytype='number'
#densitytype='mass'
#solute=''
#solute='w'
#solute='m'
#solute='et'
#solute='me'
#solute='pt'
solute='pr'
#solute='pe'
#solute='oc'
#solute='do'
#solute='ph'
#solute='cb'
#solute='du'
#solute='xy'
#solute='2m'
#solute='aa'
#solute='fa'
#solute='ip'
#solute='nb'
#solute='to'
#solute='eb'
#solute_long='water'
#solute_long='methanol'
#solute_long='ethanol'
#solute_long='methane'
#solute_long='pentane'
solute_long='propanol'
#solute_long='pentanol'
#solute_long='octanol'
#solute_long='dodecanol'
#solute_long='phenol'
#solute_long='chlorobenzene'
#solute_long='durene'
#solute_long='xylene'
#solute_long='2-methylbutanoicacid'
#solute_long='aceticacid'
#solute_long='formicacid'
#solute_long='isopentane'
#solute_long='nitrobenzene'
#solute_long='toulene'
#solute_long='ethylbenzene'
hyd='hyd'
ox='ox'
car='car'
bin='0.020'
realization='_3'
#size_folder='_l12' #tube 
#size_folder='_l6p5' #sphere
#size_folder='_l5' #cube 
#size_folder='_r5p4' #bubble 
#size_folder='_l7' #bubble 
size_folder='' #others
realization2=${realization}
fix='_fix'
#fix=''
#nmolarr=(0 8 16 24 32 40 48 56 64 80 96 112 128 144 160 208 256 512)
#nmolarr=(24 40 56 72 88 96 112 128) # 144 160 208 256 512)
#nmolarr=(8 16 24 32 40 48 56 64 128 256 512)
#nmolarr=(8 16 24 32 40 48 56 64 128)
#nmolarr=(2 4 6 8 16 24 32)
#nmolarr=(1 2 3 4)
#nmolarr=(4 8 16 32 64 128) # 256)
#nmolarr=(4 8 12 16 20) # 24)
#nmolarr=(8 16 24 32)
#nmolarr=(8 16 32 48 64 80 96 112 128 144 160 208 256 512) #slab
#nmolarr=(24 40 56 72 88) # surf miuns slab
#nmolarr=(8 16 24 32 40 48 56 64 72 80 88 96 112 128 144 160 208 256 512) #cube surf
#nmolarr=(4 8 12 16 20 24 28) # wetting
#nmolarr=(4 8 16 32 64 128 256 512) # wetting
#nmolarr=(5 10 20 40) # tube m l 3p5
#nmolarr=(8 16 24 32) # tube et l 7
#nmolarr=(6 12 18 24) # tube et l 5 4 3p5
#nmolarr=(10 20 30 40) # tube m l 4 and 7
#nmolarr=(6 15 30 40) # tube m l 5
#nmolarr=(12) # tube pr
#nmolarr=(8) # sphere
#nmolarr=(4 8 12 16 20) # tube pr
#nmolarr=(6 15 30 40) # tube
#nmolarr=(2 4 6 8) # tube pe
#nmolarr=(64 128) # wetting
#nmolarr=(4 8 12 16 20 24) # wetting
#nmolarr=(32 128 256) # wetting
##nmolarr=(8 16 24 32 40 48 56 64 72 80) # wetting
#nmolarr=(0) 
#nmolarr=(256 512)
#nmolarr=(28 54 80) # bubble spherical
#nmolarr=(14 26 38) # bubble cylindrical
#nmolarr=(10 20 30 40 50) # drop cylindrical meth
#nmolarr=(10) # drop cylindrical meth
#nmolarr=(2 4 6 8 10) # drop cylindrical phen

nmolarr=(0) # slab

#if [ "${solute_long}" = 'pentanol' ] 
#if [ "${solute_long}" = 'pentanol' ] || [ "${geometry}" = 'slab' ] || [ "${geometry}" = 'cube_NPT' ]
#then
#part='.part0002' #surf slab o altro per pentanolo
#part3='.part0003' #pent
#part4='.part0004' #pent
#part5='.part0005' #pent
#part6='.part0006' #pent
#part7='.part0007' #pent
#else
part='.part0003' #wetting tube, eccetto che per il pentanolo
part3='.part0004' #wetting tube surf slab
part4='.part0005'
part5='.part0006'
part6='.part0007'
part7='.part0008'
#part='' #water slab
#part3=''
#fi

#cd water_${solute_long}_${geometry}/
for nmol in "${nmolarr[@]}"; do
##nmol=$((2**($COUNTER+$begloop)))
echo $nmol

#if [ ${nmol} -eq 46 ]
#then
#part='_rest.part0001'
#echo  $part
#fi

#if [ "${geometry}" = 'bubble_cyl' ] ||  [ "${geometry}" = 'bubble_sph' ]
#then
#n_folder='rho'${nmol}
#else
n_folder='n'${nmol}
cd folder_${n_folder}${size_folder}${realization}/
echo folder_${n_folder}${size_folder}${realization}/


${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.xtc   evol_num${nmol}_len${boxsize}${realization}${part3}.xtc -o  evol_num${nmol}_len${boxsize}${realization}${part}.xtc 
${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.xtc   evol_num${nmol}_len${boxsize}${realization}${part4}.xtc -o  evol_num${nmol}_len${boxsize}${realization}${part}.xtc 
${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.trr   evol_num${nmol}_len${boxsize}${realization}${part3}.trr -o  evol_num${nmol}_len${boxsize}${realization}${part}.trr 
${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.trr   evol_num${nmol}_len${boxsize}${realization}${part4}.trr -o  evol_num${nmol}_len${boxsize}${realization}${part}.trr 
${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.xtc   evol_num${nmol}_len${boxsize}${realization}${part5}.xtc -o  evol_num${nmol}_len${boxsize}${realization}${part}.xtc 
${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.trr   evol_num${nmol}_len${boxsize}${realization}${part5}.trr -o  evol_num${nmol}_len${boxsize}${realization}${part}.trr 
${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.xtc   evol_num${nmol}_len${boxsize}${realization}${part6}.xtc -o  evol_num${nmol}_len${boxsize}${realization}${part}.xtc 
${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.trr   evol_num${nmol}_len${boxsize}${realization}${part6}.trr -o  evol_num${nmol}_len${boxsize}${realization}${part}.trr 
${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.xtc   evol_num${nmol}_len${boxsize}${realization}${part7}.xtc -o  evol_num${nmol}_len${boxsize}${realization}${part}.xtc 
${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.trr   evol_num${nmol}_len${boxsize}${realization}${part7}.trr -o  evol_num${nmol}_len${boxsize}${realization}${part}.trr 

${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.xtc   evol_num${nmol}_len${boxsize}${realization}_rest.part0001.xtc -o  evol_num${nmol}_len${boxsize}${realization}${part}.xtc 
${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.trr   evol_num${nmol}_len${boxsize}${realization}_rest.part0001.trr -o  evol_num${nmol}_len${boxsize}${realization}${part}.trr 
${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.xtc   evol_num${nmol}_len${boxsize}${realization}_rest.part0002.xtc -o  evol_num${nmol}_len${boxsize}${realization}${part}.xtc 
${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.trr   evol_num${nmol}_len${boxsize}${realization}_rest.part0002.trr -o  evol_num${nmol}_len${boxsize}${realization}${part}.trr 
#${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.xtc   evol_num${nmol}_len${boxsize}${realization}_rest.part0003.xtc -o  evol_num${nmol}_len${boxsize}${realization}${part}.xtc 
#${GMXpath}gmx  trjcat -f  evol_num${nmol}_len${boxsize}${realization}${part}.trr   evol_num${nmol}_len${boxsize}${realization}_rest.part0003.trr -o  evol_num${nmol}_len${boxsize}${realization}${part}.trr 





if [ "${geometry}" = 'bubble_sph' ] || [ "${geometry}" = 'bubble_cyl' ]
then
altr='_new7'
else
altr=''
fi

echo -e "0 \n 0 \n" | ${GMXpath}gmx trjconv -f evol_num${nmol}_len${boxsize}${realization}${part}.xtc -s topol_n${nmol}_l${boxsize}${realization}${altr}.tpr -pbc mol -ur  compact  -center -o evol_num${nmol}_len${boxsize}${realization}${fix}${part}.xtc 

echo -e "0 \n 0 \n" | ${GMXpath}gmx trjconv -f evol_num${nmol}_len${boxsize}${realization}${fix}${part}.xtc -s topol_n${nmol}_l${boxsize}${realization}${altr}.tpr -fit translation -o evol_num${nmol}_len${boxsize}${realization}${fix}${part}.xtc 

echo -e "0 \n" | ${GMXpath}gmx trjconv -f evol_num${nmol}_len${boxsize}${realization}${fix}${part}.xtc -s topol_n${nmol}_l${boxsize}${realization}${altr}.tpr -dt 100 -o evol_num${nmol}_len${boxsize}${realization}${fix}${part}.pdb  

${GMXpath}gmx  eneconv -f  evol_num${nmol}_len${boxsize}${realization}*.edr -o  evol_num${nmol}_len${boxsize}${realization}.edr 

COUNTER=$begloop

echo $COUNTER

until [  $(($COUNTER+$width)) -gt $endloop ]; do

echo $COUNTER
echo $endloop

begin=$(($COUNTER))
end=$(($COUNTER+$width))

echo 'begin end:'
echo $begin
echo $end

interval='_'$(($COUNTER+$((($width)/2))))


${GMXpath}gmx energy -f evol_num${nmol}_len${boxsize}${realization}.edr -s topol_n${nmol}_l${boxsize}${realization}.tpr  -o ener_n${nmol}_l${boxsize}${realization}${interval}.xvg -b ${begin} -e ${end} -fluct_props -orinst <<< "9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 47 48 49 50 0"
   
COUNTER=$(($COUNTER+$steploop))

done

cd ..

done


# esempi di come fare video per VMD:
#${GMXpath}gmx trjconv -f traj_comp_n${nmol}_l${boxlength}.xtc  -o trajout_n${nmol}_l${boxlength}.pdb
#${GMXpath}gmx trjconv -f evol_num12_len12_1.part0003.xtc -s topol_n12_l12_1.tpr -skip 1000 -o trajout_n12_len12_1_prop_part3_pr.pdb
