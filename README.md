# Conducting eQTL interaction analysis

## Preparing the data files
All files should be created using the same order of samples

### Gene expression
- Samples in rows
- Genes in columns
- Normalised read counts e.g. log2(cpm1+1)

### Principal components of gene expression
- Samples in rows
- Value for PCs in columns

### Genotyping
- Samples in rows
- SNPs in columns
- Coded as 0, 1 and 2 (number of copies of the minor allele)

### Principal components of genotyping
- Samples in rows
- Value for PCs in columns

### Environmental factors
- Samples in rows
- Value for each environmental factor in columns

### SNP gene pairs to test
- Gene name in first column
- SNP name in second column



# Example

Using the following objects

`exp` gene expression data

`exp.pcs` principal components of expression

`geno` genotying data     

`geno.pcs` principal components of genotyping

`int.terms` environmental factors to test for interaction (e.g. IFN and drug)     

`pairs.eqtl` gene-SNP pairs to test for eQTL

`pairs.int` gene-SNP pairs to test for interaction (most significant SNP for each eQTL gene)

`subject` subject ID to indicate which samples are from which individuals


The `eqtl_lmm.R` script requires 5 arguments: the .rda file to load (containing all the objects), the first and last gene-SNP pair to run in the analysis, the number of gene expression principal components to include and the output file name.

This allows batches of gene-SNP pairs to be run.

For example, to run the first 10 gene-SNP pairs with 25 principal components of gene expression

`Rscript eQTL_lmm.R eqtl_files.rda 1 10 25 results_eqtl.rds`

The `eQTL_interaction_lmm.R` script requires 5 arguments: the .rda file to load (containing all the objects), the first and last gene-SNP pair to run in the analysis, the environmental factor to test for an interaction and the output file name.
µ
For example to run the first 10 gene-SNP pairs to test for an interaction with IFN

`Rscript eQTL_interaction_lmm.R eqtl_files.rda 1 10 IFN results_interaction_IFN.rds`
