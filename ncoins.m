%Read all coin templates
head_1 = imread('1head.jpeg');
tail_1 = imread('1tail.jpeg');
head_20 = imread('20head.jpeg');
tail_20 = imread('20tail.jpeg');
head_5 = imread('5head.jpeg');
tail_5 = imread('5tail.jpeg');
head_10 = imread('10head.jpeg');
tail_10 = imread('10tail.jpeg');

%new image
t = imread('all1.jpeg');

allcoins = {head_1 tail_1 head_5 tail_5 head_10 tail_10 head_20 tail_20};


k = imfill((im2bw(t)), 'holes');

label = bwlabel(k);

minindex = [];

total_cash = 0;

% count number of time each coin appeared
% index 1 - 1 shilling coin count
% index 2 - 5 shilling count
% index 3 - 10 shilling coin count
% index 4 - 20 shilling coin count
coins_count = [0 0 0 0];

for j=1:max(max(label))
    [row, col] = find(label==j);
    len=max(row)-min(row)+2;
    breadth=max(col)-min(col)+2;
    %target=uint8(zeros([len breadth]));
    target=uint8(ones([len breadth]));
    sy=min(col)-1;
    sx=min(row)-1;
        
    for i=1:size(row,1)
        x=row(i,1)-sx;
        y=col(i,1)-sy;
        target(x,y)=t(row(i,1),col(i,1));
    end
    %figure(j);
    %mytitle=strcat('Object number:', num2str(j));
    
    mindistance = intmax('int32');
    
    %compare target with all coin templates
    for index=1:length(allcoins)
        %figure(index)
        
        %histImage(rgb2gray(allcoins{index}))
        rgb2gray(allcoins{index})
        
        %distance between two images
        m = hcompare_EMD(histImage(target), histImage(rgb2gray(allcoins{index})))
        
        %minimize distance
        if m < mindistance
            mindistance = m;
            minindex(j) = index;
        end
    end
    
    %set a moving earth threshold of 42.5
    if mindistance < 42.5
        
        figure(j)
        %length()
        subplot(1,2,1), imshow(target)
        subplot(1,2,2), imshow(allcoins{minindex(j)})
        title(mindistance)
        
        switch minindex(j)
            case 1
                %mathed 1 shiling coin head
                coins_count(1) = coins_count(1) + 1;
            case 2
                %mathed 1 shiling coin tail
                coins_count(1) = coins_count(1) + 1;
            case 3
                %mathed 5 shiling coin head
                coins_count(2) = coins_count(1) + 1;
            case 4
                %mathed 5 shiling coin tail
                coins_count(2) = coins_count(1) + 1;
            case 5
                %mathed 10 shiling coin head
                coins_count(3) = coins_count(1) + 1;
            case 6
                %mathed 10 shiling coin tail
                coins_count(3) = coins_count(1) + 1;
            case 7
                %mathed 20 shiling coin head
                coins_count(4) = coins_count(1) + 1;
            case 8
                %mathed 20 shiling coin tail
                coins_count(4) = coins_count(1) + 1;
        end
    end
end

%add all coin value worth based on number of appearance of each coin
coins_count
total_cash = coins_count(1) + (coins_count(2) * 5) + (coins_count(3) * 10) + (coins_count(4) * 20)
    
function[h] = histImage(img)
% This function calculates normalized histogram of image.
% Normalized histogram is histogram h, that has at
% each i place in it, value:
% (number of picture pixels with gray level i-1) / 
% (total num of pixels in picture).
sum = 0;
[y,x] = size(img); % getting sizes of image  
h = zeros(1,256);    % creating output histogram array
for i = 1:1: y     % runing on rows
    for j = 1:1: x % running on colomns
        % gray level is addtess to cell in output histogram array
        % we add there 1 (bacause of current pixel (y,x) has this gray level
        h(img(i,j)) = h(img(i,j)) + 1;
        % pay attention to fact, that we use here pixel value as index!
    end
end

h = h./(y*x);
end

function[d] = hcompare_EMD(h1,h2)
% This function calculates Earth Movers Distance between two normalized
% histograms h1 and h2. Normalized histogram is histogram h, that has at
% each i place in it, value:
% (number of picture pixels with gray level i-1) / 
% (total num of pixels in picture).


% ALternative fast way:
d = sum(abs(cumsum(h1) - cumsum(h2)));
end