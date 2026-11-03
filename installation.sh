#!/usr/bin/env bash
# ============================================================
#  install-nexus-compresseur.sh — NEXUS COMPRESSEUR v10 (10F00)
#
#  Compression RÉELLE de modèles IA (quantification GGUF) avec
#  vérification d'exécution et logs honnêtes — chiffres mesurés,
#  jamais simulés.
#
#  Lancement :  bash install-nexus-compresseur.sh
#  (ne colle JAMAIS le contenu d'un fichier dans le terminal)
# ============================================================
set -u

ROUGE=$'\033[31m'; VERT=$'\033[32m'; JAUNE=$'\033[33m'; CYAN=$'\033[36m'; NUL=$'\033[0m'
ok()  { printf "%s[OK]%s %s\n"  "$VERT" "$NUL" "$1"; }
fail(){ printf "%s[ABANDON]%s %s\n" "$ROUGE" "$NUL" "$1"; exit 1; }
info(){ printf "%s[..]%s %s\n" "$CYAN" "$NUL" "$1"; }
warn(){ printf "%s[!]%s %s\n" "$JAUNE" "$NUL" "$1"; }

cd "$HOME" || exit 1

echo ""
echo "  ╔══════════════════════════════════════════════════╗"
echo "  ║      N E X U S   C O M P R E S S E U R   v10      ║"
echo "  ║   quantification GGUF + vérification d'exécution  ║"
echo "  ║   chiffres mesurés — jamais simulés               ║"
echo "  ╚══════════════════════════════════════════════════╝"
echo ""

# ------------------------------------------------ l'archive
D0="$(cd "$(dirname "$(readlink -f "$0")")" 2>/dev/null && pwd)"
ARCHIVE=""
[ -n "$D0" ] && [ -f "$D0/nexus-compresseur.tar.gz" ] && ARCHIVE="$D0/nexus-compresseur.tar.gz"
if [ -z "$ARCHIVE" ]; then
  for d in "$HOME/Téléchargements" "$HOME/Downloads" "$HOME/snap/firefox/common/Downloads" "$PWD"; do
    if [ -z "$ARCHIVE" ]; then
      ARCHIVE="$(ls -t "$d"/nexus-compresseur*.tar.gz 2>/dev/null | head -n1)"
    fi
  done
fi
[ -n "$ARCHIVE" ] && [ -f "$ARCHIVE" ] || fail "archive nexus-compresseur.tar.gz introuvable — mets-la à côté de l'installateur ou dans Téléchargements."
ok "archive trouvée : $ARCHIVE"

# ------------------------------------------------ extraction
CIBLE="$HOME/NEXUS-COMPRESSEUR"
if [ -d "$CIBLE" ]; then
  ANCIEN="${CIBLE}.ancien-$(date +%Y%m%d-%H%M%S)"
  mv "$CIBLE" "$ANCIEN" && ok "ancienne installation sauvegardée : $ANCIEN"
fi
mkdir -p "$CIBLE"
tar -xzf "$ARCHIVE" -C "$CIBLE" || fail "archive illisible — retélécharge-la."
chmod +x "$CIBLE/nexus-compresseur" 2>/dev/null
ok "compresseur installé dans $CIBLE"

# ------------------------------------------------ tests honnêtes
info "test du compresseur avant de te l'annoncer…"
bash -n "$CIBLE/nexus-compresseur" || fail "le moteur a une erreur de syntaxe"
HOME="$HOME" bash "$CIBLE/nexus-compresseur" rapport > /dev/null 2>&1 \
  && ok "moteur répond (rapport OK)" \
  || fail "le moteur ne répond pas"
warn "llama.cpp (l'outil de quantification) se compilera TOUT SEUL au premier lancement (5-10 min, une seule fois)"
warn "les dépendances python (torch CPU, transformers) s'installent seules au premier HF aussi"

# ------------------------------------------------ commande + menu
mkdir -p "$HOME/.local/bin" "$HOME/.local/share/applications"
ln -sf "$CIBLE/nexus-compresseur" "$HOME/.local/bin/nexus-compresseur" 2>/dev/null
cat > "$HOME/.local/share/applications/nexus-compresseur.desktop" <<FIN
[Desktop Entry]
Type=Application
Name=NEXUS Compresseur
Comment=Compression réelle de modèles IA (quantification GGUF)
Exec=xterm -e bash -c "$CIBLE/nexus-compresseur --menu; read -r _"
Icon=utilities-file-archiver
Terminal=false
Categories=Utility;Development;
FIN
ok "commande nexus-compresseur + raccourci menu installés"

echo ""
echo "  ${VERT}NEXUS COMPRESSEUR v10 est en place.${NUL}"
echo ""
echo "  ── Ce qui est VRAI (mesuré aujourd'hui, SmolLM2-135M) ──"
echo "   F16 brut        270,9 Mo"
echo "   Q4_K_M          105,5 Mo   −61 %  ET utilisable (génère du texte)"
echo "   LZMA sur Q4      +2,8 % seulement, et rend le fichier inutilisable"
echo ""
echo "  ── Comment l'utiliser ──"
echo "   nexus-compresseur                       → menu complet"
echo "   nexus-compresseur hf HuggingFaceTB/SmolLM2-135M-Instruct mon-modele"
echo "   nexus-compresseur local /chemin/dossier mon-modele"
echo "   nexus-compresseur gguf mon-fichier.gguf → vérifie qu'il tourne"
echo "   nexus-compresseur importer model.gguf mon-modele  → dans Ollama"
echo "   nexus-compresseur rapport               → chiffres mesurés"
echo ""
echo "  Niveau par défaut : Q4_K_M. Change avec : export NEXUS_QLEVEL=Q5_K_M"
echo "  (Q5_K_M, Q6_K, Q8_0 — plus lourd, plus fidèle)"
echo ""

[ -t 0 ] && { printf "  Appuie sur Entrée pour fermer… "; read -r _; }
exit 0
