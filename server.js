const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const app = express();
const PORT = process.env.PORT || 3000;
const ENVIRONMENT = process.env.NODE_ENV || 'development';
const VERSION = process.env.APP_VERSION || '1.0.0';

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Routes
app.get('/', (req, res) => {
  res.json({
    service: 'Account API',
    product_line: 'Account',
    vertical: 'API',
    environment: ENVIRONMENT,
    version: VERSION,
    description: 'Account management API for handling relationships between accounts and organizations',
    timestamp: new Date().toISOString(),
    status: 'healthy'
  });
});

app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: 'account-api',
    environment: ENVIRONMENT,
    version: VERSION,
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

app.get('/accounts', (req, res) => {
  res.json({
    accounts: [
      { id: 1, name: 'Business Account', type: 'business', status: 'active' },
      { id: 2, name: 'Customer Account', type: 'customer', status: 'active' },
      { id: 3, name: 'Payment Provider', type: 'provider', status: 'active' }
    ],
    environment: ENVIRONMENT,
    total: 3
  });
});

app.listen(PORT, () => {
  console.log(`Account API running on port ${PORT} in ${ENVIRONMENT} environment`);
});

module.exports = app;