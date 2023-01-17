resource "google_dialogflow_cx_entity_type" "size" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "size"
  kind         = "KIND_MAP"

  entities {
    value    = "small"
    synonyms = ["pequeña", "pequeño"]
  }

  entities {
    value    = "medium"
    synonyms = ["mediana"]
  }

  entities {
    value    = "large"
    synonyms = ["grande", "holgada"]
  }
}