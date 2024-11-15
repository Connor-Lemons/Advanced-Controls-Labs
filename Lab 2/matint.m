function [tfor,matfor,matsfor,tback,matback,matsback]=matint(t0,tf,mat0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Use:  [tfor,matfor,matsfor,tback,matback,matsback]=matint(t0,tf,mat0)
%
%  This function integrates an matrix forward or backward depending on the 
%  values of t0 and tf.  It calls the function matdot which the user must
%  supply:
%
%           matd = matdot(t,mat)
%
%  matdot is given the current time and matrix and it needs to return the
%  derivative of the matrix.
%
%  This takes several small steps and implements the matlab function ode45
%
%  The function can be helpful in computing Riccati solutions and state
%  transition matrix solutions.
%
%  Author        : Dr Scott Dahlke    USAFA/DFAS  719-333-4462   11 Apr 2008
%
%  Inputs        :
%    t0          - Initial time, in units of time
%    tf          - Final time, in units of time  (may be before or after t0)
%    mat0        - Initial matrix condition  (often I for state trans matr.)
%                  (#row x #col)
%
%  Outputs       :
%    (the first three outputs have time ordered from early to later)
%    tfor        - time array with each step of integration (#steps x 1)
%    matfor      - matrix value at each step of integration (#row x #col x #steps)
%    matsfor     - structure with time and matrix values embeded for use
%                  in Simulink as "From Workspace" data
%    (the next three outputs have time ordered from later to earlier)
%    tback        - time array with each step of integration (#steps x 1)
%    matback      - matrix value at each step of integration (#row x #col x #steps)
%    matsback     - structure with time and matrix values embeded for use
%                  in Simulink as "From Workspace" data
%
%  Constants     :
%    None.
%
%  Coupling      :
%    None.
%
%  References    :
%    None.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global nrow ncol

% get the # of rows and columns in the matrix
[nrow,ncol] = size(mat0);

% switch to a column vector because that is what ode45 uses
mat0 = reshape(mat0,nrow*ncol,1);

% do the actual integration and get back a time array and a matrix array
[tarr,matarr] = ode45(@matdir,[t0 tf],mat0);

% flip the matrices to swap the time order
tarr2   = flipud(tarr);
matarr2 = flipud(matarr);

% convert 2-D matrix into a 3-D time ordered matrix (row,col,time point)
for i = 1:size(tarr)
  mat(:,:,i)  = reshape(matarr(i,:), nrow,ncol);
  mat2(:,:,i) = reshape(matarr2(i,:),nrow,ncol);
end

% build time/matrix structures (both time directions)

s.time = tarr;
s.signals.values = mat;
s.signals.dimensions = [nrow ncol];

s2.time = tarr2;
s2.signals.values = mat2;
s2.signals.dimensions = [nrow ncol];

% now sort out which time direction is which
if t0 <= tf
  tfor      = tarr;
  matfor    = mat;
  matsfor   = s;
  tback     = tarr2;
  matback   = mat2;
  matsback  = s2;
else
  tfor      = tarr2;
  matfor    = mat2;
  matsfor   = s2;
  tback     = tarr;
  matback   = mat;
  matsback  = s;
end


end
function mdot = matdir(t,mat)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Use: mdot = matdir(t,mat)
%
%  This function is to be used only by matint.  It converts vectors to
%  matrices and vise-versa
%
%  Author        : Dr Scott Dahlke    USAFA/DFAS  719-333-4462   11 Apr 2008
%
%  Inputs        :
%    t           - current time, in units of time
%    mat         - current matrix condition (in vector form)
%
%  Outputs       :
%    mdot        - the matrix derivative (in vector form)
%
%  Constants     :
%    None.
%
%  Coupling      :
%    None.
%
%  References    :
%    None.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global nrow ncol

% convert vector back into a matrix for the matrix derivative
mat = reshape(mat,nrow,ncol);

% compute the matrix derivative
mdot = matdot(t,mat);

%convert the matrix back into a vector for ode45 that called this
mdot = reshape(mdot,nrow*ncol,1);

end