resource "null_resource" "default_start_flow" {
  # Use a REST API call (instead of Terraform) to modify messages and routes in
  # the default start flow and since Dialogflow creates this default start flow
  # automatically
  provisioner "local-exec" {
    command = <<-EOT
curl --location --request PATCH 'https://${self.triggers.LOCATION}-dialogflow.googleapis.com/v3/projects/${self.triggers.PROJECT}/locations/${self.triggers.LOCATION}/agents/${self.triggers.AGENT}/flows/${self.triggers.DEFAULT_START_FLOW}?updateMask=transitionRoutes' -H 'Authorization: Bearer ya29.c.b0AT7lpjCARrRa2TPceFXBLUzv27weLymmbhLomYn5bs5f4zZL7lR-Ri9f4YPbD1icR2tQcyVY4B67hR2Wt5-c2OWHLOG8qQ1c5rIoNe0icmUF69jnbFkPhENjQk7GqYfAP2jvWmHwSVbsi_ZI1BoEwHuwvrYk7Kysz1o9iveh22DV3tJlRe265hiBXX2mqupaOI_DkwSAnfkTLLVsDBEr9KaXIeTXJz8N232D6BRO6f2kd7WY0a1Vx6RYf1iBvvIa4aMloQxMw03dtclu6Foh2cwlmjJpZ_YchMfXl61h3fIb8U1cR3RBdlrIeVzF6jc2r8_8m83jij-BJM5IyudBqi-57FdlZZezmwfXQXeQvp4tkj34rRiba8rR0mRq-BUXnZjje9v654sB04UR_nU9BO82MO7oektORtUVnz6htxaFRslXSzOlVdl3lvFsVeRX70bk8OaobU3xfWoSq7_t0bFu8v7FjZM25olteOj-5vJbo297VXo7xJzv-z8lxhsUjBQOI6UY-42btQjxpMcp1I2RS3Rsw-l-bp9yw48kWJl4Mr2i6oY922m2w2kaocl02Z608FXwQZ8-VhB7myFWkwRgtn9j3j5052jjjXUWiIb0UJWwxr3howSOVg_bBwxgtnzwZdbs5hRizO08u0Xgy7OmYkt93qhav-foUVyx0sU741z2UhIZ30epRkyknUk5uizjx82aUy5131R9vIUnr1zZFWMn-o-iRn-7Wcvq3l9W2m_c-ssWsuBdFFR0sXV_VdYqm7syMtYgVO-eFVWp1Wj3n37Vzqbfn04ckhvQ1JJmQda4nnJ-ulwSRblVWXs9YFcS3uFj8UuWOVkewr8X5r5coReMor85wufUtn1Fmmjb2kkYfJcWcya457cw-vkWbmBtSFxSlyxaS6dxwms6U27he6y1Uqu25S93MiicoZ99VgZzaOBXn5Qbq6Y-eRYwiRY7ky8hVQagBBo17a7nSqwuk543wvFZOetrvvdl0XRxV31oZY2cJru' -H 'Content-Type: application/json' --data-raw '{"transitionRoutes":[{"intent":"projects/${self.triggers.PROJECT}/locations/${self.triggers.LOCATION}/agents/${self.triggers.AGENT}/intents/${self.triggers.DEFAULT_WELCOME_INTENT}","triggerFulfillment":{"messages":[{"text":{"text":["Hola, este es un agente virtual de pedido de camisas. ¿Le puedo ayudar en algo?"]}}]}},{"intent":"${self.triggers.STORE_HOURS_INTENT}","targetPage":"${self.triggers.STORE_HOURS_PAGE}"},{"intent":"${self.triggers.STORE_LOCATION_INTENT}","targetPage":"${self.triggers.STORE_LOCATION_PAGE}"},{"intent":"${self.triggers.NEW_ORDER_INTENT}","targetPage":"${self.triggers.NEW_ORDER_PAGE}"},{"intent":"${self.triggers.ORDER_CHANGE_INTENT}","targetPage":"${self.triggers.ORDER_CHANGE_PAGE}"},{"intent":"${self.triggers.GET_ADVICE_INTENT}","targetPage":"${self.triggers.GET_ADVICE_PAGE}"}]}'
EOT
}

  # Use triggers instead of environment variables so that they can be reused in
  # the provisioner to create routes as well as the destroy-time provisioner
  triggers = {
    always_run = "${timestamp()}"
    PROJECT                = var.project_id
    LOCATION               = var.region
    AGENT                  = google_dialogflow_cx_agent.agent.name
    DEFAULT_START_FLOW     = "00000000-0000-0000-0000-000000000000"
    DEFAULT_WELCOME_INTENT = "00000000-0000-0000-0000-000000000000"

    STORE_LOCATION_INTENT = google_dialogflow_cx_intent.store_location.id
    STORE_HOURS_INTENT    = google_dialogflow_cx_intent.store_hours.id
    NEW_ORDER_INTENT      = google_dialogflow_cx_intent.order_new.id
    ORDER_CHANGE_INTENT   = google_dialogflow_cx_intent.order_change.id
    GET_ADVICE_INTENT   = google_dialogflow_cx_intent.get_advice.id

    STORE_LOCATION_PAGE = google_dialogflow_cx_page.store_location.id
    STORE_HOURS_PAGE    = google_dialogflow_cx_page.store_hours.id
    NEW_ORDER_PAGE      = google_dialogflow_cx_page.new_order.id
    ORDER_CHANGE_PAGE   = google_dialogflow_cx_page.order_change.id
    GET_ADVICE_PAGE   = google_dialogflow_cx_page.get_advice.id

  }

  # Use a REST API call in a destroy-time provisioner to delete routes in the
  # default start flow since we created them with a REST API call, and Terraform
  # will fail to delete them since they are managed externally
  /* provisioner "local-exec" {
    when    = destroy
    command = <<EOT
curl --location --request PATCH 'https://${self.triggers.LOCATION}-dialogflow.googleapis.com/v3/projects/${self.triggers.PROJECT}/locations/${self.triggers.LOCATION}/agents/${self.triggers.AGENT}/flows/${self.triggers.DEFAULT_START_FLOW}?updateMask=transitionRoutes' -H 'Authorization: Bearer $(gcloud auth application-default print-access-token)' -H 'Content-Type: application/json' --data-raw "{"transitionRoutes": [{"intent": "projects/${self.triggers.PROJECT}/locations/${self.triggers.LOCATION}/agents/${self.triggers.AGENT}/intents/${self.triggers.DEFAULT_WELCOME_INTENT}","triggerFulfillment": {"messages": [{"text": {"text": ['Hola, este es un agente virtual de pedido de camisas. ¿Le puedo ayudar en algo?']}}]}}]}"
EOT
  } */

  depends_on = [
    google_dialogflow_cx_agent.agent
  ]
}