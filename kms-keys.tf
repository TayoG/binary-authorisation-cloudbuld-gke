
resource"google_kms_key_ring" "keyring" {
name     = "binauthz"
project = var.project
location = var.region

}
#on_failure = continue
resource"google_kms_crypto_key" "vulnz-signer"{
name     ="vulnz-signer"
key_ring =google_kms_key_ring.keyring.id
purpose  ="ASYMMETRIC_SIGN"
 
  version_template{
algorithm ="rsa-sign-pkcs1-4096-sha512"
  }
 
  lifecycle {
prevent_destroy =false
  }
}

resource"google_kms_crypto_key" "qa-signer"{
name     ="qa-signer"
key_ring =google_kms_key_ring.keyring.id
purpose  ="ASYMMETRIC_SIGN"
 
  version_template{
algorithm ="rsa-sign-pkcs1-4096-sha512"
  }
 
  lifecycle {
prevent_destroy = false
  }
}
resource "null_resource" "vulnz-signer" {
  
 provisioner "local-exec"{
   when = create
     command = "chmod +777 ./scripts-apps/vulz-note.sh"
 }
}
resource "null_resource" "qa-signer"{
  
 provisioner "local-exec"{
   when = create
     command = "chmod +777 ./scripts-apps/vuln-cloudbuild.sh"
 }
}

resource "null_resource" "vulnz-attestor"{
  
 provisioner "local-exec"{
   on_failure = continue
   when = destroy 
     command = "gcloud container binauthz attestors add-iam-policy-binding vulnz-attestor --role roles/binaryauthorization.attestorsViewer --member serviceAccount:690873990773@cloudbuild.gserviceaccount.com --project binary-test-1"

 }
 #depends_on =[resource.vulnz-attestor]
 


}

resource "null_resource" "attestors-public-keys-add" {
  
 provisioner "local-exec"{
   
   when = create 
     command = "gcloud beta container binauthz attestors public-keys add --project binary-authorization-356713  --attestor vulnz-attestor  --keyversion 1 --keyversion-key vulnz-signer --keyversion-keyring binauthz --keyversion-location us-central1  --keyversion-project binary-test-1"
 }
}
resource "null_resource" "iam-policy-binding-qa-attestor" {
  
 provisioner "local-exec"{
   
   when = create
     command = "gcloud container binauthz attestors add-iam-policy-binding qa-attestor --project binary-test-1 --member serviceAccount:690873990773@cloudbuild.gserviceaccount.com --role roles/binaryauthorization.attestorsViewer"
 }
}

resource "null_resource" "iam-policy-binding-qa-signer" {
  
 provisioner "local-exec"{
   
   when = create
  on_failure = continue   
     command = "gcloud kms keys add-iam-policy-binding qa-signer --project binary-test-1  --location us-central1 --keyring binauthz --member user:e-beou@gft.com --role roles/cloudkms.signerVerifier"

 }
}