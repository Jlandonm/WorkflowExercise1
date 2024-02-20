# WorkflowExercise1
Workflow Exercise 1 for BIOL 7210

In this repo is a nextflow workflow to perform read trimming and assembly on a set of paired-end fastq files.

### Trimming:

Performed using trimmomatic

### Assembly:

Performed using SPAdes

### Special Notes:

The workflow finds the fastq reads from the Data directory, however, functionality has only been tested with one set of paired reads in the directory. Adding multiple pairs of fastq files may cause issues with my current implementation.
