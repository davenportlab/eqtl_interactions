args<-commandArgs(TRUE)

load(args[1])
irange<-args[2]:args[3]

results<-do.call(rbind, lapply(irange, function(i){

#If at least one PC of gene expression should be included
  if (args[4]>0) {

    model <- lm(exp[,pairs.eqtl[i,1]] ~
      geno[,pairs.eqtl[i,2]] +
      exp.pcs[,1:args[4]] +
      geno.pcs[,1:6])

#If no PCs of gene expression should be included
  } else {

    model <- lm(exp[,pairs.eqtl[i,1]] ~
      geno[,pairs.eqtl[i,2]] +
      geno.pcs[,1:6])
  }


  summary(model)$coefficients[2,]


}))

colnames(results)<-c("eQTL_beta", "eQTL_SE", "eQTL_t", "eQTL_pval")

results <- data.frame(
    Gene = pairs.eqtl[irange, 1],
    SNP = pairs.eqtl[irange, 2],
    results
)
saveRDS(results, args[5])
