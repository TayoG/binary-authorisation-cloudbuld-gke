curl "https://containeranalysis.googleapis.com/v1/projects/binary-test-1/notes/vulnz-note:setIamPolicy" \
  --request POST \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer $(gcloud auth print-access-token)" \
  --header "X-Goog-User-Project: binary-test-1" \
  --data-binary @- <<EOF
    {
      "resource": "projects/binary-test-1/notes/vulnz-note",
      "policy": {
        "bindings": [
          {
            "role": "roles/containeranalysis.notes.occurrences.viewer",
            "members": [
              "serviceAccount:690873990773@cloudbuild.gserviceaccount.com"
            ]
          },
          {
            "role": "roles/containeranalysis.notes.attacher",
            "members": [
              "serviceAccount:690873990773@cloudbuild.gserviceaccount.com"
            ]
          }
        ]
      }
    }
EOF
