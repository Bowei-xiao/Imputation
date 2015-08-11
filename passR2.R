# Simple filter to filter out the SNP that passed R^2>=0.3 and MAF>=0.005
# Returned SNP inx in orignal file (400dataALLSNPsamewithRef.txt) and the name

library('data.table')
args=(commandArgs(TRUE))
file=as.character(args[1])

d = fread(file,header=T,data.table=F,sep='\t')
#inx = rownames(d[d$Rsq >=0.3,])
inx2 = rownames(d[d$Rsq >=0.3 & d$MAF>=0.005,])
snpsList = d[d$Rsq >=0.3 & d$MAF>=0.005,]
write.table(cbind(inx2, d$SNP[as.numeric(inx2)]),'400dataSNPpassR2.txt',quote=F,row.names = F,col.names = F)
