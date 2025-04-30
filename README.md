# 📘 LingoMaster Research

[![Python](https://img.shields.io/badge/Backend-Python-blue?logo=python)](https://www.python.org/)
[![Flutter](https://img.shields.io/badge/Frontend-Flutter-02569B?logo=flutter)](https://flutter.dev/)
[![PyTorch](https://img.shields.io/badge/ML-PyTorch-EE4C2C?logo=pytorch)](https://pytorch.org/)

**LingoMaster** is an AI-powered engine designed to assess the **pronunciation** and **intonation** of English language learners using advanced speech processing and machine learning techniques.

---

## 🔍 Overview

This research project introduces a custom evaluation engine that analyzes spoken English and compares it to trained reference phrases using **Mel-Frequency Cepstral Coefficients (MFCCs)** — a feature widely recognized for its effectiveness in speech analysis.

---

## 📊 Dataset

- **Name:** VCTK Corpus (Version 0.92)
- **Source:** [University of Edinburgh CSTR](https://datashare.ed.ac.uk/handle/10283/3443)
- **Details:** 109 English speakers with different accents reading approximately 400 sentences each.

---

## 🧠 AI Model

- **Architecture:** Feedforward Neural Network
- **Input Features:** MFCCs
- **Training:** Phrase-by-phrase basis using supervised learning
- **Evaluation:** Input phrases are compared against pre-trained weights for similarity scoring

🔗 [Model Training & Evaluation Code](https://github.com/lujip/lingomaster_model.git)

---

## 💻 Tech Stack

| Component | Technology        |
|----------|-------------------|
| Frontend | Flutter (Dart)     |
| Backend  | Python             |
| ML       | PyTorch            |
| Hosting  | Static Web Hosting (API) / render.com

---

## 🚀 Features

- Record speech and visualize waveforms
- Evaluate pronunciation and intonation accuracy
- Score user input based on pre-trained phrase models
- Feedback based on similarity scores (MFCC comparison)

---

## 🔧 Installation & Setup

Coming soon. This repository is primarily for documentation and reference.

---

## 📄 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

## 🤝 Acknowledgments

- [VCTK Corpus](https://datashare.ed.ac.uk/handle/10283/3443)
- [Librosa](https://librosa.org/) – audio processing
- [PyTorch](https://pytorch.org/) – machine learning framework
- [Flutter](https://flutter.dev/) – mobile frontend framework

---

