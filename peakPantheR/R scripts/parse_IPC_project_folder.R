# Utility codes file to parse filepath and sample names, assuming the IPC naming convention was followed.
parse_IPC_MS_project_names <- function(rawData_folder, matrix, parseRunOrder=FALSE) {

  ## Find files and only keep SR & LTR
  raw_files   <- list.files(rawData_folder, full.names=TRUE, pattern='.mzML')

  # remove some specific samples
  SR_files    <- regmatches(raw_files, regexpr(paste('.*?_', matrix, '([0-9]*)W([0-9]*).*?_SR(.*).mzML$', sep=''), raw_files))
  LTR_files   <- regmatches(raw_files, regexpr(paste('.*?_', matrix, '([0-9]*)W([0-9]*).*?_LTR(.*).mzML$', sep=''), raw_files))
  BES_files    <-regmatches(raw_files, regexpr('.*?B([0-9]*)([E|S]{1})([0-9])(.*).mzML$', raw_files))
  
  Mix_files <- regmatches(raw_files, regexpr('.*?Mix(.*).mzML$', raw_files))
  BES_files <- BES_files[!(BES_files %in% Mix_files)]
  
  MR_files   <- regmatches(raw_files, regexpr(paste('.*?_', matrix, '([0-9]*)W([0-9]*).*?_MR(.*).mzML$', sep=''), raw_files))

  SRD_files   <- regmatches(raw_files, regexpr('.*?SRD(.*).mzML$', raw_files))
  QC_files    <- c(Mix_files, SR_files, LTR_files, SRD_files, BES_files, MR_files)
  SS_files    <- regmatches(raw_files, regexpr(paste('.*?_', matrix, '([0-9]*)W([0-9]*)(.*).mzML$', sep=''), raw_files))
  SS_files    <- SS_files[!(SS_files %in% QC_files)]
  all_files   <- c(Mix_files, BES_files, SR_files, MR_files, LTR_files, SRD_files, SS_files)

  # Assemble the metadata
  tmp_sampleType  <- c(rep('Mix', length(Mix_files)), rep('SR', length(BES_files)), rep('SR', length(SR_files)), rep('MR', length(MR_files)), rep('LTR', length(LTR_files)), rep('SRD', length(SRD_files)), rep('SS', length(SS_files)))
  tmp_sampleFileName <- c(Mix_files, BES_files, SR_files, MR_files, LTR_files, SRD_files, SS_files)

  if (parseRunOrder == TRUE) {
      acqTime <- do.call(c, lapply(all_files, FUN=getAcquisitionDatemzMLFast))
      origRunOrder <- order(as.POSIXct(acqTime))
      
      meta_files <- data.frame(sampleFileName=tmp_sampleFileName, sampleType = tmp_sampleType, acquisitionTime = acqTime, runOrder = seq(1, length(origRunOrder)), stringsAsFactors = FALSE)
      meta_files <- meta_files[origRunOrder , ]
      
      indexes <- seq(2, dim(meta_files)[1])
      time_delta <- sapply(indexes, FUN=function(x){difftime(meta_files$acquisitionTime[x], meta_files$acquisitionTime[x-1], unit='hours')})
      
      cBatch <- 1
      batchVec <- rep(1, length(all_files))

      for (idx in 2:length(time_delta)) {

          if (time_delta[idx] > 12) {
              cBatch <- cBatch + 1
          }

         batchVec[idx] <- cBatch
      }
    
   all_files <- all_files[runOrder]

   } else {  meta_files <- data.frame(sampleFileName=tmp_sampleFileName, sampleType = tmp_sampleType, stringsAsFactors = FALSE) } 
  
  return(list(files=all_files, metadata=meta_files))
}


cBatch <- 1
batchVec <- rep(1, length(all_files))

for (idx in 2:length(time_delta)) {

    if (time_delta[idx] > 3) {
        cBatch <- cBatch + 1
       }
    
    batchVec[idx] <- cBatch
}



getAcquisitionDatemzMLFast <- function(mzMLPath, verbose = TRUE, tag='StartTimeStamp') {
    ## Greedy mzML parser
    ## Check input
    mzMLPath <- normalizePath(mzMLPath, mustWork = FALSE)
    # not a mzML extension
    if (tolower(stringr::str_sub(basename(mzMLPath), start = -5)) != ".mzml") {
        if (verbose) {
            message("Check input, mzMLPath must be a .mzML")
        }
        return(NA)
    }
    
    stime <- Sys.time()
    ## Parse file
    fileBuffer <- file(mzMLPath, "r")
    acqTime <- tryCatch({
        ## read file line by line

        while (TRUE ) {
            lines = readLines(fileBuffer, n = 100)
            # file reached the end
            if ( length(lines) == 0 ) {  break  }
             
            matchedTag <- regexpr('(?<=startTimeStamp=\").*?(?=")', lines, perl=TRUE)
        
            if (any(matchedTag) > -1) {
                
                whereMatched <- min(which(matchedTag > -1))
		matchStart <- matchedTag[whereMatched]
                matchEnd <- matchStart + attr(matchedTag, "match.length")[whereMatched] - 1

                acqTime <- strptime(substr(lines[whereMatched], matchStart, matchEnd ), format = "%Y-%m-%dT%H:%M:%S")
                close(fileBuffer)
                return(acqTime)
                
                #break
            }

        }
        
    }, error = function(cond) {
        ## catch
        if (verbose) {
            message("Check input, failure while parsing mzMLPath")}
            return(NA)
    })
    ## Output
    etime <- Sys.time()
    if (verbose) {
        message("Acquisition date parsed in: ",
                round(as.double(difftime(etime, stime)), 2),
                " ", units(difftime(etime, stime)))
    }
    
    return(acqTime)
}

