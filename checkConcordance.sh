# !/bin/bash

# Master script to conduct the whole concordance check right from the miniMac output
# Syntax: bash checkConcordance 400dataDosage.dose chr1400Indag.info 
# Main output would be Concord_blockXX.txt and some intermediate output
# Assume reference are separated by Block in GWAS1 fashion, and a separate GWAS1 Ind file phenotype.gwas1.csv was given


# Get SNPs that passed filter (R^2>=0.3, MAF>=0.005)
Rscript passR2.R chr1400Indag.info
## returned 400dataSNPpassR2.txt

# Make individuals from data same ordering as reference
awk '{ print $1}' 400dataDosage.dose > IndOrder.txt
Rscript getIndOrder.R IndOrder.txt 
## returned 400dataIndOrdering.txt
# reorder data
bash schwartzianTransform 400dataDosage.dose 400dataIndOrdering.txt 400dataALLSNPsameOrderwithRef 
##returned 400dataALLSNPsameOrderwithRef.txt
#subsetting data 
block_n=$(find /home/Bowei/GWAS1/chr1 -maxdepth 1 -type f | wc -l)
for (( j=1; j<=$block_n; j++ ))
do
  nohup bash dataPartition.sh $j 400dataALLSNPsameOrderwithRef.txt 400dataSNPpassR2.txt &
done
## returned inxDataBlockX.txt and inxRefBlockX.txt  
# Wait until everything above is done (waiton script required)
for (( j=1; j<=$block_n; j++ ))
do
 waiton $(findpid "bash dataPartition.sh ${j}")
done

# Calculate concordance
for (( j=1; j<=$block_n; j++ ))
do
Rscript concordanceCalParallel.R $j
done
## returned final results Concord_BlockXX.txt
