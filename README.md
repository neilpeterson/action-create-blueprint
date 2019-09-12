# GitHub Action: Create Azure Blueprints

GitHub Actions to create an Azure Blueprints. For more information on Azure Blueprints, see the [Azure Blueprints documentation](https://docs.microsoft.com/en-us/azure/governance/blueprints/overview?WT.mc_id=blueprintsextension-github-nepeters).

## Azure Authentication

Before using these actions, create an Azure Active Directory Service Principal using the `az ad sp create-for-rbac` command. For more information on creating an Azure Active Directory service principal, see the [Azure Command-Line Interface docs for working with service principals](https://docs.microsoft.com/en-us/cli/azure/ad/sp?WT.mc_id=blueprintsextension-github-nepeters&view=azure-cli-latest).


Next, create three GitHub secrets hold the service principal credentials.


| Secret Name | Value |
|:---|---:|
| AZURETENANTID | tenant |
| AZURECLIENTID | appId |
| AZUREPASSWORD | password |

## Create Blueprint

Most basic example:

```
- name: Create Azure Blueprint
  env:
    AZURETENANTID: ${{ secrets.AZURETENANTID }}
    AZURECLIENTID: ${{ secrets.AZURECLIENTID }}
    AZUREPASSWORD: ${{ secrets.AZUREPASSWORD }}
  uses: neilpeterson/action-create-blueprint@master
  with:
    azureManagementGroupName: nepeters-internal
    blueprintName: actionBlueprintPublish
    blueprintPath: ./create
```

All configuration parameters:

| Name | Description | Required |
|:---|:---|---:|
| scope | Creation scope for the blueprint. Valid values are `ManagamentGroup` and `Subscription`. Defaults to `ManagementGroup`. | false |
| azureManagementGroupName | The Azure Management group at which the blueprint will be created. | false |
| azureSubscriptionID | The Azure subscription at which the blueprint will be created. | false |
| blueprintName | The blueprint name. | true |
| blueprintPath | The path to a directory that contains the blueprint.json file. | true |
| publishBlueprint | A value of true indicates the blueprint should be published. The default value is `true`. | false |
| version | A value of Increment will increment the version number if the version is an integer'. The default value is `increment`. | false |