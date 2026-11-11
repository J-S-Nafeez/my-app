# AWS DevSecOps Pipeline: Push to Amazon ECR

This project demonstrates a production-grade DevSecOps pipeline implementing:
- **Code Push Trigger** (GitHub Actions)
- **Secret Scanning** (Gitleaks)
- **Unit Testing** (Automated checks)
- **Multi-Stage Hardened Dockerfile** (Non-root user, minimal Alpine runtime)
- **Container Vulnerability Scanning** (Trivy failing on `CRITICAL` or `HIGH`)
- **Keyless AWS Authentication** (AWS OIDC - No permanent access keys)
- **Amazon ECR Push** (Tag immutability + KMS encryption + Scan on Push)

## Project Structure
```
aws-ecr-devsecops-pipeline/
├── .github/
│   └── workflows/
│       └── ci-ecr.yml       # GitHub Actions DevSecOps workflow
├── .dockerignore
├── Dockerfile               # Multi-stage security-hardened Dockerfile
├── package.json
├── server.js                # Express microservice with /health endpoint
└── test.js                  # Unit test script
```

## Step-by-Step Deployment Instructions

### 1. Add GitHub Repository Secret
Go to your GitHub repo $\rightarrow$ **Settings** $\rightarrow$ **Secrets and variables** $\rightarrow$ **Actions**:
- Click **New repository secret**:
  - **Name**: `AWS_IAM_ROLE_ARN`
  - **Value**: `arn:aws:iam::<AWS_ACCOUNT_ID>:role/GitHubActions-ECR-Push-Role`

### 2. Push Code to GitHub
Initialize the Git repository and push to your GitHub repo:
```bash
git init
git add .
git commit -m "feat: setup DevSecOps pipeline with security scans and ECR push"
git branch -M main
git remote add origin https://github.com/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>.git
git push -u origin main

```

### 3. Verify in GitHub and AWS
1. Open the **Actions** tab in GitHub to watch the pipeline execute.
2. In the AWS Console, open **Amazon ECR** $\rightarrow$ **Repositories** $\rightarrow$ `my-app` and verify the new image tagged with your Git commit SHA is present and scanned.
