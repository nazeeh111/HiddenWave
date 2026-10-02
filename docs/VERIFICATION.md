# Verification

Tested locally with MATLAB R2026a Update 5 (26.1.0.3346908), using base MATLAB. Only MATLAB, Simulink and System Composer were installed; additional research toolboxes were not assumed available.

## Passed

Three complete reconstruction modes (backprojection, light-cone transform, and frequency-wavenumber migration) on deterministic 8 × 8 × 32 input. Each branded call exactly matched its legacy entry point, with finite, nonnegative, nonzero volumes.

The 32 retained source and asset files in [SOURCE-MANIFEST.json](SOURCE-MANIFEST.json) are SHA-256 identical to the pre-rebrand snapshot. This establishes source and asset preservation, not full scientific replication. New wrappers and smoke checks are separate from those files. No computational core was rewritten.

## Reproduce

From the repository root in MATLAB:

```matlab
run('tests/smoke_test.m')
```

The test uses only local synthetic inputs or bundled data. It does not acquire or transmit signals. Assertions fail if a checked condition is not satisfied.

## Limits

Phasor-field reconstruction needs Signal Processing Toolbox. Real captured transient datasets, large scenes, nonplanar, nonconfocal and iterative pipelines were not run.

The facade restores the MATLAB search path after a call. Legacy figure output and computational behavior are preserved. This release has new branding, documentation, artwork, and an entry-point facade; it does not claim a new underlying research algorithm.

## Continuous checks

The synthetic reconstruction workflow runs the existing `tests/smoke_test.m` in base MATLAB R2026a on a standard Ubuntu runner, with a three-minute calculation timeout. It uses public-repository batch licensing and requires no license secret or additional toolbox. The same three small synthetic modes run on pushes and pull requests. A passing workflow does not establish captured-data accuracy or cover the unavailable pipelines listed above.
