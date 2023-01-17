resource "google_dialogflow_cx_webhook" "basic_webhook" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "${var.project_id}-webhook"
  generic_web_service {
        uri = google_cloudfunctions_function.function.https_trigger_url
    }
}