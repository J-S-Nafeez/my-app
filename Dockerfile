# ==========================================
# Multi-Stage Build for Minimum Attack Surface
# ==========================================

# Stage 1: Build & Dependency Resolution
FROM node:20-alpine AS dependencies
WORKDIR /app
COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci --only=production; else npm install --omit=dev; fi

# Stage 2: Hardened, Unprivileged Runtime Container
FROM alpine:3.20 AS runner
WORKDIR /app

# Install Node.js runtime and ca-certificates
RUN apk --no-cache add nodejs ca-certificates \
    && addgroup -S appgroup \
    && adduser -S appuser -G appgroup

# Copy dependencies and application source
COPY --from=dependencies /app/node_modules ./node_modules
COPY --chown=appuser:appgroup server.js package.json ./

# Run as non-root user
USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

CMD ["node", "server.js"]
