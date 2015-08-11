# Helper function to get the indices of the common SNPs, and non-overlapping SNPs
# This script outputs 2 files: inxDataBlock${i}.txt -> delimiter ' ', has column inx of Dosage in 400dataALLSNPsamewithRef.txt 
#      and inxReflock${i}.txt -> delimiter "\n" T/F if its common
# inputs the block number

library('data.table')
args=(commandArgs(TRUE))
k=as.numeric(args[1])

dat=fread('400dataSNPpassR2.txt',header=F,stringsAsFactors=F)
setnames(dat,c('V1','V2'),c('Inx','SNP'))
refName = fread(paste0('refBlock',k), header=F,sep='\t',stringsAsFactors=F)$V2
dat[,common := dat$SNP %in% refName]

write.table(cbind(dat$Inx[which(dat$common)],dat$SNP[which(dat$common)]),paste0('inxDataBlock',k,'.txt'),quote=F,row.names = F,col.names = F,sep='\t')


write.table((refName%in% dat$SNP),paste0('inxRefBlock',k,'.txt'),quote=F,row.names = F,col.names = F)






