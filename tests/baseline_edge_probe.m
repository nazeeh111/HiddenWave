% Execute untouched production source before changing its admission/headless path.
root=fileparts(fileparts(mfilename('fullpath')));addpath(root);
oldVisible=get(groot,'defaultFigureVisible');set(groot,'defaultFigureVisible','off');
cleanup=onCleanup(@() set(groot,'defaultFigureVisible',oldVisible)); %#ok<NASGU>
names={'zero_fbp','short_depth_fk','default_crop_fk','nonpower_depth_lct'};
for k=1:numel(names)
    record=struct('case_name',names{k},'returned',false);
    try
        switch names{k}
            case 'zero_fbp', result=hidden_wave(zeros(8,8,32),[],1,0,32,32e-12);
            case 'short_depth_fk', result=hidden_wave(ones(8,8,8),[],1,2,8,32e-12);
            case 'default_crop_fk', result=hidden_wave(ones(8,8,32),[],1,2);
            case 'nonpower_depth_lct', result=hidden_wave(ones(8,8,24),[],1,1,24,32e-12);
        end
        record.returned=true;record.finite=all(isfinite(result(:)));
        record.nonzero=nnz(result);record.output_size=size(result);
    catch err
        record.error_id=err.identifier;record.error_message=err.message;
    end
    fprintf('BASELINE_EDGE %s\n',jsonencode(record));close all;
end
% Independently generated confocal point returns: roundtrip 2*EuclideanDistance/c.
N=16;M=128;wall=.4;dt=32e-12;c=3e8;
axis_m=linspace(-wall/2,wall/2,N);time=(0:M-1)*dt;
[wx,wy]=meshgrid(axis_m,axis_m);
for target={[.08,-.05,.3],[-.08,.05,.4]}
    p=target{1};r=sqrt((wx-p(1)).^2+(wy-p(2)).^2+p(3)^2);
    meas=exp(-.5*((reshape(time,1,1,[])-2*r/c)/dt).^2)./(r.^4);
    for alg=[0,1,2]
        out=hidden_wave(meas,[],wall,alg,M,dt);
        [power,idx]=max(out(:));[iy,ix,iz]=ind2sub(size(out),idx);
        axes_z=linspace(0,M*c*dt/2,M);
        record=struct('target_m',p,'algorithm',alg,'peak_m',[axis_m(ix),axis_m(iy),axes_z(iz)],'peak_power',power);
        fprintf('BASELINE_POINT %s\n',jsonencode(record));close all;
    end
end
