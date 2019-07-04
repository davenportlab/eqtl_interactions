library(lme4)
args<-commandArgs(TRUE)

load(args[1])
irange<-args[2]:args[3]

results<-do.call(rbind, lapply(irange, function(i){

#If at least one PC of gene expression should be included
  if (args[4]>0) {
    model.null <- lmer(exp[,pairs.eqtl[i,1]] ~
      exp.pcs[,1:args[4]] +
      geno.pcs[,1:6] +
      (1|subject),
      REML=FALSE)


    model.test <- lmer(exp[,pairs.eqtl[i,1]] ~
      geno[,pairs.eqtl[i,2]] +
      exp.pcs[,1:args[4]] +
      geno.pcs[,1:6] +
      (1|subject),
      REML=FALSE)

#If no PCs of gene expression should be included
  } else {
    model.null <- lmer(exp[,subject[i,1]] ~
      geno.pcs[,1:6] +
      (1|subject),
      REML=FALSE)


    model.test <- lmer(exp[,pairs.eqtl[i,1]] ~
      geno[,pairs.eqtl[i,2]] +
      geno.pcs[,1:6] +
      (1|subject),
      REML=FALSE)
  }

#If there are no missing genotypes
  if (all(complete.cases(geno[,pairs.eqtl[i,2]]))){
    c(summary(model.test)$coefficients[2,],
    anova(model.null, model.test)$'Pr(>Chisq)'[2])

#Update the models if there are missing genotypes
  } else {
      model.null.subset<-update(model.null, subset=complete.cases(geno[,pairs.eqtl[i,2]]))
      model.test.subset<-update(model.test, subset=complete.cases(geno[,pairs.eqtl[i,2]]))
      c(summary(model.test.subset)$coefficients[2,],
      anova(model.null.subset, model.test.subset)$'Pr(>Chisq)'[2])
  }


}))

colnames(results)<-c("eQTL_beta", "eQTL_SE", "eQTL_t", "eQTL_pval")

results <- data.frame(
    Gene = pairs.eqtl[irange, 1],
    SNP = pairs.eqtl[irange, 2],
    results
)
saveRDS(results, args[5])
