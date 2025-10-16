# HMGDW
Source code of "Hierarchical Multi-View Graph Diffusion Weighted Model for Cancer Subtype Identification".

Accurate cancer subtype identification is crucial for personalized medicine, enabling precise diagnosis based on molecular characteristics. However, the high dimensionality, heterogeneity, and complexity of multi-omics data pose significant challenges for clustering. To address these issues, we propose HMGDW, a hierarchical multi-view graph diffusion weighted model that integrates middle and late integration strategies to robustly identify cancer subtypes from multi-omics data.
## Overview
<img src="https://github.com/DiorsMana/HMGDW/bolt/main/HMGDW.png" height="600" width="1000">

## Installation
### Requirements
Our algorithm is implemented using Matlab R2016b.
### Installation from GitHub
To clone the repository, run the following from a terminal:
```
git clone https://github.com/DiorsMana/HMGDW.git
```


## Usage
### Run the Demo:
```
Simply execute the Demo.m script to run the complete pipeline:
```
This demo script includes all necessary parameter settings and data loading steps. After execution, it will display:
Execution of the complete HMGDW clustering pipeline
Visualization of clustering results

### Prepare the parameters for HMGDW
All parameters have been pre-set with optimized values in the demo script, typically requiring no adjustment:
```
Par.M        = 6;        % Number of sub-multiviews
Par.Fmin     = 0.6;      % Minimum feature sampling ratio
Par.Fmax     = 0.8;      % Maximum feature sampling ratio
Par.k        = 16;       % Number of neighbors for graph construction
Par.T1       = 5;        % Maximum diffusion iterations
Par.T2       = 5;       % Maximum weighting iterations
```
```
## Contact

* Please feel free to contact Yanchi Su (suyanchi@gmail.com) if you have any questions about the software.

## License

This project is licensed under the MIT License.
