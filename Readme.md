# Xplorers Backend Infrastructure

This repository contains the infrastructure code for the Xplorers backend. It is written in Terraform and uses Google Cloud Platform as the cloud provider.

## Limitations on Feature Branches for Google Cloud Services

### Technical Constraints

When working with Google Cloud services and IAM bindings, there are certain constraints that prevent the creation of feature branches for specific services. These constraints include:

1. **Global Nature of Google Cloud Services**:

    Google Cloud service APIs such as apigateway.googleapis.com, servicemanagement.googleapis.com, and servicecontrol.googleapis.com are enabled at the project level and affect the entire project. As a result, enabling or disabling these services impacts all environments within the project, making it impractical to manage them on a per-branch basis.

2. **IAM Binding Limitations**:

    IAM bindings, such as those granting the roles/secretmanager.secretAccessor role, are also applied at the project level. These bindings grant permissions to service accounts across the entire project. Managing IAM bindings on a per-branch basis would require creating and managing separate service accounts and bindings for each branch, which needs to be explored further to determine feasibility.

3. **Terraform State Management**:

    Terraform manages infrastructure as code and maintains the state of resources. When multiple branches attempt to modify the same global resources, it can lead to state conflicts and inconsistencies. This is particularly problematic for resources that are not isolated by environment or branch.

## Prerequisites

### Software

-   [Git](https://git-scm.com/downloads)
-   [Taskfile](https://taskfile.dev/#/installation)
-   [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
-   [Google Cloud CLI](https://cloud.google.com/sdk/docs/install)

### Access to Google Cloud Platform

You will need access to the Google Cloud Platform to deploy the Xplorers API. If you don't have access, please contact the project owner.

Once you have access, login to Google Cloud via gcloud cli + setup application default credentials via Application Default Credentials (ADC),

Run [**_gcloud init_**](https://cloud.google.com/sdk/gcloud/reference/init) to authorize gcloud and other SDK tools to access Google Cloud using your user account credentials.

Run [**_gcloud auth application-default login_**](https://cloud.google.com/sdk/gcloud/reference/auth/login) to obtain access credentials for your user account via a web-based authorization flow. When this command completes successfully, it sets the active account in the current configuration to the account specified. If no configuration exists, it creates a configuration named default.

## Google Cloud Infrastructure

Due to the constraints mentioned above, the following Google Cloud services and IAM bindings are managed at the project level and cannot be isolated to feature branches:

### APIs & Services Enabled

-   API Gateway API
-   Service Management API
-   Service Control API
-   [#TODO: NEED TO SCOPE PERMISSIONS] Creates Google Project Bindings for,
    -   Compute service account to access Secret Manager secrets
