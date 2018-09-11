# lnsByoi
Bring Your Own Image (BYOI) into Oracle Cloud Infrastructure


> You are running Linux or Windows workload 
> You are in a physical or VM environment
> You are in on-premises or other cloud environment
> You need to migrate to Oracle Cloud Infrastrucure (OCI)
> You do not want to install and configure applications afresh.
> You do not want to invest several man hours in migration.
Then you should consider BYOI automation


Steps to be executed once:
--------------------------
1. Configure a staging server at OCI which should have double the size of the disk in source server where OS is installed.
2. Install python-oci-cli and qemu-img rpms on the staging server.
3. Establish password-less ssh connectivity from root login of source server to opc login of staging server.
4. Generate and upload pem key to OCI console following https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm

Steps to be repeated for every instance to be cloned:
----------------------------------------------------
1. Fill the properties file (lns.cfg) mentioning details of the target instance to be provisioned.
2. Run the Lift & Shift script which does following:
   a. Copy the hard disk from source to staging VM in OCI.
   b. Convert the hard disk so that it is in OCI format
   c. Upload converted hard disk to OCI object storage
   d. Provision a OCI new instance using this hard disk and as per specification provided by customer in the properties file.
