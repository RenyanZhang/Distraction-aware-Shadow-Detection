# Distraction-aware Shadow Detection
Reuploaded into a github repository from a zip file stored on google drive: https://quanlzheng.github.io/projects/Distraction-aware-Shadow-Detection.html

![](https://quanlzheng.github.io/projects/Distraction-aware-Shadow-Detection/teaser.png)

## Abstract

Shadow detection is an important and challenging task for scene understanding. Despite promising results from recent deep learning based methods. Existing works still struggle with ambiguous cases where the visual appearances of shadow and non-shadow regions are similar (referred to as distraction in our context). In this paper, we propose a Distraction-aware Shadow Detection Network (DSDNet) by explicitly learning and integrating the semantics of visual distraction regions in an end-to-end framework. At the core of our framework is a novel standalone, differentiable distraction-aware module, which allows us to learn distraction-aware, discriminative features for robust shadow detection. Our proposed module learns to extract and fuse distraction-indicative features into the visual features of the input image, by explicitly predicting false positives and false negatives. We conduct extensive experiments on three public shadow detection datasets, SBU, UCF and ISTD, to evaluate our method. Experimental results demonstrate that our model can boost shadow detection performance, by effectively suppressing the detection of false positives and false negatives, achieving state-of-the-art results.
## Architecture

![](https://quanlzheng.github.io/projects/Distraction-aware-Shadow-Detection/Architecture.png)

## DS Module

![](https://quanlzheng.github.io/projects/Distraction-aware-Shadow-Detection/DS-module.png)

## Downloads

- [Paper](https://quanlzheng.github.io/projects/Distraction-aware-Shadow-Detection/3109.pdf)
- [Supp.](https://quanlzheng.github.io/projects/Distraction-aware-Shadow-Detection/3109-supp.pdf)
- [Poster](https://quanlzheng.github.io/projects/Distraction-aware-Shadow-Detection/Poster_shadow_2019.pdf)
- [Results](https://drive.google.com/open?id=1cQD7kdwfnP5HhSAhk-rSjayKz7i2t0Tq)
- [Codes](https://drive.google.com/open?id=18hv6NAQsST1UsabtNvfM_G-qR-nAbgaa)
- [Models](https://drive.google.com/open?id=1-YnAGDzn5GqYfZDLZ4NHZy-TWstwFg_S)
- [Distraction Dataset](https://drive.google.com/open?id=1gwfGXZB5yiEsg_iiVQ94tNy2ReFnlUTs)


## Citation

```tex
@InProceedings{Zheng_2019_CVPR,
	author = {Zheng, Quanlong and Qiao, Xiaotian and Cao, Ying and Lau, Rynson W.H.},
	title = {Distraction-Aware Shadow Detection},
	booktitle = {The IEEE Conference on Computer Vision and Pattern Recognition (CVPR)},
	month = {June},
	year = {2019}
}
```
