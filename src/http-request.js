var axios = require("axios");

const request = async () => {
  const res = await axios.get("https://api.adviceslip.com/advice");
  return res.data.slip.advice;
};

module.exports = { request };
