function aver = average_degree

% This function is about the coding challenge from Sight Data Engineering. 
% It is used to calculate the average degree of a vertex in a Twitter 
% hashtag graph for the last 60 seconds.

cd ..;
% one level up from the current folder.
d = fileread('tweet_input\tweets.txt');
% Read in the data in the text file and store the whole string in vector d
k = strfind(d,'{"created_at"');
% Find the position of each tweet
num = length(k);
% num is the # of tweets
cons = 19;
% cons is a constant length from the begining to the datetime
aver = zeros(1,num);
% aver records the average degree 
keySet = 1;
valueSet = {{}};
mapObj = containers.Map(keySet,valueSet);
% Use hash table to store the hashtags in each tweet

a = cell(1,num);
% Cell a is used to store the datetime strings

% Extract the datetime info from the text file
for i=1:num
    a{i} = d(k(i)+cons:k(i)+cons+14);
end


date = datetime(a,'InputFormat','MMM dd HH:mm:ss');
% Convert the string to the datetime data in MATLAB

% Initialization
tweet = d(k(1):k(2));
int_tags = hashtags(tweet);
if length(int_tags)<2
        aver(1) = 0;
else
    aver(1) = length(int_tags)-1;
    mapObj(1) = int_tags;
end

% The loop is used to calculate the average degree
for i = 2:num
    if i<num
        tweet = d(k(i):k(i+1));
    else
        tweet = d(k(end):end);
    end
    % Extract each tweet from the text file
        cur_tags = hashtags(tweet);
        % hashtags is a nested function to get all hashtags in each tweet
        % cur_tags is the current hashtags in short
        if length(cur_tags)<2
            mapObj(i) = {};
        else
            mapObj(i) = cur_tags;
        end
        clock = max(date(max(1,i-3):i));
        % clock is the moment of the newest tweet
        tagset = mapObj(i);
        % tagset is the set of involved hashtags within 60 seconds
        % The initial tagset is current tags
        
        adm = ones(length(tagset)) - eye(length(tagset));
        % adm is the adjacency matrix and the set of involved hashtags
    
        % This sub loop is to calculate the average degree for i-th tweet
        for j = i-1:-1:1
            if clock-date(j)< seconds(60)||clock-date(max(1,j-1))< seconds(60)
                [tagset, adm] = strcmb(tagset,mapObj(j),adm); 
                % strcmb is a nested function to return the combination
                % tags set and the corresponding adjacency matrix
            else
                break;
                % Here I break the loop if there is a tweet whose datetime
                % is without the 60 Second Window. Obviously it's not
                % accurate when there is a tweet out of order in time. We
                % can get more accurate result by checking more previous
                % tweets, just like adding the comment into the if part as
                % aboove. But the code would become very slow when the
                % number of tweet is very large so here I just take one
                % condition
            end
        end
        if length(tagset) < 2
            aver(i) = 0;
        else
            aver(i) = sum(sum(adm))/length(adm);
        end
end
aver = floor(aver*100)/100;
% Truncate two digits after the decimal place

 % Write the data we've got to the text file     
fileID = fopen('tweet_output\output.txt','w');
fprintf(fileID,'%3.2f\r\n',aver);
fclose(fileID);


            
    
    
    
    % Function hashtags is a nested function, str is a single tweet and it
    % will return all the hashtags in str
    function p = hashtags(str)
        aa = strfind(str,'"hashtags":');
        if isempty(aa)
            p = {};
        else
            tags_a = str(aa:end);
            text = strfind(tags_a,'"text"');
            if length(text)<2
                p = {};
            else
                indices = strfind(tags_a,'"indices"');
                 p = cell(1,length(text));
                for ii = 1:length(text)
                    p(ii) = cellstr(tags_a(text(ii)+8:indices(ii)-3));
                end
            end
        end
    end
    

    % Function strcmb is a nested function. s1 is the involved hashtags set
    % and s2 is the incoming hashtags and adm is the adjacency matrix of
    % set s1. p is the whole set including s1 and s2. q is the
    % corresponding adjacency matrix.
    function [p, q] = strcmb(s1,s2,adm)
        a1 = length(s1);
        a2 = length(s2);
        if a1<2
            p = s2;
            q = ones(a2) - eye(a2);
        elseif a2<2
            p = s1;
            q = adm;           
        else
            count = 0;
            ind = zeros(1,a2);
            for i1 = 1:a2
                tf = strcmp(s2(i1),s1);
                if sum(tf)>0
                    ind(i1) = find(tf, 1);
                else
                    count = count+1;
                    ind(i1) = length(s1) + count;
                end
            end
            p = cell(1, max(max(ind),a1));
            q = zeros(max(max(ind),a1));
            q(1:a1,1:a1) = adm;
            q(ind,ind) = ones(a2)-eye(a2);
            p(1:a1) = s1;
            for i2 = 1:a2
                if ind(i2)>a1
                    p(ind(i2)) = s2(i2);
                end
            end
        end
    end

                
         
   
end