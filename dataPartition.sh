#!/bin/bash

#fileNeedPar='400dataALLSNPsameOrderwithRef.txt'
#snpList='400dataSNPpassR2.txt'
i=$1 #Block number
fileNeedPar=$2
snpList=$3



refInd=`awk 'NR>1 {print $2}' 400dataIndOrdering.txt | tr "\n" , | rev | cut -c  2- | rev`
gunzip -c /home/Bowei/GWAS1/chr1/chr1.block${i}.dosage.gz | cut -f `echo "1,2,3,4,5,$refInd"` > refBlock${i}
Rscript commonSNPInx.R ${i}
# Jump the first two column (IDs, and label 'DOSE')
sta=$((`head -1 inxDataBlock${i}.txt | cut -f 1`+2))
end=$((`tail -1 inxDataBlock${i}.txt | cut -f 1`+2))

# This file contains at least the corresponding Block
cut -f $sta-$end $fileNeedPar > 400commonDataBlock${i}.txt

# Fast way to choose the selected rows
paste inxRefBlock${i}.txt refBlock${i} |awk '$1 == "TRUE"' | cut -f 2- > 400commonRefBlock${i}.txt
 
echo "Block $i is done"

