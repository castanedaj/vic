echo "Upload logs"

set -x
gsutil version -l
set +x

outfile="functional_logs_"$1".zip"

echo $Build
echo $outfile

/usr/bin/zip -9 $outfile *.xml *.html *.log

# GC credentials
keyfile="vic-ci-logs.key"
botofile=".boto"
echo -en $GS_PRIVATE_KEY > $keyfile
chmod 400 $keyfile
echo "[Credentials]" >> $botofile
echo "gs_service_key_file = $keyfile" >> $botofile
echo "gs_service_client_id = $GS_CLIENT_EMAIL" >> $botofile
echo "[GSUtil]" >> $botofile
echo "content_language = en" >> $botofile
echo "default_project_id = $GS_PROJECT_ID" >> $botofile

if [ -f "$outfile" ]; then
  gsutil cp $outfile gs://vic-ci-logs
  echo "----------------------------------------------"
  echo "Upload test logs:"
  echo "https://console.cloud.google.com/m/cloudstorage/b/vic-ci-logs/o/$outfile?authuser=1"
  echo "----------------------------------------------"
else
  echo "No log output file to upload"
fi

if [ -f "$keyfile" ]; then
  rm -f $keyfile
fi