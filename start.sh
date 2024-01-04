cd /app/src
git clone https://github.com/tesseract-ocr/tesstrain.git
echo "Git clone done"
mkdir -p /app/src/tesstrain/data/dws-ground-truth
cd /app/src/tesstrain
make tesseract-langdata
echo "Container ready"
tail -f /dev/null
