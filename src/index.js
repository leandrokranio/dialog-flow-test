/*
 *  @function httpHelloWorld
 *  @param {object} req object received from the caller
 *  @param {object} res object created in response to the request
 */
var http = require("./http-request");

const main = async (req, res) => {
  console.log("Testing...");
  const advice = await http.request();
  const tag = req.body.fulfillmentInfo.tag;
  let message = tag || req.query.message || req.body.message || "Hello World";
  const json_response = {
    fulfillment_response: {
      messages: [
        {
          text: {
            text: [advice],
          },
        },
      ],
    },
  };

  console.log("Response", JSON.stringify(json_response));

  res.status(200).send(json_response);
};
module.exports = { main };
