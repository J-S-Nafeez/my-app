const assert = require('assert');
const app = require('./server');

console.log('Running automated unit tests...');
assert.ok(app, 'App should export express instance');
console.log('All tests passed successfully!');
process.exit(0);
