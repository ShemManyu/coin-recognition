# coin-recognition in matlab

Image recognition problem to identify different coins in an image and output the total value of the coins in the image.


The implementation consisted of four main parts:
1. Loading of coin templates.The templates consisted of two images of each type of coin capturing both the heads and the tails. Each template image was loaded with imread and stored in an array.
2. Extraction of individual coins on given image. This required an object detection approach where given the input image being able to isolate the region of the image
which has a coin before classification of the coin can be done. The steps performed were:
  * Convert image to grayscale.
  * Perform flood-fill operation on background pixels.
  * Label connected components.

I however found this to be not always efficient as
sometimes regions of the image that contained any image that was not a coin was also captured as a label but found
a way for compensating for this during the template matching phase

3. Template matching. Comparison of each identified coin with each template. For each identified object in the previous step we needed a way of comparing them with the stored templates. For this
we used the earth mover’s distance between the normalized histograms of the two images. The lower the distance the
greater the similarity between the images and a comparison of an image and itself should give an earth movers distance
of zero. The template with the least distance would be considered as a match. We noticed object identified that were not coins had the least distance from the comparison of all templates was
much higher than that of coin objects. This allowed us to set a threshold value on the least distance above which
we disregarded the image. In this example we set the threshold value to be 42.5 this allowed us to eliminate non-coin objects. However we also had a false positive and ended up eliminating one coin as well which had a least
distance greater than the threshold.

4. Calculation of total amount based on value of matched templates. The easy part. Identification of the matched templates was based on the index of the template with the least earth mover’s distance.
For each image the index was stored in an array and at the end of the comparisons the total value was calculated.
