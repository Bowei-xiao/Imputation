library('data.table')
args=(commandArgs(TRUE))
file=as.character(args[1])

dat = fread(file,stringsAsFactors = F,sep='\t')
snpInfo = dat[,1:5,with=F]
getIndDose= function(i){
  k = mapply(FUN=function(t) strsplit(as.character(t),split=':')[[1]][2], dat[,i,with=F][[1]])
  names(k) = NULL;
  return(k)
  }
dsg=NULL;
for (i in (7:406)){
  k = getIndDose(i)
  dsg = cbind(dsg,k)
}

AR = mapply(FUN=function(t) strsplit(as.character(t),split=';')[[1]][1], dat[,6,with=F][[1]])
names(AR)=NULL;
AR2 = mapply(FUN=function(t) strsplit(as.character(t),split='=')[[1]][2], AR)
names(AR2)=NULL;
write.table(cbind(AR2,snpInfo,dsg),'FormattedBlock1Dosage.txt',sep='\t',quote=F,row.names = F,col.names = F)
