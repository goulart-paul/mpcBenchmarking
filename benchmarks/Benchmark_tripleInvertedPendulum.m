function [ problem ] = Benchmark_tripleInvertedPendulum( variant )
%Benchmark_tripleInvertedPendulum does something.
%
%Inputs:
%  (tbd)
%
%Outputs:
%  (tbd)

% This file is part of the CAESAR MPC Suite developed at 
% ABB Corporate Research (CHCRC.C1).
% It is distributed under the terms of the Eclipse Public License v1.0,
% see the file LICENSE in the root directory.
%
% Authors:         Joachim Ferreau, Helfried Peyrl, 
%                  Dimitris Kouzoupis, Andrea Zanelli
% Last modified:   24/11/2015


% default variant
if ( nargin < 1 )
    variant = 1;
end


%% define MPC problem info
problem = Benchmark(variant); % create an empty benchmark object

% try to load benchmark from mat file
problem = problem.loadFromMatFile( 'tripleInvertedPendulum',variant );

problem.info              = setupBenchmarkInfoStruct( );
problem.info.ID           = uint32(Benchmarks.tripleInvertedPendulum);
problem.info.name         = 'tripleInvertedPendulum';
problem.info.description  = 'Linearized triple inverted pendulum. Unstable and possibly with state constraints.';
problem.info.reference    = 'E.J. Davison: Benchmark Problems for Control System Design, IFAC, 1990.';
problem.info.origin       = Origin.academicExample;
problem.info.conditioning = Conditioning.undefined;
problem.info.feasibility  = Feasibility.undefined;
problem.info.isOpenLoopStable = Boolean.no;


%% define MPC benchmark data
problem.Ts = 0.01; % [s]

Ac = [  0.00e+0,  0.00e+0,  0.00e+0,  1.00e+0,  0.00e+0,  0.00e+0; ...
        0.00e+0,  0.00e+0,  0.00e+0,  0.00e+0,  1.00e+0,  0.00e+0; ...
        0.00e+0,  0.00e+0,  0.00e+0,  0.00e+0,  0.00e+0,  1.00e+0; ...
        2.94e+1, -1.96e+1, -3.6e-16,  0.00e+0,  0.00e+0,  0.00e+0; ...
       -2.94e+1,  3.92e+1, -9.80e+0,  0.00e+0,  0.00e+0,  0.00e+0; ...
        0.00e+0, -1.96e+1,  1.96e+1,  0.00e+0,  0.00e+0,  0.00e+0  ];

Bc = [  0.00e+0,  0.00e+0,  0.00e+0; ...
        0.00e+0,  0.00e+0,  0.00e+0; ...
        0.00e+0,  0.00e+0,  0.00e+0; ...
        1.67e+0, -2.67e+0,  1.00e+0; ...
       -2.33e+0,  4.83e+0, -3.50e+0; ...
        6.67e-1, -2.67e+0,  4.00e+0  ];
    
Cc = [ 1, 0, 0, 0, 0, 0; ...
       0, 1, 0, 0, 0, 0; ...
       0, 0, 1, 0, 0, 0  ];

sys = c2d( ss(Ac,Bc,Cc,[]),problem.Ts,'zoh' );
[A,B,C,D] = ssdata(sys);


problem.A = A;        % compulsory
problem.B = B;        % compulsory
problem.C = C;        % optional (default, identity matrix)
problem.D = D;        % optional (default, zero matrix)

problem.umax =  [5.0; 5.0; 5.0];             % all constraint fields are optional
problem.umin = -[5.0; 5.0; 5.0];             % (default values -inf/inf)

problem.Q  = 100*eye(3);           % optional (default, identity matrix)
problem.R  = 0.1*eye(3);              % optional (default, zero matrix)

[~, problem.P] = dlqr( problem.A, problem.B, problem.C'*problem.Q*problem.C,problem.R, zeros(6,3) );

problem.ni   = 30;                  % 
problem.uIdx = [];                  % optional (default, []. Control horizon same as prediction horizon)
problem.lookAhead = Boolean.yes;    % optional (default, 0.  No access to future value of reference trajectories)
problem.simModel  = [];             % optional (default, simulation model same as prediction model)

problem.x0 = [ 0.05, 0.05, 0.05, 0.025, 0.025, 0.025 ]';


%% define control scenario
problem.variants = [1 2 3];

switch ( variant )
    
    case 1
       
        for i=1:450
            problem.yr{i} = [0;0;0];
        end
        
        
    case 2
       
        problem.ymax =  [0.15; 0.15; 0.15];             % all constraint fields are optional
        problem.ymin = -[0.15; 0.15; 0.15];             % (default values -inf/inf)

        for i=1:450
            problem.yr{i} = [0;0;0];
        end
        
        
    case 3
       
        problem.ymax =  [0.12; 0.12; 0.12];             % all constraint fields are optional
        problem.ymin = -[0.12; 0.12; 0.12];             % (default values -inf/inf)

        for i=1:450
            problem.yr{i} = [0;0;0];
        end


    otherwise
        error( 'Invalid variant number!' );
end

end
