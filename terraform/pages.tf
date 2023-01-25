resource "google_dialogflow_cx_page" "store_location" {
  parent       = google_dialogflow_cx_agent.agent.start_flow
  display_name = "Store Location"

  entry_fulfillment {
    return_partial_responses = false

    messages {
      text {
        text = [
          "Nuestra tienda está ubicada en 1007 Mountain Drive, Gotham City, NJ.",
        ]
      }
    }
  }
}

resource "google_dialogflow_cx_page" "store_hours" {
  parent       = google_dialogflow_cx_agent.agent.start_flow
  display_name = "Store Hours"

  entry_fulfillment {
    return_partial_responses = false

    messages {
      text {
        text = [
          "Estamos abiertos de 8 am a 5 pm de lunes a domingo.",
        ]
      }
    }
  }
}

resource "google_dialogflow_cx_page" "new_order" {
  parent       = google_dialogflow_cx_agent.agent.start_flow
  display_name = "New Order"

  form {
    parameters {
      display_name = "color"
      entity_type  = "projects/-/locations/-/agents/-/entityTypes/sys.color"
      is_list      = false
      redact       = false
      required     = true

      fill_behavior {
        initial_prompt_fulfillment {
          return_partial_responses = false

          messages {
            text {
              text = [
                "¿Cuál color te gustaría?",
              ]
            }
          }
        }
      }
    }
    parameters {
      display_name = "size"
      entity_type  = google_dialogflow_cx_entity_type.size.id
      is_list      = false
      redact       = false
      required     = true

      fill_behavior {
        initial_prompt_fulfillment {
          return_partial_responses = false

          messages {
            text {
              text = [
                "¿Qué talla quieres?",
              ]
            }
          }
        }
      }
    }
  }

  transition_routes {
    condition   = "$page.params.status = \"FINAL\""
    target_page = google_dialogflow_cx_page.order_confirmation.id

    trigger_fulfillment {
      return_partial_responses = false

      messages {
        text {
          text = [
            "Ha seleccionado una camiseta $session.params.size, $session.params.color.",
          ]
        }
      }
    }
  }
  transition_routes {
    condition = "true"

    trigger_fulfillment {
      return_partial_responses = false

      messages {
        text {
          text = [
            "Me gustaría recopilar un poco más de información de usted.",
          ]
        }
      }
    }
  }
}

resource "google_dialogflow_cx_page" "order_confirmation" {
  parent       = google_dialogflow_cx_agent.agent.start_flow
  display_name = "Order Confirmation"

  entry_fulfillment {
    return_partial_responses = false

    messages {
      text {
        text = [
          "Puede recoger su pedido de una camiseta $session.params.size $session.params.color en 7 a 10 días hábiles. Adiós.",
        ]
      }
    }
  }

  transition_routes {
    condition   = "true"
    target_page = "${google_dialogflow_cx_agent.agent.start_flow}/pages/END_SESSION"
  }

}

resource "google_dialogflow_cx_page" "order_change" {
  parent       = google_dialogflow_cx_agent.agent.start_flow
  display_name = "Order Change"

  entry_fulfillment {
    return_partial_responses = false

    # messages {
    #   text {
    #     text = [
    #       "Para cambiar su pedido contacte nosotros por ese numero 99 9999 99999",
    #     ]
    #   }
    # }
    
    /* webhook = google_dialogflow_cx_webhook.basic_webhook.id */
    tag = "order.change"
  }
}


  resource "google_dialogflow_cx_page" "get_advice" {
  parent       = google_dialogflow_cx_agent.agent.start_flow
  display_name = "Get Advice"

  entry_fulfillment {
    return_partial_responses = false

    # messages {
    #  text {
    #   text = [
    #      "Un momiento porfa",
    #    ]
    #  }
    #}
    
    webhook = google_dialogflow_cx_webhook.basic_webhook.id
    tag = "get.advice"
  }
}