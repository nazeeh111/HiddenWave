# Verification

## Historical preservation record

The observations in this section predate the 2026-10-29 numerical rehabilitation.
The original SOURCE-MANIFEST.json remains a historical baseline; current intentional
source amendments are identified in SOURCE-AMENDMENTS.json.

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


## Confocal point and batch execution (2026-10-29)

The production numerical formulas are unchanged. The function now admits supported
inputs before allocation, infers a crop no larger than the recording when omitted,
returns nominal coordinate metadata and supports an optional seventh `show_plot`
flag. Default plotting remains available, and all working original six-argument
calls retain their formulas and boundary mask. The facade adds `util/` temporarily
and restores the caller path on success or failure.

Untouched source at commit61581f3 was executed first in hosted MATLAB R2026a:
8-bin f-k failed at negative boundary indices; a default call on32bins tried to
index512;24-bin LCT failed reshaping its power-of-two resampling matrix. ZeroFBP
already returned finite all-zero output; that suspected defect was rejected and
its normalization was not rewritten. These trials remain in task evidence and
baseline probe commit44a1126.

`tests/numerical_test.m` compares working modes0/1/2 exactly with pinned original
source, exercises zero signals and timestamp alignment, requires headless calls
to leave no figures/path changes, checks actionable admission/output-preservation,
and reconstructs two original analytic confocal point scenes. The expected signed
coordinates follow Euclidean light travel time independently of the FFT/Stolt
implementation. Fixed tolerances are one lateral scan spacing and two sampled
nominal depth bins, accounting for the one-bin Gaussian input pulse, interpolation
and retained inclusive depth-axis convention. No expected reconstructed array is
stored or edited. The synthetic example reports absolute coordinate errors and
separates nominal coordinates from calibrated real-world accuracy.

The original FBP mode showed a larger depth offset than LCT/f-k on the first ideal
point probe (about2.4cm for a30cm target). This is retained evidence, not silently
repaired by changing the algorithm. The new independent coordinate gate and example
are specifically for f-k. Other scene conditions and measured quality are unresolved.

Phasor mode still requires `gausswin`/Signal Processing Toolbox; this patch does not
replace an unverified window kernel or claim that mode passed. Captured MAT data,
nonconfocal/nonplanar and iterative procedures remain separate unvalidated workflows.
No microphone, optical hardware or external dataset is accessed by these checks.


Exact reconstruction commit121ddb9 passed hostedMATLAB R2026a run40972081929,
including the pinned-original comparison (`executed=1`) and both newly computed
point artifacts. LocalMATLAB R2026a Update5 also passed the numerical script;
its earlier service5201 failure had cleared at this follow-up. Actual saved MAT
arrays were independently loaded with SciPy: volume maxima match JSON axes/peak
coordinates, and regenerating the same two inputs for the plot-layout correction
left measurement and reconstruction arrays exactly unchanged. The current plots
were visually inspected. The README embeds an unedited PNG downloaded from that
successful hosted production run, separately from the retained research picture.
No performance speedup is claimed from varying cold graphics/JIT timing.


The hosted renderer exposed a horizontal-legend collision absent from the Mac
preview. The original export was retained, plot labels moved into a self-contained
two-line title, and exact plot revisionaf285c8 passed hostedrun40972892515. Both
fresh Linux exports were inspected; the README PNG comes from that corrected run.
These render-only changes do not affect saved measurement or reconstruction arrays.
