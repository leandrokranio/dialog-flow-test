resource "google_dialogflow_cx_intent" "store_location" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "store.location"
  priority     = 500000

  training_phrases {
    repeat_count = 1
    parts {
      text = "¿Dónde te encuentras?"
    }
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "¿Cómo llego a su tienda?"
    }
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "¿Cual es tu dirección?"
    }
  }

  training_phrases {
    repeat_count = 1

    parts {
      text = "¿En qué calle estás?"
    }
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "¿Dónde está ubicada la tienda?"
    }
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "¿Como llego hasta ahí?"
    }
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "¿Dónde recojo mi pedido?"
    }
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "Dime la direccion"
    }
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "Direcciones"
    }
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "¿Donde esta la tienda?"
    }
  }
}


resource "google_dialogflow_cx_intent" "store_hours" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "store.hours"
  priority     = 500000
  description  = "Intent example"

  training_phrases {
    repeat_count = 1
    parts {
      text = "¿A que hora cierras?"
    }
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "¿Cuáles son sus horarios de atención?"
    }
  }
}

resource "google_dialogflow_cx_intent" "order_new" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "order.new"
  priority     = 500000

  parameters {
    entity_type = "projects/-/locations/-/agents/-/entityTypes/sys.color"
    id          = "color"
    is_list     = false
    redact      = false
  }

  parameters {
    entity_type = google_dialogflow_cx_entity_type.size.id
    id          = "size"
    is_list     = false
    redact      = false
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "Quiero hacer un pedido"
    }
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "Quiero comprar una camisa"
    }
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "Pedir una camisa"
    }
  }

  training_phrases {
    repeat_count = 1

    parts {
      text = "Comprar camisa "
    }
    
    parts {
      parameter_id = "color"
      text         = "roja"
    }
    
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "Realizar una compra"
    }
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "Quiero una "
    }
    parts {
      text = " camisa"
    }
    parts {
      parameter_id = "size"
      text         = "pequeña"
    }
    
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "Quiero una "
    }
    parts {
      text = " camisa"
    }
    parts {
      parameter_id = "color"
      text         = "amarilla"
    }
    parts {
      parameter_id = "size"
      text         = "grande"
    }
    
    
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "Quiero una "
    }
    parts {
      text = " camisa"
    }
    parts {
      parameter_id = "color"
      text         = "azul"
    }
    
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "Necesito una camisa"
    }
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "Necesito una "
    }
    parts {
      text = " camisa"
    }
    parts {
      parameter_id = "color"
      text         = "amarilla"
    }
    
  }
}

resource "google_dialogflow_cx_intent" "order_change" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "order.change"
  priority     = 500000
  description  = "Cambio intent"

  training_phrases {
    repeat_count = 1
    parts {
      text = "¿Como puedo cambiar mi pedido?"
    }
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "¿Yengo um problema com mi pedido, puedo cambiar mi pedido?"
    }
  }

}
resource "google_dialogflow_cx_intent" "get_advice" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "get.advice"
  priority     = 500000
  description  = "Obtener consejo"

  training_phrases {
    repeat_count = 1
    parts {
      text = "¿Me puedes dar algún consejo?"
    }
  }

  training_phrases {
    repeat_count = 1
    parts {
      text = "Dime una frase bonita"
    }
  }

}