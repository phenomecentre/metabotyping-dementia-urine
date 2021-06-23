# Metabolic phenotyping of human urine biofluid samples from a dementia cohort.

This repository contains processed data outputs from a metabolic phenotyping 
study of urinary biomarkers for dementia and Alzheimer's disease. 

Baseline spot urine samples (first sample collected after recruitment to the study) were collected as part of the AddNeuroMed 
and ART/DCR study consortia, with the aim of identifying biomarkers of neurocognitive decline and Alzheimer’s disease. 
These samples were analysed by LC-MS and <sup>1</sup>H NMR, using the methods described by Lewis *et al*<sup>1</sup> 
and Dona *et al*<sup>2</sup>. Detailed information about this cohort and other available phenotypic measurements can 
be found in Lovestone *et al*<sup>3</sup> and the ANMERGE repository<sup>4</sup>, which can be accessed
via the [Sage BioNetworks portal](https://doi.org/10.7303/syn22252881).
Information about the metabolic profiling experiments can be found in the study's 
MetaboLights entry - [MTBLS719](https://www.ebi.ac.uk/metabolights/MTBLS719).

## Contents:
This repository contains supporting materials and worked tutorials/examples for the R package 
[peakPantheR](https://bioconductor.org/packages/peakPantheR/) and the Python package
[nPYc-Toolbox](https://github.com/phenomecentre/nPYc-Toolbox) <sup>5</sup>. The functionality of these tools is exemplified using 
the three LC-MS profiling assays described in Lewis *et al*<sup>1</sup>: reversed-phase chromatography with positive 
ionisation (RPOS), reversed-phase chromatography with negative ionisation (RNEG), and 
hydrophilic interaction liquid chromatography (HILIC) with positive ionisation (HPOS).

### Index
This repository has the following structure:

* **\Datasets**
    * **\peakPantheR** Final LC-MS datasets, ready for statistical analysis
* **\peakPantheR** 
    * **\LC-MS Annotations**
        * **\peakPantheR Urine RPOS/RNEG/HPOS** peakPantheR processing outputs
        * **\ROI files** Lists of compound annotations for the RPOS/RNEG/HPOS assays
        * **\R scripts** R scripts with examples of the peakPantheR workflow. **Note** Running these scripts requires the mzML files, which can be downloaded from [MTBLS719](https://www.ebi.ac.uk/metabolights/MTBLS719) <br>
* **\nPYc-Toolbox scripts** Jupyter Notebooks with the nPYc-Toolbox commands and parameters used to generate the files in the "Datasets" folder from the peakPantheR outputs.

Each of the directories contains a readme file with information about the accompanying files.

## References

<sup>1</sup> Lewis, M. R., Pearce, J. T. M., Spagou, K., Green, M., Dona, A. C., Yuen, A. H. Y., … Nicholson, J. K. (2016). Development and Application of Ultra-Performance Liquid Chromatography-TOF MS for Precision Large Scale Urinary Metabolic Phenotyping. Analytical Chemistry, 88(18), 9004–9013. https://doi.org/10.1021/acs.analchem.6b01481

<sup>2</sup> Dona et al: Dona AC, Jiménez B, Schäfer H, et al. Precision high-throughput proton NMR spectroscopy of human urine, serum, and plasma for large-scale metabolic phenotyping. Analytical Chemistry. 2014; 86(19):9887-94

<sup>3</sup> Lovestone, S., Francis, P., Kloszewska, I., Mecocci, P., Simmons, A., Soininen, H., … Ward, M. (2009). AddNeuroMed - The european collaboration for the discovery of novel biomarkers for alzheimer’s disease. In Annals of the New York Academy of Sciences. https://doi.org/10.1111/j.1749-6632.2009.05064.x

<sup>4</sup> Birkenbihl, C., Westwood, S., Shi, L., Nevado-Holgado, A., Westman, E., Lovestone, S., & Hofmann Apitius, M. (2020). ANMerge: A comprehensive and accessible Alzheimer’s disease patient-level dataset. MedRxiv. https://doi.org/10.1101/2020.08.04.20168229

<sup>5</sup> Caroline J Sands, Arnaud M Wolfer, Gonçalo D S Correia, Noureddin Sadawi, Arfan Ahmed, Beatriz Jiménez, Matthew R Lewis, Robert C Glen, Jeremy K Nicholson, Jake T M Pearce, The nPYc-Toolbox, a Python module for the pre-processing, quality-control and analysis of metabolic profiling datasets, Bioinformatics, Volume 35, Issue 24, 15 December 2019, Pages 5359–5360, https://doi.org/10.1093/bioinformatics/btz566
