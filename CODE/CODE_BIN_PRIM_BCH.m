classdef CODE_BIN_PRIM_BCH
%% Binary primitive bch code 
% Binary primitive bch code generated from GF(2^m)
% The bit locations are indexed by alpha^0, alpha^1,...,alpha^(2^m-1)
% To generate a BCH code from GF(2^4) with minimum distance as least 7:
%
% code_bch = CODE_BIN_PRIM_BCH;
% code_bch = code_bch.Init(4, 7);
%% 
    properties
        m; % over GF(2^m)
        d_design; % designed distance
        
        N; % code length
        K; % dimension of the code space
        G; % generate matrix 
        generate_pol; % generate polynomial
        % [1 0 1 1] indicate 1+0*X+1*X^1+1*X^2
    end
%%
    methods
        function obj = Init(obj, m, d_design) 
            obj.m = m;
            obj.d_design = d_design;
            
            alpha_i = 1:(d_design-1);
            % alpha^i for i = 1,2,...,(d_design-1)
            minpol_i = gfminpol(alpha_i, m);
            % minpol_i is the minimum polynomial of alpha^i
            minpol_i = unique(minpol_i, 'rows');
            % remain the unique minimum polynomial
            
            % obtain the generate polynomial
            [num_pol, ~] = size(minpol_i);
            obj.generate_pol = 1;
            for i = 1:num_pol
                obj.generate_pol = mod(conv(obj.generate_pol, minpol_i(i,:)),2);
            end
            % delete the zeros
            loc_one = find(obj.generate_pol~=0);
            obj.generate_pol = obj.generate_pol(1:loc_one(end));
            
            % obtain N,K and G
            obj.N = 2^m-1;
            obj.K = obj.N - length(obj.generate_pol) + 1;
            obj.G = zeros(obj.K, obj.N);
            for i = 1:obj.K
                obj.G(i,i:(i+obj.N-obj.K)) = obj.generate_pol;
            end
            
            disp(['The code length:',num2str(obj.N)]);
            disp(['The code dimension:',num2str(obj.K)]);
            disp(['The code generate polynomial:']);
            disp(obj.generate_pol);
            disp(['The generate matrix:']);
            disp(obj.G);
        end
    end
    
end