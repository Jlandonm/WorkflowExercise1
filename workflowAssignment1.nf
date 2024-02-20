
params.reads = "$projectDir/Data/subset_ERR8051742_{1,2}.fastq.gz"

/*
Trimming Process

Takes in a tuple the sample id and path to paired read files
Runs trimmomatic on samples and outputs path to trimmed fastq files

*/
process TRIM {
    conda 'trimmomatic'

    input:
    tuple val(sample_id), path(reads)

    output:
    path "${sample_id}*.fq.gz"

    script:
    """
    trimmomatic PE -phred33 ${reads[0]} ${reads[1]} ${sample_id}_r1_paired.fq.gz ${sample_id}_r1_unpaired.fq.gz ${sample_id}_r2_paired.fq.gz ${sample_id}_r2_unpaired.fq.gz SLIDINGWINDOW:5:30 AVGQUAL:30 CROP:145 1> trimmo.stdout.log 2> trimmo.stderr.log
    """
}

/*
Assembly Process

Takes in a the trimmed reads and the sample id for each file
Runs spades on samples and outputs path to final contig file

*/
process ASSEMBLY {
    conda 'python=3.9.0 spades=3.15.2'

    input:
    path trimmed_reads
    tuple val(sample_id), path(reads)

    output:
    path "${sample_id}/contigs.fasta"

    script:
    """
    spades.py --pe1-1 ${trimmed_reads[0]} --pe1-2 ${trimmed_reads[2]} --isolate -o ${sample_id}/
    """

}

workflow {

    read_pairs_ch = Channel.fromFilePairs(params.reads)
    trim_ch = TRIM(read_pairs_ch)
    trim_ch.view { it }

    assembly_ch = ASSEMBLY(trim_ch, read_pairs_ch)
    assembly_ch.view { it }

}

