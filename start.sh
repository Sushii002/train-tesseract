cd /app/src
git clone https://github.com/tesseract-ocr/tesstrain.git
echo "Git clone done"
cd /app/src/tesstrain
echo "Downloading ..."
make tesseract-langdata
mkdir -p /app/src/tesstrain/data/dws-ground-truth
echo "Container ready"
tail -f /dev/null
