# Coding-Challenge
This repository is about the coding challenge from Insight to calculate the average degree

This text file is edited by Gang Huang.

==================================================================================================================

In my code, I will search some specific strings to determine the important information like each tweet and the 
hashtags in each one. I think it is not a good method after I read the FAQ part again. But it works well so I 
wouldn't change them.

There are two general loops in my code, the bigger one is for each tweet and the smaller one is to search the 
tweets within 60 seconds to the newest tweet.

In each iteration of the bigger loop, I intialize the set of hashtags by the hashtags in the newest tweet and then 
backward to those past tweets. And I utilize adjacency matrix to store the connection information of the hashtags
set.

In each iteration of the smaller loop, I would go back to those past tweets. If their datetimes are still within 60 
seconds of the newest tweet, the program will compare their hashtags to check if they are repeated or not. And then 
update the new involved hashtags set and the corresponding adjacency matrix.

The average degree is equal to the sum of every entry in the adjacency matrix divided by the number of nodes.

==================================================================================================================

The flaw of my code is about the tweets that arrive out of order in time. I wouldn't let the code search every past
tweet because it would increase the running time rapidly. My stop searching condition is if there are two tweets 
arriving out of 60 seconds in a row. We can get more accurate solution if we modify the stop condition, but it may 
lead to the increasing running time. 

Like the sample you offered whose number of tweets is over 10000, I would modify the stop condition and assume 
these tweets always arrive in the order of time. Then the code is fast and we can get the result within one minute,
but obviously, it may be not accurate.
