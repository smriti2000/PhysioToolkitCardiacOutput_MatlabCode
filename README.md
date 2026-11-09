# PhysioToolkit Cardiac Output Estimation (MATLAB)

MATLAB code for estimating cardiac output (CO) from arterial blood pressure (ABP)
waveforms, based on the PhysioNet/PhysioToolkit cardiac output estimation
toolbox, with local modifications.

## Pipeline

| Stage | Folder | Purpose |
|-------|--------|---------|
| 1 | `1extract/` | Extract waveform and trend data from source records |
| 2 | `2analyze/` | Beat detection (`wabp`), feature extraction (`abpfeature`), signal quality (`jSQI`) |
| 3 | `3estimate/` | 13 CO estimators (`est01_MAP` … `est13_trivial`) behind the `estimateCO` wrapper |
| 4 | `4visualize/` | Plotting and Bland-Altman visualization |
| 5 | `5evaluate/` | Error analysis, variability, calibration |

Supporting code lives in `tools/` and `run_scripts/`.
`Modified estimateCO/` holds local revisions of the main wrapper.

## Entry points

- **`dataextract.m`** — reads the raw ABP text record, runs beat detection and
  feature extraction over the first 12 hours, and saves the result to
  `patient20_12h.mat`.
- **`implement_estimateco.m`** — loads that `.mat`, runs `estimateCO_v3`
  (Liljestrand estimator, LPF order 5), calibrates against the first thermodilution
  CO value from the numerics file, and plots CO / PP / MAP / HR against the
  reference CO values.

## Data files

Raw data is **not** tracked in this repository — the ABP waveform record is
~163 MB, above GitHub's 100 MB per-file limit. `.gitignore` excludes `*.mat` and
`s00020-*_ABP.txt`.

To reproduce from scratch, place the source record in the repository root and run:

```matlab
dataextract          % regenerates patient20_12h.mat
implement_estimateco % runs estimation and plots results
```

Expected data files:

- `s00020-2567-03-30-17-47_ABP.txt` — ABP waveform (time, pressure)
- `s00020-2567-03-30-17-47n.txt` — numerics, column 16 = thermodilution CO (tracked; small)

## Requirements

MATLAB (no toolboxes beyond base required for the core pipeline).
