# Graph-Linguistic Fusion: Using Language Models for Wikidata Vandalism Detection

- **Authors:** Mykola Trokhymovych, Lydia Pintscher, Ricardo Baeza-Yates, Diego Sáez Trumper
- **Venue:** Proceedings of the 63rd Annual Meeting of the Association for Computational Linguistics (Volume 6: Industry Track) (ACL’25), 2025
- **Publisher:** Association for Computational Linguistics
- **DOI:** https://doi.org/10.18653/v1/2025.acl-industry.21
- **Keywords:** vandalism detection, Wikidata, knowledge graphs, multilingual NLP, language models, graph-to-text, content moderation
- **Page:** https://www.trokhymovych.com/publications/graph-linguistic-fusion-using-language-models-for-wikidata-vandalism-detection-2025/

## Abstract

We introduce a next-generation vandalism detection system for Wikidata, one of the largest open-source structured knowledge bases on the Web. Wikidata is highly complex: its items incorporate an ever-expanding universe of factual triples and multilingual texts. While edits can alter both structured and textual content, our approach converts all edits into a single space using a method we call Graph2Text. This allows for evaluating all content changes for potential vandalism using a single multilingual language model. This unified approach improves coverage and simplifies maintenance. Experiments demonstrate that our solution outperforms the current production system. Additionally, we are releasing the code under an open license along with a large dataset of various human-generated knowledge alterations, enabling further research.

## Links

- arXiv: https://arxiv.org/abs/2505.18136
- HTML: https://aclanthology.org/2025.acl-industry.21/
- Data: https://zenodo.org/records/15492678
- PDF: https://aclanthology.org/2025.acl-industry.21.pdf
- Blog: https://meta.wikimedia.org/wiki/Machine_learning_models/Production/RevertRisk_Wikidata
- Code: https://github.com/trokhymovych/wikidata-vandalism-detection
- Poster: https://www.trokhymovych.com/assets/pdf/papers_posters/Wikidata_ACL_poster.pdf
- Slides: https://www.trokhymovych.com/assets/pdf/papers_slides/Wikidata_ACL.pdf
- Website: https://wikitech.wikimedia.org/w/index.php?api=lift-wing%2Fv1&title=Special%3ARestSandbox#/Revision%20quality/revertriskWikidataPredict:~:text=Wikipedia%20revision%20(multilingual)-,POST,Predict%20revert%20risk%20for%20a%20Wikidata%20revision,-Predicts%20whether%20a

## Citation

```bibtex
@inproceedings{trokhymovych-etal-2025-graph,
  title = {Graph-Linguistic Fusion: Using Language Models for {W}ikidata Vandalism Detection},
  author = {Trokhymovych, Mykola and Pintscher, Lydia and Baeza-Yates, Ricardo and S{\'a}ez Trumper, Diego},
  editor = {Rehm, Georg and Li, Yunyao},
  booktitle = {Proceedings of the 63rd Annual Meeting of the Association for Computational Linguistics (Volume 6: Industry Track)},
  month = jul,
  year = {2025},
  address = {Vienna, Austria},
  publisher = {Association for Computational Linguistics},
  url = {https://aclanthology.org/2025.acl-industry.21/},
  doi = {10.18653/v1/2025.acl-industry.21},
  pages = {284--294},
  isbn = {979-8-89176-288-6},
}
```
