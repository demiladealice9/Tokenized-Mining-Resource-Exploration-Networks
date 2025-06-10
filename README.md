# Tokenized Mining Resource Exploration Networks

A comprehensive blockchain-based system for managing mining exploration activities, built on the Stacks blockchain using Clarity smart contracts.

## Overview

This system provides a decentralized platform for mining companies to register, submit exploration data, coordinate investments, and ensure environmental compliance. The platform tokenizes mining exploration activities, enabling transparent and efficient resource management.

## Core Components

### 1. Mining Company Verification Contract
- **Purpose**: Validates and registers mining exploration companies
- **Features**:
    - Company registration with license verification
    - Owner-based verification system
    - Company status tracking
    - License number validation

### 2. Exploration Data Contract
- **Purpose**: Manages geological exploration data storage and access
- **Features**:
    - Secure data submission with hash verification
    - Location-based data storage (latitude/longitude)
    - Public/private access controls
    - Data verification system
    - Company data counting

### 3. Resource Assessment Contract
- **Purpose**: Assesses mineral resource potential through certified assessors
- **Features**:
    - Certified assessor management
    - Mineral grade estimation
    - Confidence level tracking
    - Assessment verification
    - Multiple mineral type support

### 4. Investment Coordination Contract
- **Purpose**: Coordinates exploration investments and funding
- **Features**:
    - Investment opportunity creation
    - Minimum investment thresholds
    - Funding target tracking
    - Investor balance management
    - Deadline-based funding periods

### 5. Environmental Compliance Contract
- **Purpose**: Ensures exploration environmental compliance
- **Features**:
    - Environmental assessor certification
    - Compliance record management
    - Requirement tracking
    - Status updates and monitoring
    - Expiry date management

## Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js and npm for testing

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd mining-exploration-network
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Contract Deployment

Deploy contracts in the following order:
1. Mining Company Verification
2. Exploration Data
3. Resource Assessment
4. Investment Coordination
5. Environmental Compliance

## Usage Examples

### Registering a Mining Company
\`\`\`clarity
(contract-call? .mining-company-verification register-company "Acme Mining Co" "LIC-12345")
\`\`\`

### Submitting Exploration Data
\`\`\`clarity
(contract-call? .exploration-data submit-exploration-data
u1 ;; company-id
45000000 ;; latitude (45.0 degrees * 1e6)
-75000000 ;; longitude (-75.0 degrees * 1e6)
"core-sampling" ;; exploration type
0x1234567890abcdef ;; data hash
true ;; public access
)
\`\`\`

### Creating Investment Opportunity
\`\`\`clarity
(contract-call? .investment-coordination create-investment-opportunity
u1 ;; company-id
u1000000 ;; target amount (1M tokens)
u1000 ;; minimum investment
u144000 ;; deadline (block height)
"Gold exploration in Northern Territory"
)
\`\`\`

## Data Structures

### Company Registration
- Company ID (unique identifier)
- Owner principal
- Company name
- License number
- Registration and verification dates
- Verification status

### Exploration Data
- Data ID (unique identifier)
- Company ID reference
- GPS coordinates (lat/lng)
- Exploration type
- Data hash for integrity
- Public access flag
- Verification status

### Resource Assessment
- Assessment ID
- Reference to exploration data
- Certified assessor
- Mineral type and grade
- Confidence level (0-100%)
- Verification status

### Investment Opportunity
- Opportunity ID
- Company reference
- Target and raised amounts
- Minimum investment threshold
- Deadline and status
- Description

### Compliance Record
- Record ID
- Company and data references
- Compliance type and status
- Assessment and expiry dates
- Certified assessor
- Notes and observations

## Security Features

- **Access Control**: Role-based permissions for different contract functions
- **Data Integrity**: Hash-based verification for exploration data
- **Certification System**: Verified assessors for resource and environmental assessments
- **Investment Protection**: Balance tracking and minimum investment requirements
- **Compliance Monitoring**: Expiry tracking and status updates

## Testing

The project includes comprehensive tests using Vitest:

\`\`\`bash
npm test
\`\`\`

Tests cover:
- Contract deployment and initialization
- Company registration and verification
- Data submission and retrieval
- Investment coordination
- Environmental compliance tracking
- Error handling and edge cases

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions and support, please open an issue in the GitHub repository.
