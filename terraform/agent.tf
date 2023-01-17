resource "google_dialogflow_cx_agent" "agent" {
  display_name          = "chatbot-caja-test-leandro"
  location              = var.region
  default_language_code = "es"
  time_zone             = "America/Buenos_Aires"
  description = "Chatbot to test dialogflow features."
  avatar_uri = "https://cloud.google.com/_static/images/cloud/icons/favicons/onecloud/super_cloud.png"
  enable_stackdriver_logging = true
  enable_spell_correction    = true
    speech_to_text_settings {
        enable_speech_adaptation = true
    }
}
