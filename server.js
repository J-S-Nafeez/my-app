const express = require('express');
const helmet = require('helmet');

const app = express();
const PORT = process.env.PORT || 8080;

// Security middleware
app.use(helmet());
app.use(express.json());

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    status: 'online',
    message: 'Welcome to DevSecOps AWS ECR Microservice',
    timestamp: new Date().toISOString()
  });
});

// Health check endpoint (Used by ECS, EKS, ALB)
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    uptime: process.uptime()
  });
});

if (require.main === module) {
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`Application running on port ${PORT}`);
  });
}

module.exports = app;
