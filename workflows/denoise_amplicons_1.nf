/*
 * WORKFLOW - DENOISE_AMPLICONS_1
 * 
 * This workflow uses DADA2 to denoise amplicons
 */


include { DADA2_ANALYSIS } from '../modules/local/dada2_analysis.nf'
include { COLLAPSE_CONCATENATED_READS } from '../modules/local/collapse_concatenated_reads.nf'

workflow DENOISE_AMPLICONS_1 {

  take:
  demultiplexed_fastqs

  main:

  DADA2_ANALYSIS(
    demultiplexed_fastqs.collect(),
    params.amplicon_info,
    params.pool,
    params.band_size,
    params.omega_a,
    params.maxEE,
    params.just_concatenate
  )

  // Custom code to further denoise sequences
  // generated by DADA2
  if (params.just_concatenate) {
    COLLAPSE_CONCATENATED_READS(
      DADA2_ANALYSIS.out.dada2_clusters
    )
  }

  emit: 
  denoise_ch = params.just_concatenate ? 
    COLLAPSE_CONCATENATED_READS.out.clusters_concatenated_collapsed : 
    DADA2_ANALYSIS.out.dada2_clusters
}

