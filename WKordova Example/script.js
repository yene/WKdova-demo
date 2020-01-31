// Make sure you check if window.plugins exists.

// DOMContentLoaded is not needed if the script is loaded with defer
document.addEventListener("DOMContentLoaded", function() {
  setBody(window.plugins.device)
});


function setBody(value) {
  console.log('setbody to', value)
  var d = document.getElementById("body")
  d.innerHTML = JSON.stringify(value, null, 2)
}

function setImage(base64) {
  if (base64 === null) {
    return;
  }

  var image = document.getElementById("image");
  image.onload = function() {
    setBody(this.width + 'x' + this.height)
  };
  image.src = 'data:image/jpeg;base64,' + base64;
}

function logBrowse() {
  window.plugins.mDNS.browse('_ipp._tcp', (services) => {
    for (const s of services) {
      console.log(s)
    }
  });
}


