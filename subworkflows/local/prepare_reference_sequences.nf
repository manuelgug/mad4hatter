
include { CREATE_REFERENCE_FROM_GENOMES } from '../../modules/local/create_reference_from_genomes.nf'

workflow PREPARE_REFERENCE_SEQUENCES {

  main:
  if (params.genome != null) {    

    def genome = params.genome

    if (params.genomes.containsKey(params.genome)) {
      genome = params.genomes[params.genome].fasta
    }

    CREATE_REFERENCE_FROM_GENOMES(
      genome,
      params.amplicon_info,
      "${params.target}_reference.fasta" // could allow this to be customizable
    )
  }

  emit:
  reference_ch = (params.refseq_fasta == null) ? 
    CREATE_REFERENCE_FROM_GENOMES.out.reference_fasta :
    params.refseq_fasta
}