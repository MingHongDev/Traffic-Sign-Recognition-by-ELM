# Implementing Traffic Sign Recognition(TSR) by ELM

<ul>
  
* [An Efficient Method for Traffic Sign Recognition Based on Extreme Learning Machine](https://ieeexplore.ieee.org/document/7433451)
* Author: Zhiyong Huang, Yuanlong Yu, Jason Gu, and Huaping Liu
* Published: IEEE TRANSACTIONS ON CYBERNETICS, 2017.


</ul>

## TSR Architecture

<center>

<img width=40%
src=https://i.imgur.com/tI74c9H.png>

</center>

The proposed method consists of two modules: 
1) Extraction of histogram of oriented gradient variant (HoGv) feature
2) A single classifier trained by extreme learning machine (ELM) algorithm


## [Database](https://benchmark.ini.rub.de/index.html)

![](https://i.imgur.com/ch0S57F.png)


Opensource Database: [GTSRB](https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/published-archive.html)




The  training data(39209 images,43classes) :
 - Images and annotations (GTSRB_Final_Training_Images.zip)

The  test dataset(12630 images) :
 - Images and annotations (without ground truth classes) (GTSRB_Final_Test_Images.zip)
 - Extended ground truth annotations (with classes) (GTSRB_Final_Test_GT.zip)



## Notice
The dimenson of HoGv feature is fixed ,2500.




## Experiment Based on GTSRB.
All experiments were carried out in a Matlab R2019a environment running on a desktop PC with a 3.8 GHz AMD Ryzen 5 3600X 6-Core Processor and a 16 GB memory.

- The Accuracy and time of training phase are 99.99% and 6.1ms/frame.
- The Accuracy of testing phase are 96.63%.
