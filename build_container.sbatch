#!/bin/bash
#SBATCH -J build_spfsplat
#SBATCH -o build_spfsplat.out
#SBATCH -e build_spfsplat.err
#SBATCH -t 2:00:00
#SBATCH --nodes 1
#SBATCH --cpus-per-task 1
#SBATCH --ntasks 1
#SBATCH --mem=16G
#SBATCH --gres=gpu:H100:1
#SBATCH --nodelist=node-gpu02
# Try node-gpu02 (other H100 node) to avoid filled /tmp on node-gpu01
# If this fails, try: --nodelist=node-gpu03 (H200 node)

# Set up directories on /scratch for temporary files
SCRATCH_TMP=/scratch/$USER/apptainer_build
mkdir -p $SCRATCH_TMP

# Set environment variables for pip and temp files
export TMPDIR=$SCRATCH_TMP
export TEMP=$SCRATCH_TMP
export TMP=$SCRATCH_TMP
export PIP_CACHE_DIR=$SCRATCH_TMP/pip_cache
mkdir -p $PIP_CACHE_DIR

# Change to project directory
cd $SLURM_SUBMIT_DIR

# Build the container with tmpdir pointing to /scratch
apptainer build --tmpdir $SCRATCH_TMP --nv spfsplat.sif spfsplat_working.def

# Check if build was successful
if [ -f spfsplat.sif ]; then
    echo "SUCCESS: Container built successfully!"
    ls -lh spfsplat.sif
else
    echo "FAILED: Container file not found"
    exit 1
fi

