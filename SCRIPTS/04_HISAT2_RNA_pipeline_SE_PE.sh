#!/bin/bash
#PBS-l nodes=2
#PBS-l walltime=1000:00:00
#PBS -j oe

set -e
echo "START" $(date)

# 8_5_17

module load HISAT2/2.0.4-foss-2016b   
module load SAMtools/1.3.1-foss-2016b

#HISAT2 code

#Indexing a reference genome and no annotation file
	#create new directory for the HISAT index called genome, and put the genome inside it
	# copy all reads files into this directory as well to ensure easy access by commands
cd /data3/marine_diseases_lab/erin/Bio_project_SRA/pipeline_files
F=/data3/marine_diseases_lab/erin/Bio_project_SRA/pipeline_files

hisat2-build -f /data3/marine_diseases_lab/erin/Bio_project_SRA/pipeline_files/Crassostrea_gigas_genome.fa  genome_index

# -f indicates that the reference input files are FASTA files

#Stay in the directory created in the previous step

#Aligning paired end reads
array1=($(ls $F/*_1.fq))

for i in ${array1[@]}; do
	hisat2 --dta -x /data3/marine_diseases_lab/erin/Bio_project_SRA/pipeline_files/genome_index  -1 ${i} -2 $(echo ${i}|sed s/_1/_2/) -S ${i}.sam
done
 	#don't need -f because the reads are fastq
	# put -x before the index
	# --dta : Report alignments tailored for transcript assemblers including StringTie.
	 #With this option, HISAT2 requires longer anchor lengths for de novo discovery of splice sites. 
	 #This leads to fewer alignments with short-anchors, which helps transcript assemblers improve significantly in computation and memory usage.

#Aligning single end reads
array2=($(ls $F/*.fq))

for i in ${array2[@]}; do
        hisat2 --dta -x /data3/marine_diseases_lab/erin/Bio_project_SRA/pipeline_files/genome_index -U ${i} -S ${i}.sam
        echo "${i}_DONE"
done
	
This runs the HISAT2 aligner, which aligns a set of unpaired reads to the genome region using the index generated in the 


#SAMTOOLS sort to convert the SAM file into a BAM file to be used with StringTie
array3=($(ls $F/*.sam))

for i in ${array3[@]}; do
	samtools sort -o ${i}.bam ${i}
	echo "${i}_convert"
done

#put -o before the out.bam and

#SAMTOOLS filter out for only uniquely mapped reads from bam results
#"samtools view -q 10 input > filtered_output

or sam/bam | fgrep -w NH:i:1


	
#reference: Transcript-level expression analysis of RNA-seq experiments with HISAT, StringTie, and Ballgown
