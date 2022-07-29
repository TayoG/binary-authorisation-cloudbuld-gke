






resource "null_resource" "cloudbuild-attestor" {
  
 provisioner "local-exec"{
when = create
     command = "gcloud builds submit --project binary-test-1 --tag gcr.io/binary-test-1/cloudbuild-attestor  ~/binauthz-tools"
 }
}  

resource "google_sourcerepo_repository" "hello-app" {
  name = "hello-app"
  project = "binary-test-1"
 
}

resource "google_cloudbuild_trigger" "build-vulnz-deploy" {
    project = "binary-test-1"
    name = "build-vulnz-deploy"
  trigger_template {
    branch_name = "master"
    repo_name   = google_sourcerepo_repository.hello-app.name
  }

  substitutions = {
    _COMPUTE_REGION = "us-central1"
    _KMS_KEYRING = "binauthz"
    _KMS_LOCATION= "us-central1"
    _PROD_CLUSTER = "production"
    _QA_ATTESTOR = "qa-attestor"
    _QA_KMS_KEY = "qa-signer"
    _QA_KMS_KEY_VERSION = "1"
    _STAGING_CLUSTER = "staging"
    _VULNZ_ATTESTOR = "vulnz-attestor"
    _VULNZ_KMS_KEY = "vulnz-signer"
    _VULNZ_KMS_KEY_VERSION = "1"
  }
  filename = "cloudbuild.yaml"
}

