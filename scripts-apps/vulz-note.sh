curl "https://containeranalysis.googleapis.com/v1/projects/binary-test-1/notes/?noteId=vulnz-note" \
  --request "POST" \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer $(gcloud auth print-access-token)" \
  --header "X-Goog-User-Project: binary-test-1" \
  --data-binary @- <<EOF
    {
      "name": "projects/binary-test-1/notes/vulnz-note",
      "attestation": {
        "hint": {
          "human_readable_name": "Vulnerability scan note"
        }
      }
    }
EOF
