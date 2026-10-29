% Real production reconstruction, analytic physics and admission/recovery.
root=fileparts(fileparts(mfilename('fullpath')));addpath(root,fullfile(root,'examples'));
figures_before=findall(groot,'Type','figure');path_before=path;
for alg=[0,1,2]
    [zero,info]=hidden_wave(zeros(8,8,32),[],1,alg,32,32e-12,false);
    assert(isequal(zero,zeros(8,8,32)) && info.crop_bins==32);
end
% Headless mode returns without creating a single figure or leaking its path.
assert(isequal(findall(groot,'Type','figure'),figures_before));assert(strcmp(path,path_before));
% Default crop follows the available short recording rather than indexing512.
rng(5);meas=rand(8,8,32);
a=hidden_wave(meas,[],1,2,32,32e-12,false);
b=hidden_wave(meas,[],1,2,[],[],false);
assert(isequal(a,b));
% Preserved numerical behavior: original implementation, loaded under a distinct
% name from a pinned historical source by CI, is compared exactly on valid input.
legacy_compared=false;
if exist('cnlos_reconstruction_baseline','file')==2
    oldVisibility=get(groot,'defaultFigureVisible');set(groot,'defaultFigureVisible','off');
    cleanup=onCleanup(@() set(groot,'defaultFigureVisible',oldVisibility)); %#ok<NASGU>
    for alg=[0,1,2]
        expected=cnlos_reconstruction_baseline(meas,[],1,alg,32,32e-12);close(gcf);
        actual=hidden_wave(meas,[],1,alg,32,32e-12,false);
        assert(isequaln(actual,expected));
    end
    legacy_compared=true;
else
    disp('SKIP exact legacy parity: pinned comparison helper not on path; hosted CI requires it');
end
% Unsupported grids now fail before an allocation/figure, with actionable IDs.
cases={@() hidden_wave(ones(8,8,8),[],1,2,8,32e-12,false), ...
       @() hidden_wave(ones(8,8,24),[],1,1,24,32e-12,false), ...
       @() hidden_wave(ones(8,7,32),[],1,2,32,32e-12,false), ...
       @() hidden_wave(ones(8,8,32),zeros(2),1,2,32,32e-12,false), ...
       @() hidden_wave(ones(8,8,32),[],1,9,32,32e-12,false), ...
       @() hidden_wave(ones(8,8,32),[],1,2,32,0,false), ...
       @() hidden_wave(ones(8,8,32),[],1,2,32,32e-12,3), ...
       @() hidden_wave(NaN(8,8,32),[],1,2,32,32e-12,false), ...
       @() hidden_wave(-ones(8,8,32),[],1,2,32,32e-12,false)};
expected_ids={'','HiddenWave:ResamplingSize','HiddenWave:InputShape','','','','HiddenWave:PlotOption','','HiddenWave:NegativeIntensity'};
for k=1:numel(cases)
    failed=false;try,cases{k}();catch err,failed=true;assert(~isempty(err.identifier));
        if ~isempty(expected_ids{k}),assert(strcmp(err.identifier,expected_ids{k}));end
    end
    assert(failed);assert(isequal(findall(groot,'Type','figure'),figures_before));assert(strcmp(path,path_before));
end
% Timestamp alignment is tested independently via known integer time shifts.
[rows,cols]=ndgrid(0:7,0:7);shift=mod(rows+cols,3);
shifted=meas;
for iy=1:8,for ix=1:8,shifted(iy,ix,:)=circshift(meas(iy,ix,:),[0,0,shift(iy,ix)]);end,end
aligned=hidden_wave(shifted,shift*32,1,2,32,32e-12,false);
assert(isequal(a,aligned));
output_a=tempname;output_b=tempname;
first=confocal_point(output_a,[.08,-.05,.3]);second=confocal_point(output_b,[-.08,.05,.4]);
assert(first.peak_m(1)>0 && first.peak_m(2)<0 && second.peak_m(1)<0 && second.peak_m(2)>0);
assert(second.peak_m(3)>first.peak_m(3));
old=load(fullfile(output_a,'reconstruction.mat'),'volume');
failed=false;try,confocal_point(output_a);catch err,failed=strcmp(err.identifier,'HiddenWave:OutputExists');end
assert(failed);retained=load(fullfile(output_a,'reconstruction.mat'),'volume');assert(isequal(old.volume,retained.volume));
assert(isequal(findall(groot,'Type','figure'),figures_before));
fprintf('PASS HiddenWave: independent confocal point focus/units/sign, changed target, alignment and input/output safety. Exact legacy comparison executed=%d. Artifacts: %s %s\n',legacy_compared,output_a,output_b);
