#! /bin/bash
# Parameters for slurm (don't remove the # in front of #SBATCH!)
#  Use partition short-term:
#SBATCH --partition=shortterm
#  Use one node:
#SBATCH --nodes=1
#  Request 10 cores (hard constraint):
#SBATCH -c 10
#  Request 100GB of memory (hard constraint):
#SBATCH --mem=100GB
#  Request one day maximal execution time (hard constraint):
#SBATCH --time=1-0:0:0
#  Request 100 GB of local scratch disk (hard constraint):
#SBATCH --tmp=100G
#  Notify me at job start and end:
#SBATCH --mail-type=ALL
#  Find your job easier with a name:
#SBATCH --job-name=MGS
#Initialize the module system:
source /etc/profile.d/modules.sh
# Allow aliases (required by some modules):
shopt -s expand_aliases
# Load your necessary modules (example):
module load plink2/2_alpha_20210826
module load plink/1.90_beta_6.21

# Calculate the MGS with PLINK score function

plink2 \
    --bfile $1 \
    --set-all-var-ids @:#:\$1:\$2 \
    --make-bed --allow-extra-chr --new-id-max-allele-len 400 \
    --out $1.new_ID

plink --bfile $1.new_ID \
    --score MGS_HG19.profile.raw 1 2 3 header \
    --out $1.MGS_HG19







