# HiddenWave

Packages the research code and scene illustrations from [computational-imaging/nlos-fk](https://github.com/computational-imaging/nlos-fk/tree/d34d49fed5a86f4ebddf85d461cff6923de5367d), associated with *Wave-Based Non-Line-of-Sight Imaging using Fast f-k Migration* by **David B. Lindell, Gordon Wetzstein and Matthew O'Toole** (SIGGRAPH 2019).

Confocal non-line-of-sight volume reconstruction with backprojection, light-cone inversion, frequency-wavenumber migration, and phasor fields.

This checkout adds the `hidden_wave` alias, setup documentation and smoke checks. The 32 retained numerical and scene files match the pinned upstream version; [source and additions](NOTICE.md) records their provenance.

## Quick start

With MATLAB open in the repository and calibrated measurements loaded, run:

```matlab
volume = hidden_wave(meas, [], wall_size, 2, 512, 32e-12);
```

`hidden_wave` forwards arguments and outputs to the original `cnlos_reconstruction` function. Existing script and function names remain available.

## Inputs and workflows

Measurements are spatial × spatial × time. Supply calibrated transient measurements and matching wall size, crop length, and bin resolution. External research datasets are not bundled. Phasor fields need Signal Processing Toolbox (gausswin).

## Verification

Run `run('tests/smoke_test.m')` from the repository root. See [verification details](docs/VERIFICATION.md) for the tested scope and unavailable checks. The original numerical source and scene illustrations are retained byte-for-byte.

## License

The numerical source retains its institutional academic/noncommercial terms in [LICENSE](LICENSE). MIT in [LICENSE-branding](LICENSE-branding) covers the new documentation, artwork, wrapper and checks only.

## Research citation

David B. Lindell, Gordon Wetzstein and Matthew O'Toole. 2019. *Wave-based non-line-of-sight imaging using fast f-k migration*. ACM Transactions on Graphics 38(4), Article 116. [Project and citation](https://www.computationalimaging.org/publications/nlos-fk/).
