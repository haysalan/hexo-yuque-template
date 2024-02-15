echo ">_ Clean cache files ..."
npx hexo clean
if [ -d "actions" ]; then
    echo ">_ Add workflows actions ..."
    mkdir -p public/.github/workflows/
    cp -r actions/* public/.github/workflows/
else
    echo ">_ The actions directory does not exist."
fi
echo ">_ Generate file ..."
npx hexo generate
#npx hexo algolia