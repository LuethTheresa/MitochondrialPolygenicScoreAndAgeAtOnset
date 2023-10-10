# **Interaction of mitochondrial polygenic score and lifestyle/environmental factors in LRRK2 p.Gly2019Ser parkinsonism**

Our study investigated the relationship between the mitochondrial polygenic score (MGS) and lifestyle/environmental data and its impact on age at onset in LRRK2 p.Gly2019Ser parkinsonism (*LRRK2*-PD) and idiopathic PD (iPD).
In this repository, we describe how the principal component analysis (PCA) was performed and visualized and how the MGS was calculated and its association with AAO was analyzed. All bash scripts were written for a slurm-based compute cluster.

## PCA

For the PCA we used the publicly available data of the 1000 Genomes Project as a reference. You will need all files unfiltered and unimputed and in binary PLINK format in the same folder as the script.
To perform the PCA, execute the PCA.sh script and replace the name of your files accordingly:

`PCA.sh NameOfThe1kGenomesPlinkFile NameOfTheStudyCohortPlinkFile`

For the visualization of the PCA, you need the resulting 1000k_study_cohort.PCA_plot.eigenvec and 1000k_study_cohort.eigenval files. The script adds a 13th column to your 1000k_study_cohort.eigenvec file including the 1000 Genomes Project super populations (i.e., AFR=African, EAS=East Asian, AMR=Ad Mixed American, EUR=European and SAS=South Asian) and the name of your study cohort for all the samples of that cohort.
You can customize this step as needed or leave the last line of the bash script as it is.

The scripts also result in some bigger intermediate PLINK files (for each filter step), which can be deleted but are very useful for troubleshooting.

Lastly, you will need to execute the R script to visualize the PCA clusters and you will get a PCA.tiff as a result. 

`PCA_visualize.R`

(Required packages: 'data.table', 'ggplot2', 'ggfortify')

## Calculation of the MGS

For this part, you need the bash script MGS_HG19.sh or MGS_HG38.sh (depending on your genome build)  and the qc-filtered (e.g., minor allele frequency >0.01, missingness per sample <0.02, missingness per SNP <0.05 and Hardy-Weinberg equilibrium >1×10-50) binary PLINK format files of your study cohort in the same folder. You will also need the MGS_HG19.profile.raw or MGS_HG38.profile.raw file containing the variants and weights of the MGS in the same folder. Execute the script with the following  command and replace “NameOfTheStudyCohortQCPlinkFile” accordingly:

`MGS_HG38.sh NameOfTheStudyCohortQCPlinkFile `

or

`MGS_HG19.sh NameOfTheStudyCohortQCPlinkFile `


The resulting profile file contains the calculated MGS for each sample. It is important to note that the notation of the MGS SNP IDs is in the format: CHR:POS:A1:A2. However, the script takes care of the renaming of the variant IDs in your PLINK file (e.g, rs numbers as IDs). If the order of A1 or A2 is different in your cohort PLINK file then you would need to rename the SNPs IDs in MGS_HG19.profile.raw.
To assess the association with e.g. AAO you can use the following R command, which also utilized the PCs 1-5 from the PCA analysis. Analogously you can use the R command to analyze the interaction with lifestyle factors.

`MGS <- glm(formula = AAO ~  MGS + Sex + PC1 + PC2 + PC3 + PC4 + PC5, family = gaussian, data = data)`

`summary(MGS)`

` MGS <- glm(formula = AAO ~  Lifestyle_Factor * MGS + Sex + PC1 + PC2 + PC3 + PC4 + PC5, family = gaussian, data = data) `

`summary(MGS)`


## Citation

Please cite our publication: 

*Interaction of Mitochondrial Polygenic Score and Lifestyle Factors in LRRK2 p.Gly2019Ser Parkinsonism*

Theresa Lüth, Carolin Gabbert, Sebastian Koch, Inke R König, Amke Caliebe, Björn-Hergen Laabs, Faycel Hentati, Samia Ben Sassi, Rim Amouri, Malte Spielmann, Christine Klein, Anne Grünewald, Matthew J Farrer, Joanne Trinh

Mov Disord. 2023 Jul 21, doi: 10.1002/mds.29563
