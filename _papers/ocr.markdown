---
title: OCR with transformers and CTC
date: 2022-11-18
url: https://dl.acm.org/doi/10.1145/3558100.3563845
---

Text recognition tasks are commonly solved by using a deep learning pipeline called CRNN. The classical CRNN is a sequence of a convolutional network, followed by a bidirectional LSTM and a CTC layer. In this paper, we perform an extensive analysis of the components of a CRNN to find what is crucial to the entire pipeline and what characteristics can be exchanged for a more effective choice. Given the results of our experiments, we propose two different architectures for the task of text recognition. The first model, CNN + CTC, is a combination of a convolutional model followed by a CTC layer. The second model, CNN + Tr + CTC, adds an encoder-only Transformers between the convolutional network and the CTC layer. To the best of our knowledge, this is the first time that a Transformers have been successfully trained using just CTC loss. To assess the capabilities of our proposed architectures, we train and evaluate them on the SROIE 2019 data set. Our CNN + CTC achieves an F1 score of 89.66% possessing only 4.7 million parameters. CNN + Tr + CTC attained an F1 score of 93.76% with 11 million parameters, which is almost 97% of the performance achieved by the TrOCR using 334 million parameters and more than 600 million synthetic images for pretraining.
