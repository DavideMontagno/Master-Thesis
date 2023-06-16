# Master-Thesis
This repository contains the source code for the paper (1570909988) A VNF-Chaining Approach for Enhancing Ground Network with UAVs in a Crowd-Based Environment

## Table of Contents

- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Usage](#usage)

## Overview

A Mixed Integer Linear Programming (MILP) optimization problem that aims at determining the placement of VNF chains by taking into account the limited resources on board of UAVs, including energy, and that aims at maximizing the UAVs operational lifetime.

DO NOT DELETE ANY FOLDER

## Directory Structure
```
src
├── .metadata
├── cache
├── opl
│   └── Test
│       ├── find_min_drones.ipynb
│       └── main.ipynb
├── compute_grid.ipynb
├── conf_project.yaml
├── create_R.ipynb
├── parse_table.ipynb
└── syn_data.ipynb
```
To use the project, follow these steps:

1. Change the parameters of the network (base station and drones) in the `conf_project.yaml` file.

2. Execute the model by either running `main.ipynb` as a single run with a predetermined number of drones, or by executing a brute force method to find the minimum number of drones where the solution is still feasible.

3. Obtain the visual results by running `parse_table.ipynb`.


