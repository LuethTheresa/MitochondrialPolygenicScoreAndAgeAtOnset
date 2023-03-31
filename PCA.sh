#! /bin/bash
# Parameters for slurm (don't remove the # in front of #SBATCH!)
#  Use partition debug:
#SBATCH --partition=shortterm
#  Use one node:
#SBATCH --nodes=1
#  Request 10 cores (hard constraint):
#SBATCH -c 30
#  Request 10GB of memory (hard constraint):
#SBATCH --mem=50GB
#  Request one hour maximal execution time (hard constraint):
#SBATCH --time=3-0:0:0
#  Request 100 GB of local scratch disk (hard constraint):
#SBATCH --tmp=100G
#  Notify me at job start and end:
#SBATCH --mail-type=ALL
#  Find your job easier with a name:
#SBATCH --job-name=PCA

module load plink/1.90_beta_6.21
module load plink2/2_alpha_20200124

# Rename all SNPs and filter for MAF > 0.3
plink2 --bfile $1 \
--maf 0.3 \
--allow-extra-chr --allow-no-sex \
--set-all-var-ids @:#:\$1:\$2 \
--new-id-max-allele-len 800 \
--make-bed \
--out $1.MAF_newSNPID

plink2 --bfile $2 \
--maf 0.3 \
--allow-extra-chr --allow-no-sex \
--set-all-var-ids @:#:\$1:\$2 \
--new-id-max-allele-len 800 \
--make-bed \
--out $2.MAF_newSNPID

# Make list with overlapping SNPs from both datasets

cat $1.MAF_newSNPID.bim | awk '{print $2}' \
| sort > $1.MAF_newSNPID.txt

cat $2.MAF_newSNPID.bim | awk '{print $2}' \
| sort > $2.MAF_newSNPID.txt

comm -12 $1.MAF_newSNPID.txt $2.MAF_newSNPID.txt \
> SNPs_overlap.txt

# Extract overlapping SNPs

plink2 --bfile $1.MAF_newSNPID \
--allow-extra-chr --allow-no-sex \
--extract SNPs_overlap.txt --make-bed \
--out $1.MAF_newSNPID_overlap

plink2 --bfile $2.MAF_newSNPID \
--allow-extra-chr --allow-no-sex \
--extract SNPs_overlap.txt --make-bed \
--out $2.MAF_newSNPID_overlap

# Merge both datasets

echo $2.MAF_newSNPID_overlap > merge.txt

plink --bfile $1.MAF_newSNPID_overlap \
--merge-list merge.txt \
--allow-no-sex --allow-extra-chr --make-bed \
--out 1000k_study_cohort

# Filter merged datasets

plink --bfile 1000k_study_cohort \
--maf 0.3 \
--allow-no-sex --allow-extra-chr --make-bed \
--out 1000k_study_cohort_maf

plink --bfile 1000k_study_cohort_maf \
--geno 0.01 \
--allow-no-sex --allow-extra-chr --make-bed \
--out 1000k_study_cohort_maf_geno

plink --bfile 1000k_study_cohort_maf_geno \
--indep-pairwise 50 10 0.3 \
--allow-no-sex --allow-extra-chr --make-bed \
--out 1000k_study_cohort_maf_geno_prune

plink --bfile 1000k_study_cohort_maf_geno_prune \
--extract 1000k_study_cohort_maf_geno_prune.prune.in \
--allow-no-sex --allow-extra-chr --make-bed \
--out 1000k_study_cohort_maf_geno_prune_in

# Perform PCA on merged and filtered datasets

plink2 --bfile 1000k_study_cohort_maf_geno_prune_in --pca --allow-extra-chr --out 1000k_study_cohort

# Add ne column to color the PCA plot in R according to populations 
awk 'NR==FNR {h[$1] = $2; next} {print $0,h[$2]}'  1000kpopulations.txt 1000k_study_cohort.eigenvec | sed -e 's/ /\t/g' | sed -e "s/\t$/\t$2/g" > 1000k_study_cohort.PCA_plot.eigenvec