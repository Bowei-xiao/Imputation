# Helper file for Schwarzian Transformation 
# Used for own data to get the same order as Paul's data
# would return the Ind names and the Inx in Paul's file and my file
# inxRef was the index in Paul's data (phenotype.gwas1.csv)
# indDat was the index for reordering (although the output was following the original ordering)
# Sample output:
# IID inxRef inxDat
#GC3140_03 2351 1
#JH0001_04 2703 201


library('data.table')
args=(commandArgs(TRUE))
file=as.character(args[1])
  

  newOrder = read.table(file,header=F,stringsAsFactors = F)[,1]
  orders= do.call(rbind,mapply(FUN=function(t) strsplit(t,split='->'), newOrder))
  rownames(orders)=NULL; colnames(orders) = c('FID','IID')
  orders = as.data.frame(orders,stringsAsFactors=F)
  refInd = read.csv('/home/Bowei/GWAS1/phenotype.gwas1.csv',header=T,stringsAsFactors = F)
  s = which(refInd$IID %in% orders$IID)
  t1 = cbind(s,refInd$IID[s])
  t2 = cbind(rownames(orders),as.data.frame(orders$IID),stringsAsFactors=F)
  colnames(t1) = c('inxRef','IID');colnames(t2) = c('inxDat','IID')
  t = merge(t1,t2,sort=F)
  #t = t[order(t$inxRef),]
  t = t[order(as.numeric(t$inxDat)),]
  t$inxDat = rownames(t)
  write.table(t, '400dataIndOrdering.txt',quote = F,row.names = F,col.names = T)
