# Calculate concordance of each block parallely
# input the subsetted data and subsetted reference
# take each snps and compare if they rounded to the same integer
# Output has SNP name and the concordance


library('doMC')
library('foreach')
library('data.table')
registerDoMC(40) # This better matched with PBS file setup:  PBS -l nodes=1:ppn=30

args=(commandArgs(TRUE))
k = as.character(args[1]) # block number

  snpD1 = fread(paste0('400commonDataBlock',k,'.txt'),header=F,stringsAsFactors = F,sep='\t')
print('My Data read')
  snpRef = fread(paste0('400commonRefBlock',k,'.txt'),header=F,stringsAsFactors = F,sep='\t')
print('Ref file read')
  snpD1name = fread(paste0('inxDataBlock',k,'.txt'),header=F,stringsAsFactors = F,sep='\t')
  snpD1name[,inx:=snpD1name$V1-as.numeric(snpD1name[1,1,with=F])+1]
  #n=2355442 # No. of SNPs we have 
  conRate = NULL;
print('ready for concordance')
getCon = function(co,ref){
    d1=2-co
    d2 = as.numeric(ref[,-c(1:5),with=F])
    return(c(snp=as.character(ref[,2,with=F]),concord=sum(round(d1) == round(d2))/400))
  }

conList = foreach(i = 1:dim(snpD1name)[1],.combine=rbind) %dopar% {
   getCon(co = snpD1[,snpD1name$inx[i],with=F],ref=snpRef[i,])
}
print(paste0('Concordance for block ',k,' calculated'))
write.table(conList,paste0('Concord_block',k,'.txt'),quote=F,col.names=F,row.names=F)  
