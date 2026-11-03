# nexus-compresseur
     Nexus Compresseur: The REAL model compression engine. F16 → GGUF Q4_K_M. Measured, tested, executable. No fake promises. 61% size reduction with proof of execution. Integrates with Ollama."
<div align="center">
  <h1>⚡ NEXUS COMPRESSEUR v10 (10F00)</h1>
  <p><strong>La vraie compression de modèles. Mesurée, testée, et exécutable.</strong></p>
  
  [![Nexus Quantum](https://img.shields.io/badge/Nexus-Quantum-00ff9d?style=for-the-badge&logo=target&logoColor=black)](#)
  [![llama.cpp](https://img.shields.io/badge/Engine-llama.cpp-blue?style=for-the-badge)](#)
  [![GGUF](https://img.shields.io/badge/Format-GGUF_Q4__K__M-purple?style=for-the-badge)](#)
  [![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](#)
</div>

---

## 🧬 Le Problème (Ce que les autres font mal)

Le monde de l'IA locale est pollué par de fausses promesses de compression.

*   **L'arnaque au LZMA** : Certains prétendent compresser un modèle de 14 Go à moins de 1 Go avec LZMA. **C'est faux.** LZMA sur des poids quantifiés n'apporte que ~2,8% de gain, et le fichier devient inutilisable sans le décompresser entièrement en RAM d'abord.
*   **La fausse victoire** : Des scripts écrivent des chiffres de compression non mesurés dans des fichiers JSON pour faire croire à un succès.

**NEXUS COMPRESSEUR** est l'antidote.

---

## ⚙️ La Vraie Solution (Ce que fait Nexus)

Nexus ne "zippe" pas un modèle. Il le **convertit** vers un format compressé natif et exécutable : **GGUF**.

1.  **Entrée universelle** : ID Hugging Face, dossier local `safetensors`, fichier `.gguf` existant, ou blobs Ollama.
2.  **Le Point de Vérité** : Nexus détecte si le modèle est *déjà quantifié*. Si c'est le cas (ex: un blob Ollama), il refuse de le recompresser inutilement et t'explique pourquoi.
3.  **Compression Réelle** : Conversion de `F16` → `Q4_K_M` (par défaut), `Q5`, `Q6`, ou `Q8`. Le taux de compression réel est d'environ **-71%** (14,5 Go → 4,1 Go).
4.  **Preuve d'Exécution Obligatoire** : Le script génère du texte avec le modèle compressé. Si le modèle ne parle pas, le script échoue et affiche `FAIL`. Pas de fausse victoire.
5.  **Log 100% Mesuré** : Chaque action est loguée avec les tailles exactes en octets. Ex: `270 885 856 octets → 105 454 048 octets (61,1%)`.
6.  **Intégration Ollama** : Le modèle compressé est immédiatement importable dans Ollama via `ollama run mon-modele`.

---

## 🚀 Installation & Utilisation

### 1. Installation
Le script d'installation compile `llama.cpp` automatiquement lors du premier lancement.

```bash
bash install-nexus-compresseur.sh
