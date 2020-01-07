configfile: "config.yaml"

rule finish:
    input:
        counts=os.path.join(config["output_dir"], "counts.htseq.merged.tsv")

rule samtools_sort:
    input:
        bam=os.path.join(config["input_dir"], "{sample}.bam")
    output:
        bam=os.path.join(config["output_dir"], "{sample}.sorted.bam")
    singularity:
        "docker://zavolab/samtools:1.8"
    threads:    1
    log:
        os.path.join(config["local_log"], "samtools_sort_{sample}.log")
    shell:
        "(samtools sort {input.bam} > {output.bam}) &> {log}"

rule samtools_index:
    input:
        bam=os.path.join(config["output_dir"], "{sample}.sorted.bam")
    output:
        bai=os.path.join(config["output_dir"], "{sample}.sorted.bam.bai") 
    singularity:
        "docker://zavolab/samtools:1.8"
    threads:    1
    log:
        os.path.join(config["local_log"], "samtools_index_{sample}.log")
    shell:
        "(samtools index {input.bam} > {output.bai}) &> {log}"

rule HTSeq_count:
    input:
        bam=os.path.join(config["output_dir"], "{sample}.sorted.bam"),
        bai=os.path.join(config["output_dir"], "{sample}.sorted.bam.bai"),
        gtf=config["gtf"]
    output:
        counts=os.path.join(config["output_dir"], "{sample}.htseq.tsv")
    params:
        format="bam",
        order="pos",
        stranded="yes",
        type="exon",
        idattr="gene_id",
        mode="union"
    singularity:
        "docker://zavolab/python_htseq:3.6.5_0.10.0"
    threads:    1
    log:
        os.path.join(config["local_log"], "HTSeq_count_{sample}.log")
    shell:
        "(htseq-count \
        --format {params.format} \
        --order {params.order} \
        --stranded {params.stranded} \
        --type {params.type} \
        --idattr {params.idattr} \
        --mode {params.mode} \
        {input.bam} {input.gtf} > {output.counts}) &> {log}"

rule merge_results:
    input:
        counts=expand(os.path.join(config["output_dir"], "{sample}.htseq.tsv"), sample=config["samples"])
    output:
        counts=os.path.join(config["output_dir"], "counts.htseq.merged.tsv")
    singularity:
        "docker://zavolab/python_htseq:3.6.5_0.10.0"
    threads:    1
    log:
        os.path.join(config["local_log"], "merge_results.log")
    shell:
        "(paste {input.counts} | grep -v \"^_\" > {output.counts}) &> {log}"
