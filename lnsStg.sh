#oci --config-file ./ociCli.cfg os bucket list --namespace-name=modusbox --compartment-id=ocid1.compartment.oc1..aaaaaaaabvrkw7zf2tb33xdefvwylxwonbuapkrk2nkn7a6lh7eom2sd727q
#export https_proxy=www-proxy.idc.oracle.com:80
cd /tmp/scripts/lnsByoi;
. $PWD/lns.cfg 2>/dev/null; chmod 600 $PWD/lns.cfg
rg=$region; 
ad="--availability-domain $ad";
bktUrl="$bkt"; bkt="--bucket-name $bkt"; 
cfg="--config-file $PWD/lns.cfg";
cmpId="--compartment-id $cmpId";
dn=$(echo $img| cut -d'.' -f1); dnCls="--display-name $dn";
lm="--launch-mode $lm";
nsUrl="$namespace"; ns="--namespace=$namespace"; 
sbn="  --subnet-id $sbn";
shp="--shape $shp";

echo "Step 3: Converting RAW image to QCOW2 format in OCI staging server....";
cmd="convert -O qcow2 /u01/$dn.raw /u01/$img"; time qemu-img $cmd;

# upload
echo "Step 4: Uploading qcow2 image to from OCI staging server to OCI object storage....";
cmd="$cfg os object put $ns $bkt --name $img  --no-overwrite --file -"; cat /u01/$img | oci $cmd;
#cat /u01/$img | oci $cfg os object put $ns $bkt --name $img  --no-overwrite --file -

# import image 
echo "Step 5: Importing uploaded image as OCI custom image....";
#url=https://objectstorage.eu-frankfurt-1.oraclecloud.com/n/gsebmcs00009/b/mybucket/o/ol74Repo.qcow2
url=https://objectstorage.$rg.oraclecloud.com/n/$nsUrl/b/$bktUrl/o/$img
cmd="$cfg compute image import from-object-uri --uri $url $cmpId $dnCls $lm"; oci $cmd;
#oci $cfg compute image import from-object-uri --uri $url $cmpId $dnCls $lm
time while [[ $imgId = '' || $imgId = "--image-id " ]]; do sleep 10s;  imgId="--image-id $(oci $cfg  compute image list $cmpId $dnCls --lifecycle-state AVAILABLE | grep ocid1.image | cut -d\" -f4 | head -1)"; done;

# launch
echo "Step 6: Launching instance as per specification using the custom image....";
cmd="compute instance launch $ad $cfg $cmpId $dnCls $imgId $sbn $shp"; time oci $cmd;
#oci compute instance launch $ad $cfg $cmpId $dnCls $imgId $sbn $shp;




