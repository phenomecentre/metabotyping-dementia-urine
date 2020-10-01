## ---------------------------------------------------------------------------------------------------------------------------------------------
##                                      Dementia cohort - urine - peakPantheR RPOS assay
## ---------------------------------------------------------------------------------------------------------------------------------------------

# Import peakPantheR package
library(peakPantheR)

# Load function to parse the National Phenome Centre filenames and extract sample types
source('parse_IPC_project_folder.R')

# path to mzML files - Must be downloaded from Metabolights
rawData_folder  <- './path_to_mzML'
# reference csv file
reference_ROI   <- '../LC-MS Annotations/ROI Files/RPOS_ROI.csv'
# Internal Standards ROI csv file

project_name <- 'Dementia'

# parse the file names
project_files <- parse_IPC_MS_project_names(rawData_folder, 'U')

files_all <- project_files[[1]]
metadata_all <- project_files[[2]]

# Select only quality control samples
which_QC <- metadata_all$sampleType %in% c('LTR', 'SR')

## ROI (regions of interest)
tmp_ROI       <- read.csv(file=reference_ROI, stringsAsFactors=FALSE, encoding='utf8')
ROI           <- tmp_ROI[,c("cpdID", "cpdName", "rtMin", "rt", "rtMax", "mzMin", "mz", "mzMax")]

# working directory
work_dir  <- '../LC-MS Annotations/peakPantheR Urine RPOS/'

#---------------------------------------------------------------------------------------------------------
# Example peakPantheR Workflow
#---------------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------------
# Step 1. Run peakPantheR with the default ROI files. 
# For faster run-time and to facilitate review, only quality control samples (study reference/SR and Long
# term reference/LTR) will be analysẽd
# These have wide (+- 15 seconds) retention time intervals, and will be saved as "wideWindows_annotation"
#---------------------------------------------------------------------------------------------------------
# setp up the peakPantheRAnnotation object
data_annotation_wideWindows <- peakPantheRAnnotation(spectraPaths=files_all[which_QC], targetFeatTable=ROI, spectraMetadata=metadata_all[which_QC, ])
# run the annotation
data_result_wideWindows     <- peakPantheR_parallelAnnotation(data_annotation_wideWindows, ncores=18, resetWorkers=30, verbose=TRUE )
## Save results in .Rdata file
save(data_result_wideWindows, file=file.path(work_dir, 'wideWindows_annotation_result.RData'), compress=TRUE)
# run the automated diagnostic method
data_annotation_wideWindows   <- data_result_wideWindows$annotation
updated_annotation  <- annotationParamsDiagnostic(data_annotation_wideWindows, verbose=TRUE)

# Save to disk ROI parameters (as csv) and diagnostic plot for each compound
uniq_sType    <- c('SR', 'LTR', 'SRD', 'SS', 'Mix')
uniq_colours  <- c('green', 'orange', 'red', 'dodgerblue3', 'darkgreen')
col_sType     <- unname( setNames(c(uniq_colours),c(uniq_sType))[spectraMetadata(updated_annotation)$sampleType] )

outputAnnotationDiagnostic(updated_annotation, saveFolder=file.path(work_dir, 'wideWindows_annotation_SR_LTR/'), savePlots=TRUE, sampleColour=col_sType, verbose=TRUE, ncores=8)
outputAnnotationResult(updated_annotation, saveFolder=file.path(work_dir, 'wideWindows_annotation_SR_LTR'), annotationName=paste(project_name, '_wideWindows'), verbose=TRUE)
#---------------------------------------------------------------------------------------------------------
# 2. Repeat the process using the automatic uROI suggestion calculated using the 
# annotationParamsDiagnostic method. 
# For faster run-time and to facilitate review, only quality control samples (study reference/SR and Long
# term reference/LTR) will be analysẽd
# This run will be saved as  "narrowWindows_annotation"
#---------------------------------------------------------------------------------------------------------
# load the csv exported from the "wideWindows" run
update_csv_path     <- file.path(work_dir, './wideWindows_annotation_SR_LTR/annotationParameters_summary.csv')
# setp up the peakPantheRAnnotation object
narrowWindows_annotation <- peakPantheR_loadAnnotationParamsCSV(update_csv_path)

# add samples
narrowWindows_annotation  <- resetAnnotation(narrowWindows_annotation, spectraPaths=files_all[which_QC], spectraMetadata=metadata_all[which_QC,], useUROI=TRUE, useFIR=TRUE)
# run the annotation
narrowWindows_annotation_results  <- peakPantheR_parallelAnnotation(narrowWindows_annotation, ncores=18, resetWorkers=30, verbose=TRUE)

## Save results in .Rdata file
save(narrowWindows_annotation_results, file=file.path(work_dir, 'narrowWindows.RData'), compress=TRUE)
# run the automated diagnostic method
narrowWindows_annotation  <- narrowWindows_annotation_results$annotation
narrowWindows_annotation  <- annotationParamsDiagnostic(narrowWindows_annotation, verbose=TRUE)

# Save to disk ROI parameters (as csv) and diagnostic plot for each compound
uniq_sType    <- c('SR', 'LTR', 'SRD', 'SS')
uniq_colours  <- c('green', 'orange', 'red', 'dodgerblue3')
col_sType     <- unname( setNames(c(uniq_colours),c(uniq_sType))[spectraMetadata(narrowWindows_annotation)$sampleType] )

outputAnnotationDiagnostic(narrowWindows_annotation, saveFolder=file.path(work_dir, 'narrowWindows_annogation_SR_LTR/'), savePlots=TRUE, sampleColour=col_sType, verbose=TRUE, ncores=8)
outputAnnotationResult(narrowWindows_annotation, saveFolder=file.path(work_dir, 'narrowWindows_annotation_SR_LTR'), annotationName=paste(project_name, '_narrowWindows'), verbose=TRUE)

#--------------------------------------------------------------------------------------------------
# Final run
# After reviewing the uROI windows from the previous run, integration of all
# samples is performed to generate the final dataset 
# This or any of the previous steps can be repeated as desired.
#--------------------------------------------------------------------------------------------------
# load the csv exported from the "narrowWindows" run, either as exported or after manual adjustments. 
# In this example, the file was manually optimised and 
# saved as "annotationParameters_summary_final_ALL.csv"
# Manual modifications to this file 
update_csv_path     <- file.path('./PP Urine RPOS ppR paper/annotationParameters_summary_final_ALL.csv')
final_annotation <- peakPantheR_loadAnnotationParamsCSV(update_csv_path)
# add samples
final_annotation  <- resetAnnotation(final_annotation, spectraPaths=files_all, spectraMetadata=metadata_all, useUROI=TRUE, useFIR=TRUE)
# run the annotation
final_annotation_results  <- peakPantheR_parallelAnnotation(final_annotation, ncores=12, resetWorkers=30, verbose=TRUE)
## Save results in .Rdata file
save(final_annotation_results, file=file.path(work_dir, 'final_bySampleType_ALL.RData'), compress=TRUE)
# run the automated diagnostic method
final_annotation  <- final_annotation_results$annotation
final_annotation  <- annotationParamsDiagnostic(final_annotation, verbose=TRUE)

# Save to disk ROI parameters (as csv) and diagnostic plot for each compound
uniq_sType    <- c('SR', 'LTR', 'SRD', 'SS')
uniq_colours  <- c('green', 'orange', 'red', 'dodgerblue3')
col_sType     <- unname( setNames(c(uniq_colours),c(uniq_sType))[spectraMetadata(final_annotation)$sampleType] )

outputAnnotationDiagnostic(final_annotation, saveFolder=file.path(work_dir, 'final_annotation_bySampleType_ALL'), savePlots=TRUE, sampleColour=col_sType, verbose=TRUE, ncores=12)
outputAnnotationResult(final_annotation, saveFolder=file.path(work_dir, 'final_results_bySampleType_ALL'), annotationName=paste(project_name, 'final'), verbose=TRUE)

