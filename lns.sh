#oci --config-file ./ociCli.cfg os bucket list --namespace-name=modusbox --compartment-id=ocid1.compartment.oc1..aaaaaaaabvrkw7zf2tb33xdefvwylxwonbuapkrk2nkn7a6lh7eom2sd727q
#export https_proxy=www-proxy.idc.oracle.com:80
. lns.cfg 2>/dev/null;  dn=$(echo $img| cut -d'.' -f1);
echo "Step 1: Compressing and uploading image from on-prem to OCI staging server....";
time dd if=$rootDsk bs=1M | gzip -c |  ssh opc@$ips " sudo dd of=/u01/$dn.raw.gz status=progress";
echo "Step 2: Uncompressing image in OCI staging server....";
time ssh opc@$ips " sudo gunzip /u01/$dn.raw.gz";
scp -pqr ~/scripts opc@$ips:/tmp
time ssh opc@$ips "sudo /tmp/scripts/lnsByoi/lnsStg.sh"

