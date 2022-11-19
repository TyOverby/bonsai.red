git clone https://github.com/janestreet/bonsai.git

rm -rf guide
rm -rf blogs

cp bonsai/docs/guide -r ./
cp bonsai/docs/blogs -r ./

rm -rf bonsai

