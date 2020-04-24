clc; close all;
clear all;
I=eye(9);
%-----------------------------------------------------------------------------
%sudoku puzzle
sp=[0,0,0,4,0,7,0,0,0;
    9,0,1,6,8,3,0,0,0;
    0,2,0,0,0,5,0,7,0;
    0,0,0,8,0,1,0,5,0;
    0,1,0,0,0,9,7,6,2;
    7,3,4,0,5,6,0,0,0;
    1,9,0,7,0,4,0,8,3;
    0,4,0,5,9,8,0,2,6;
    0,5,6,1,0,0,0,0,0;];

%number of clues given
C=sum(sp(:)~=0); 

%-----------------------------------------------------------------------------
%clue constraint
A_clue=zeros(C,729);
for i=1:1:9
    for j=1:1:9
        
     if sp(i,j)~=0
         z=(9*j)-9+sp(i,j);
         A_clue(i,z)=1;
       end
    end
end
%C1=sum(A_clue(:)~=0);
%----------------------------------------------------------------------------- 
%cell constraint
A_cell=zeros(81,729);
 j=1;
for i=1:1:81
 
       A_cell(i,j)=1;A_cell(i,j+1)=1;A_cell(i,j+2)=1;
       A_cell(i,j+3)=1;A_cell(i,j+4)=1;A_cell(i,j+5)=1;
       A_cell(i,j+6)=1;A_cell(i,j+7)=1;A_cell(i,j+8)=1;
   j=j+9;
end

%-----------------------------------------------------------------------------
%row constraint

A_row=[I,I,I,I,I,I,I,I,I,zeros(9,648);
  zeros(9,81),I,I,I,I,I,I,I,I,I,zeros(9,567);
  zeros(9,162),I,I,I,I,I,I,I,I,I,zeros(9,486);
  zeros(9,243),I,I,I,I,I,I,I,I,I,zeros(9,405);
  zeros(9,324),I,I,I,I,I,I,I,I,I,zeros(9,324);
  zeros(9,405),I,I,I,I,I,I,I,I,I,zeros(9,243);
  zeros(9,486),I,I,I,I,I,I,I,I,I,zeros(9,162);
  zeros(9,567),I,I,I,I,I,I,I,I,I,zeros(9,81);
  zeros(9,648),I,I,I,I,I,I,I,I,I;
  ];

%-----------------------------------------------------------------------------
% box constraint
J=[I,I,I;];
O_54=zeros(9,54);
A_box= [J,O_54,J,O_54,J,zeros(9,540);
        zeros(9,27),J,O_54,J,O_54,J,zeros(9,513);
        zeros(9,54),J,O_54,J,O_54,J,zeros(9,486);
        zeros(9,81),J,O_54,J,O_54,J,zeros(9,459);
        zeros(9,108),J,O_54,J,O_54,J,zeros(9,432);
        zeros(9,135),J,O_54,J,O_54,J,zeros(9,405);
        zeros(9,162),J,O_54,J,O_54,J,zeros(9,378);
        zeros(9,189),J,O_54,J,O_54,J,zeros(9,351);
        zeros(9,216),J,O_54,J,O_54,J,zeros(9,324);
        ];

%------------------------------------------------------------------------------
% column constraints
M1=[I,zeros(9,72)];
M=[M1,M1,M1,M1,M1,M1,M1,M1;];
A_col=[M,I,zeros(9,72);
       zeros(9,9),M,I,zeros(9,63);
       zeros(9,18),M,I,zeros(9,54);
       zeros(9,27),M,I,zeros(9,45);
       zeros(9,36),M,I,zeros(9,36);
       zeros(9,45),M,I,zeros(9,27);
       zeros(9,54),M,I,zeros(9,18);
       zeros(9,63),M,I,zeros(9,9);
       zeros(9,72),M,I;
       ];
%------------------------------------------------------------------------------
% concatenate A matrices
A= vertcat(A_row,A_col,A_box,A_cell,A_clue);
%------------------------------------------------------------------------------
b=ones((4*81+C),1);
%------------------------------------------------------------------------------
% %indicator matrix
% X_indicator=zeros(729,1);
% m=0;
% for i=1:1:9
%     for j=1:1:9
%         
%      if sp(i,j)~=0
%          z=(81*m)+(9*j)-9+sp(i,j);
%          X_indicator(z,1)=1;
%        end
%     end
%     m=m+1;
% end
% %C2=sum(X_indicator(:)~=0);

%------------------------------------------------------------------------------
% Create and solve problem
cvx_begin
% cvx_solver Mosek 
   variable X(729)
   minimize( norm( X,1) )
   subject to
        A * X == b;
cvx_end
