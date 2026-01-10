# Multi-stage build for Account API
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install --only=production

FROM node:18-alpine AS runtime

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

# Copy dependencies and source code
COPY --from=builder /app/node_modules ./node_modules
COPY --chown=nodejs:nodejs . .

# Set environment
ENV NODE_ENV=production
ENV PORT=3000

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Switch to non-root user
USER nodejs

# Start the application
CMD ["npm", "start"]