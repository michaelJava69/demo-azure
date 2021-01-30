#!/bin/sh
echo "Do you need to login to Az ClI? (Y/n): "
read response

if [ $response == "n" ]
then
    echo "Not logging in."
else
    az login
fi

# Extract the storage account key and use it to access the TF state file
az account set --subscription "Plat-Eng-UK"
KEY=$(az storage account keys list --resource-group terraform-demo-mu --account-name storageaccountmu --output table | grep "^key1" | awk '{print $3}')
echo $KEY

# Make sure TF is up-to-date and then init it. connecting to the storage account as a back end.
terraform get -update
terraform init -backend-config="access_key=$KEY"

echo "you can now run terraform plan and terraform apply! Go forth!"
