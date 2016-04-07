function run_tests
fileID = fopen('tests\test-2-tweets-in-demo\tweet_output\output.txt','r');
% Read in the data we've got in output.txt
% The input text file is from the demo of the coding challenge
% You can change the relative path if you want to test other results


A = fscanf(fileID,'%f');
fclose(fileID);
B = [1.00,2.00,2.00,2.00,2.00,1.66]';
% B is the correct result we have already known from the demo
% B is supposed to be changed correspondingly as other file is tested

c = norm(A-B);
% Calculate the err
tol = 1e-3;
% tol is the tolerance we set

if c<tol
    fprintf('[PASS]: test-2-tweets-in-demo\n[%s] 1 of 1 tests passed\n',datetime);
else
    fprintf('[FAIL]: test-2-tweets-in-demo\n[%s] 0 of 1 tests passed\n',datetime);
end

end