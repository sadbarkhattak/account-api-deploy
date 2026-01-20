const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;
const ENVIRONMENT = process.env.NODE_ENV || 'development';
const VERSION = process.env.APP_VERSION || '1.0.0';

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Serve static files from public directory
app.use(express.static(path.join(__dirname, 'public')));

// Health check endpoint (must be before catch-all)
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

// API Routes (must be before catch-all)
app.get('/api', (req, res) => {
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

app.get('/api/accounts', (req, res) => {
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
  console.log(`Serving static files from: ${path.join(__dirname, 'public')}`);
});

module.exports = app;