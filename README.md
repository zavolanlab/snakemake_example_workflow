# Info

Snakemake example workflow

# Installation

Install miniconda (Optional) (You can find correct version from https://docs.conda.io/en/latest/miniconda.html) 
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

Create a virtual environment with snakemake
```bash
conda create -n snakemake -c bioconda -c conda-forge snakemake=5.8.1
```

Download the repo
```bash
git clone https://github.com/zavolanlab/snakemake_example_workflow.git
cd snakemake_example_workflow
```

# Run workflow

Activate the virtual environment
```bash
conda activate snakemake
```

Create the dag
```bash
bash create_dag.sh
```

Run workflow
```bash
bash run_local.sh
```
