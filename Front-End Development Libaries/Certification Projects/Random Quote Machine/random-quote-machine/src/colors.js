var colorArray = [];

while (colorArray.length < 50) {
  colorArray.push(`rgb(${rand(0, 255)}, ${rand(0, 255)}, ${rand(0, 255)})`);
}

//Random number function
function rand(from, to) {
  return Math.floor(Math.random() * (to - from));
}

export { colorArray };
