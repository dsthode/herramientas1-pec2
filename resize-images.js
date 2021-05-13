const resizer = require('responsive-images-resizer');
resizer('src/images/orig', 'src/images/build/', ['200', '400', '600', '800'])
  .then(() => {
    console.log('Done!');
  })
  .catch((err) => {
    console.log('err:', err);
  });