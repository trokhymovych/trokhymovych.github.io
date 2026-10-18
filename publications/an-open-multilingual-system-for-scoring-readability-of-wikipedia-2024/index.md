# An Open Multilingual System for Scoring Readability of Wikipedia

- **Authors:** Mykola Trokhymovych, Indira Sen, Martin Gerlach
- **Venue:** Proceedings of the 62nd Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers) (ACL’24), 2024
- **Publisher:** Association for Computational Linguistics
- **DOI:** https://doi.org/10.18653/v1/2024.acl-long.342
- **Keywords:** readability, Wikipedia, multilingual NLP, text simplification, text quality
- **Page:** https://www.trokhymovych.com/publications/an-open-multilingual-system-for-scoring-readability-of-wikipedia-2024/

## Abstract

With over 60M articles, Wikipedia has become the largest platform for open and freely accessible knowledge. While it has more than 15B monthly visits, its content is believed to be inaccessible to many readers due to the lack of readability of its text. However, previous investigations of the readability of Wikipedia have been restricted to English only, and there are currently no systems supporting the automatic readability assessment of the 300+ languages in Wikipedia. To bridge this gap, we develop a multilingual model to score the readability of Wikipedia articles. To train and evaluate this model, we create a novel multilingual dataset spanning 14 languages, by matching articles from Wikipedia to simplified Wikipedia and online children encyclopedias. We show that our model performs well in a zero-shot scenario, yielding a ranking accuracy of more than 80% across 14 languages and improving upon previous benchmarks. These results demonstrate the applicability of the model at scale for languages in which there is no ground-truth data available for model fine-tuning. Furthermore, we provide the first overview on the state of readability in Wikipedia beyond English.

## Links

- arXiv: https://arxiv.org/abs/2406.01835
- HTML: https://aclanthology.org/2024.acl-long.342
- Data: https://zenodo.org/records/11371932
- PDF: https://aclanthology.org/2024.acl-long.342.pdf
- Supp: https://huggingface.co/trokhymovych/TRank_readability
- Blog: https://meta.wikimedia.org/wiki/Machine_learning_models/Production/Multilingual_readability_model_card
- Code: https://gitlab.wikimedia.org/repos/research/readability-experiments
- Poster: https://www.trokhymovych.com/assets/pdf/papers_posters/acl_poster.pdf
- Slides: https://www.trokhymovych.com/assets/pdf/papers_slides/acl_slides.pdf
- Website: https://wikitech.wikimedia.org/w/index.php?api=lift-wing%2Fv1&title=Special%3ARestSandbox#/:~:text=Revision%20quality-,POST,Predict%20readability%20of%20a%20Wikipedia%20revision,-POST

## Citation

```bibtex
@inproceedings{trokhymovych-etal-2024-open,
  title = {An Open Multilingual System for Scoring Readability of {W}ikipedia},
  author = {Trokhymovych, Mykola and Sen, Indira and Gerlach, Martin},
  editor = {Ku, Lun-Wei and Martins, Andre and Srikumar, Vivek},
  booktitle = {Proceedings of the 62nd Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers)},
  month = aug,
  year = {2024},
  address = {Bangkok, Thailand},
  publisher = {Association for Computational Linguistics},
  url = {https://aclanthology.org/2024.acl-long.342},
  doi = {10.18653/v1/2024.acl-long.342},
  pages = {6296--6311},
}
```
