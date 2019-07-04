library(lme4)
args<-commandArgs(TRUE)

load(args[1])
irange<-args[2]:args[3]

results<-do.call(rbind, lapply(irange, function(i){


    model.null <- lmer(exp[,pairs.int[i,1]] ~
      geno[,pairs.int[i,2]] +
      as.factor(int.terms[,args[4]]) +
      exp.pcs[,1:25] +
      geno.pcs[,1:5] +
      (1|subject),
      REML=FALSE)


    model.test <- lmer(exp[,pairs.int[i,1]] ~
      geno[,pairs.int[i,2]] +
      as.factor(int.terms[,args[4]]) +
      geno[,pairs.int[i,2]] * as.factor(int.terms[,args[4]]) +
      exp.pcs[,1:25] +
      geno.pcs[,1:5] +
      (1|subject),
      REML=FALSE)


      c(summary(model.test)$coefficients[2,],
        summary(model.test)$coefficients[3,],
        summary(model.test)$coefficients[dim(summary(model.test)$coefficients)[1],],
        anova(model.null, model.test)$'Pr(>Chisq)'[2])



}))

colnames(results)<-c("eQTL_beta", "eQTL_SE", "eQTL_t", "DE_beta", "DE_SE", "DE_t", "Interaction_beta", "Interaction_SE", "Interaction_t", "Interaction_pval")

results <- data.frame(
    Gene = pairs.int[irange, 1],
    SNP = pairs.int[irange, 2],
    results
)
saveRDS(results, args[5])
