resource "null_resource" "default_start_flow" {
  # Use a REST API call (instead of Terraform) to modify messages and routes in
  # the default start flow and since Dialogflow creates this default start flow
  # automatically
  provisioner "local-exec" {
    command = <<-EOT
curl --location --request PATCH 'https://${self.triggers.LOCATION}-dialogflow.googleapis.com/v3/projects/${self.triggers.PROJECT}/locations/${self.triggers.LOCATION}/agents/${self.triggers.AGENT}/flows/${self.triggers.DEFAULT_START_FLOW}?updateMask=transitionRoutes' -H 'Authorization: Bearer $(gcloud auth application-default print-access-token)' -H 'Content-Type: application/json' --data-raw '{"transitionRoutes":[{"intent":"projects/${self.triggers.PROJECT}/locations/${self.triggers.LOCATION}/agents/${self.triggers.AGENT}/intents/${self.triggers.DEFAULT_WELCOME_INTENT}","triggerFulfillment":{"messages":[{"text":{"text":["Hola, este es un agente virtual de pedido de camisas. ¿Le puedo ayudar en algo?"]}}]}},{"intent":"${self.triggers.STORE_HOURS_INTENT}","targetPage":"${self.triggers.STORE_HOURS_PAGE}"},{"intent":"${self.triggers.STORE_LOCATION_INTENT}","targetPage":"${self.triggers.STORE_LOCATION_PAGE}"},{"intent":"${self.triggers.NEW_ORDER_INTENT}","targetPage":"${self.triggers.NEW_ORDER_PAGE}"},{"intent":"${self.triggers.ORDER_CHANGE_INTENT}","targetPage":"${self.triggers.ORDER_CHANGE_PAGE}"}]}'
EOT
}

  # Use triggers instead of environment variables so that they can be reused in
  # the provisioner to create routes as well as the destroy-time provisioner
  triggers = {
    PROJECT                = var.project_id
    LOCATION               = var.region
    AGENT                  = google_dialogflow_cx_agent.agent.name
    DEFAULT_START_FLOW     = "00000000-0000-0000-0000-000000000000"
    DEFAULT_WELCOME_INTENT = "00000000-0000-0000-0000-000000000000"

    STORE_LOCATION_INTENT = google_dialogflow_cx_intent.store_location.id
    STORE_HOURS_INTENT    = google_dialogflow_cx_intent.store_hours.id
    NEW_ORDER_INTENT      = google_dialogflow_cx_intent.order_new.id
    ORDER_CHANGE_INTENT   = google_dialogflow_cx_intent.order_change.id

    STORE_LOCATION_PAGE = google_dialogflow_cx_page.store_location.id
    STORE_HOURS_PAGE    = google_dialogflow_cx_page.store_hours.id
    NEW_ORDER_PAGE      = google_dialogflow_cx_page.new_order.id
    ORDER_CHANGE_PAGE   = google_dialogflow_cx_page.order_change.id

  }

  # Use a REST API call in a destroy-time provisioner to delete routes in the
  # default start flow since we created them with a REST API call, and Terraform
  # will fail to delete them since they are managed externally
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
    curl --location --request PATCH "https://${self.triggers.LOCATION}-dialogflow.googleapis.com/v3/projects/${self.triggers.PROJECT}/locations/${self.triggers.LOCATION}/agents/${self.triggers.AGENT}/flows/${self.triggers.DEFAULT_START_FLOW}?updateMask=transitionRoutes" \
    -H "Authorization: Bearer ya29.c.b0AT7lpjDDwEGXgdCxaGG3hIwZom79IWJGozwKc1wVSEg6cuA1lf2boDLJgndZ8kqkQ90i_Cshyd-J8kz0Vo3pdiTDk_-bzAYHQSeLToEumqf2QKZ0CLQZr2sMIqjQNdNw_8TTFU9CUZ63PA_jsnlXPpFzkZ_Vpa75axtyEkgboCuX3B7psgdgA1FxZeTQlRflosbk3H40t0imSDjL0PrSC7AmeOyIpWcN232DxSeB5xxFsbSmkyvs5JF0ZJyIO3Q-9fsmSgO7W31Q-jw6kzo3Ztoc1l2amiqkzh_cf1cJ0dXB-2blJvSi2rM_WdMQJyOsWVQ2dJ3R04U3zYyoiYvwI8Us25YcZdorsVtpbXgx8_majBIo-qtq7-whQ4zURVMhI7gVRuOmjOfOqe1_OfmtQapZcZt3XvzMO0hIXvZj2S2sd3qBOd7BWRh-Vc7SXnSv3lOZbm-1-otahM6nYbqucW7Iinniqllnk1p3q3SYgFWXbhqu1s5eiYYjq9UQWqv23ijbF938UsXBlwmSw0yd7YS3ktvhxScb9_cVy7uR0r795qw1Znszqijes2h506oUnzMVWOsWtlO2hR3Z_u2-hFJo6bOlxdhIVaRVF7RuzFk9zxnXFBwhpjwQ8dbub8-tQ_5fvZghjaaZacRisxd2i8indQfg34SuUvffryWX4I0zi-IhvwVjw2Usf2nlR0WS4W2Q6ft2nk77xrx7-beYFIVUyy0ieBfw7cyOYXRiz1Y_fywB8Mne9F-O-VYavdWcpkX_mspa1Rby2QX8pUgBzlUhV6doQt6U_6OVywWbalBvScgWUeh3hs1RWbW3g9Ot6BX_ywO0gZwkQ3x-9JZjWcmQBQeQrWFM14VB694Xjt84xXgMxbq72Vhtf87kn3Qo6n5th0oRjV6WZbsmJu94XaJtMpI8po9p78o9Bp8sUi8qhzo8ts2UFOwgbamhnR_mvOM8-3o0w_84mfRwbU6cp6ar6ryokVuFvI7bqdX_SfwjkR_oxwYlXho" \
    -H "Content-Type: application/json" \
    --data-raw "{
      "transitionRoutes": [{
        "intent": "projects/${self.triggers.PROJECT}/locations/${self.triggers.LOCATION}/agents/${self.triggers.AGENT}/intents/${self.triggers.DEFAULT_WELCOME_INTENT}",
		    "triggerFulfillment": {
			    "messages": [{
				    "text": {
					    "text": [
						    "Hola, este es un agente virtual de pedido de camisas. ¿Le puedo ayudar en algo?"
					    ]
				    }
			    }]
		    }
      }]
    }"
    EOT
  }

  depends_on = [
    google_dialogflow_cx_agent.agent
  ]
}