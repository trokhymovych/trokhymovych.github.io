# WikiCheck: An End-to-End Open Source Automatic Fact-Checking API Based on Wikipedia

- **Authors:** Mykola Trokhymovych, Diego Saez-Trumper
- **Venue:** Proceedings of the 30th ACM International Conference on Information & Knowledge Management (CIKM’21), 2021
- **Publisher:** Association for Computing Machinery
- **DOI:** https://doi.org/10.1145/3459637.3481961
- **Keywords:** automated fact checking, wikipedia, nlp, nli, fact-checking, fact verification, fact search
- **Page:** https://www.trokhymovych.com/publications/wikicheck-an-end-to-end-open-source-automatic-fact-checking-2021/

## Abstract

With the growth of fake news and disinformation, the NLP community has been working to assist humans in fact-checking. However, most academic research has focused on model accuracy without paying attention to resource efficiency, which is crucial in real-life scenarios. In this work, we review the State-of-the-Art datasets and solutions for Automatic Fact-checking and test their applicability in production environments. We discover overfitting issues in those models, and we propose a data filtering method that improves the model’s performance and generalization. Then, we design an unsupervised fine-tuning of the Masked Language models to improve its accuracy working with Wikipedia. We also propose a novel query enhancing method to improve evidence discovery using the Wikipedia Search API. Finally, we present a new fact-checking system, the WikiCheck API that automatically performs a facts validation process based on the Wikipedia knowledge base. It is comparable to SOTA solutions in terms of accuracy and can be used on low-memory CPU instances.

## Links

- arXiv: https://arxiv.org/abs/2109.00835
- HTML: https://dl.acm.org/doi/10.1145/3459637.3481961
- PDF: https://arxiv.org/pdf/2109.00835
- Blog: https://meta.wikimedia.org/wiki/Research:Implementing_a_prototype_for_Automatic_Fact_Checking_in_Wikipedia
- Code: https://github.com/trokhymovych/WikiCheck
- Poster: https://www.trokhymovych.com/assets/pdf/papers_posters/CIKM-POSTER.pdf
- Slides: https://www.trokhymovych.com/assets/pdf/papers_slides/CIKM_presentation.pdf

## Citation

```bibtex
@inproceedings{10.1145/3459637.3481961,
  author = {Trokhymovych, Mykola and Saez-Trumper, Diego},
  title = {WikiCheck: An End-to-End Open Source Automatic Fact-Checking API Based on Wikipedia},
  year = {2021},
  isbn = {9781450384469},
  publisher = {Association for Computing Machinery},
  address = {New York, NY, USA},
  url = {https://doi.org/10.1145/3459637.3481961},
  doi = {10.1145/3459637.3481961},
  booktitle = {Proceedings of the 30th ACM International Conference on Information \& Knowledge Management},
  pages = {4155--4164},
  numpages = {10},
  location = {Virtual Event, Queensland, Australia},
  series = {CIKM '21},
}
```
