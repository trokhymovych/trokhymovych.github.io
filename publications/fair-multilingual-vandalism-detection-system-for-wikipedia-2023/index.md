# Fair Multilingual Vandalism Detection System for Wikipedia

- **Authors:** Mykola Trokhymovych, Muniza Aslam, Ai-Jou Chou, Ricardo Baeza-Yates, Diego Saez-Trumper
- **Venue:** Proceedings of the 29th ACM SIGKDD Conference on Knowledge Discovery and Data Mining (KDD’23), 2023
- **Publisher:** Association for Computing Machinery
- **DOI:** https://doi.org/10.1145/3580305.3599823
- **Keywords:** vandalism detection, Wikipedia, multilingual NLP, content moderation, fairness, language models
- **Page:** https://www.trokhymovych.com/publications/fair-multilingual-vandalism-detection-system-for-wikipedia-2023/

## Abstract

This paper presents a novel design of the system aimed at supporting the Wikipedia community in addressing vandalism on the platform. To achieve this, we collected a massive dataset of 47 languages, and applied advanced filtering and feature engineering techniques, including multilingual masked language modeling to build the training dataset from human-generated data. The performance of the system was evaluated through comparison with the one used in production in Wikipedia, known as ORES. Our research results in a significant increase in the number of languages covered, making Wikipedia patrolling more efficient to a wider range of communities. Furthermore, our model outperforms ORES, ensuring that the results provided are not only more accurate but also less biased against certain groups of contributors.

## Links

- arXiv: https://arxiv.org/abs/2306.01650
- HTML: https://dl.acm.org/doi/abs/10.1145/3580305.3599823
- Data: https://zenodo.org/records/8174336
- PDF: https://arxiv.org/pdf/2306.01650
- Supp: https://www.youtube.com/watch?v=hStaW2PPF0c
- Blog: https://meta.wikimedia.org/wiki/Machine_learning_models/Production/Multilingual_revert_risk
- Code: https://github.com/trokhymovych/KI_multilingual_training
- Poster: https://www.trokhymovych.com/assets/pdf/papers_posters/kdd_poster.pdf
- Slides: https://www.trokhymovych.com/assets/pdf/papers_slides/KDD_slides.pdf
- Website: https://wikitech.wikimedia.org/w/index.php?api=lift-wing%2Fv1&title=Special%3ARestSandbox#/:~:text=revisions%20(language%20agnostic)-,POST,lw/inference/v1/models/revertrisk%2Dmultilingual%3Apredict,-Predict%20revert%20risk

## Citation

```bibtex
@inproceedings{10.1145/3580305.3599823,
  author = {Trokhymovych, Mykola and Aslam, Muniza and Chou, Ai-Jou and Baeza-Yates, Ricardo and Saez-Trumper, Diego},
  title = {Fair Multilingual Vandalism Detection System for Wikipedia},
  year = {2023},
  isbn = {9798400701030},
  publisher = {Association for Computing Machinery},
  address = {New York, NY, USA},
  url = {https://doi.org/10.1145/3580305.3599823},
  doi = {10.1145/3580305.3599823},
  booktitle = {Proceedings of the 29th ACM SIGKDD Conference on Knowledge Discovery and Data Mining},
  pages = {4981--4990},
  numpages = {10},
  location = {Long Beach, CA, USA},
  series = {KDD '23},
}
```
