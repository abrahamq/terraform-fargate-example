var fetch = require('node-fetch')

const makeRequest = () => {

  var rand = Math.random();

  var body = {
    "coords": [
      [-80.22969889370351+rand,26.182378101638278],
      [-80.2965610000189+Math.random(),26.20248009764265],
      [-80.30231165614974+Math.random(),26.179836222962763],
      [-80.22969889370351+rand,26.182378101638278]]
  }

  var promise = fetch("https://broward.flux.land/api/area", {
    "headers": {
      "accept": "*/*",
      "accept-language": "en-US,en;q=0.9,es;q=0.8",
      "cache-control": "no-cache",
      "content-type": "application/json",
      "pragma": "no-cache",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-origin"
    },
    "referrer": "https://broward.flux.land/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": JSON.stringify(body),
    "method": "POST",
    "mode": "cors"
  });
  return promise
}


const makeWaterTableRequest = () => {

  var body = {"lat":26.088775576531987+Math.random()} 
  return fetch("https://broward.flux.land/api/section/pointlat", {
    "headers": {
      "accept": "*/*",
      "accept-language": "en-US,en;q=0.9,es;q=0.8",
      "cache-control": "no-cache",
      "content-type": "application/json",
      "pragma": "no-cache",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-origin"
    },
    "referrer": "https://broward.flux.land/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": JSON.stringify(body),
    "method": "POST",
    "mode": "cors"
  });
}



const NUM_REQUESTS = 50

var promises = []
for (let i=0; i < NUM_REQUESTS; i++) {
  var promise = makeRequest();
  promises.push(promise)
  promise.then((res) => (console.dir(res.status)))
}

for (let i=0; i < NUM_REQUESTS; i++) {
  var promise = makeWaterTableRequest();
  promises.push(promise)
  promise.then((res) => (console.dir(res.status)))
}

Promise.all(promises).then((results) => {
  for (let res of results) {
    console.log(res.status)
  }
})

