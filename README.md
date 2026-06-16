# Omni-Channel-Case-Routing
Salesforce Service Cloud implementation demonstrating automated Case Assignment Rules, Queue-based routing, and Omni-Channel work distribution to support agents.


# Salesforce Omni-Channel Case Routing

## Overview

This project demonstrates automated Case Routing in Salesforce Service Cloud using Omni-Channel. The solution automatically assigns Cases to the appropriate Queue based on business rules and delivers them in real-time to available support agents.

## Business Scenario

A customer submits a support Case.

- If the Issue Category is **Bug**, the Case is routed to the **Engineering Escalations** queue.
- All other Cases are routed to the **Tier 1 Support** queue.

Once the Case reaches the queue, Omni-Channel identifies an available agent and pushes the Case directly to them for immediate action.

---

## Solution Architecture

```text
Customer Creates Case
        │
        ▼
Case Assignment Rule
        │
        ├── Issue Category = Bug
        │           │
        │           ▼
        │  Engineering Escalations Queue
        │
        └── All Other Cases
                    │
                    ▼
             Tier 1 Support Queue
                    │
                    ▼
             Omni-Channel Routing
                    │
                    ▼
             Available Agent
                    │
                    ▼
              Accept Work
                    │
                    ▼
              Case Opens
```

---

# Components

## 1. Omni-Channel

### Purpose

Omni-Channel is Salesforce's workload distribution engine. It automatically routes work items such as Cases to available agents.

### Why It Is Needed

Without Omni-Channel:

```text
Case → Queue
```

Agents must manually monitor queues and pick work.

With Omni-Channel:

```text
Case → Queue → Agent
```

Salesforce automatically delivers work to the appropriate agent.

---

## 2. Service Channel

### Purpose

A Service Channel tells Omni-Channel which Salesforce object can be routed.

### Example

```text
Object: Case
```

This tells Salesforce that Cases are eligible for Omni-Channel routing.

### Configuration

| Field | Value |
|---------|---------|
| Service Channel Name | Cases |
| Salesforce Object | Case |

### Why It Is Required

Without a Service Channel, Omni-Channel does not recognize Cases as routeable work items.

---

## 3. Presence Configuration

### Purpose

Defines agent workload capacity.

### Example

An agent can handle:

```text
10 Capacity Units
```

Each Case consumes:

```text
1 Capacity Unit
```

The agent can therefore work on up to 10 Cases simultaneously.

### Configuration

| Field | Value |
|---------|---------|
| Name | Support Agents |
| Capacity | 10 |
| Routing Model | Most Available |

### Why It Is Required

Prevents agents from being overloaded and helps Salesforce distribute work efficiently.

---

## 4. Presence Status

### Purpose

Determines whether an agent is available to receive work.

### Example

```text
Available for Cases
```

means:

```text
Agent can receive Cases
```

### Configuration

| Field | Value |
|---------|---------|
| Status Name | Available for Cases |
| Service Channel | Cases |

### Why It Is Required

Omni-Channel only routes work to agents with an active status.

---

## 5. Queue

### Purpose

A queue acts as a holding area for Cases before they are assigned to agents.

### Queues Created

#### Tier 1 Support

Handles:

- Password resets
- Billing questions
- General support inquiries

#### Engineering Escalations

Handles:

- Product defects
- Bugs
- Technical escalations

### Configuration

| Field | Value |
|---------|---------|
| Queue Name | Tier 1 Support |
| Supported Object | Case |
| Members | Support Users |

Repeat the same process for:

```text
Engineering Escalations
```

### Why It Is Required

Case Assignment Rules route Cases to queues. Without queues there is no routing destination.

---

## 6. Routing Configuration

### Purpose

Defines how Omni-Channel distributes work among agents.

### Example

Agent A:

```text
8/10 Capacity Used
```

Agent B:

```text
2/10 Capacity Used
```

Using the **Most Available** routing model, Salesforce routes the next Case to Agent B.

### Configuration

| Field | Value |
|---------|---------|
| Name | Case Routing |
| Routing Priority | 1 |
| Routing Model | Most Available |
| Units of Capacity | 1 |

### Why It Is Required

Omni-Channel requires routing logic to determine which agent should receive work.

---

## 7. Case Assignment Rule

### Purpose

Automatically assigns Cases to the correct queue.

### Rule Name

```text
Support Routing
```

### Rule Entry 1

#### Criteria

```text
Issue_Category__c = Bug
```

#### Action

```text
Assign to Engineering Escalations Queue
```

#### Order

```text
1
```

---

### Rule Entry 2

#### Criteria

```text
All Other Cases
```

#### Action

```text
Assign to Tier 1 Support Queue
```

#### Order

```text
2
```

### Why It Is Required

Ensures Cases are automatically categorized and routed without manual intervention.

---

# Implementation Steps

## Step 1: Enable Omni-Channel

Navigation:

```text
Setup → Omni-Channel Settings
```

Enable:

```text
Enable Omni-Channel
```

---

## Step 2: Create Service Channel

Navigation:

```text
Setup → Service Channels → New
```

Configuration:

| Field | Value |
|---------|---------|
| Service Channel Name | Cases |
| Salesforce Object | Case |

---

## Step 3: Create Presence Configuration

Navigation:

```text
Setup → Presence Configurations → New
```

Configuration:

| Field | Value |
|---------|---------|
| Name | Support Agents |
| Capacity | 10 |
| Routing Model | Most Available |

---

## Step 4: Create Presence Status

Navigation:

```text
Setup → Presence Statuses → New
```

Configuration:

| Field | Value |
|---------|---------|
| Status Name | Available for Cases |
| Service Channel | Cases |

---

## Step 5: Create Queues

Navigation:

```text
Setup → Queues → New
```

### Queue 1

| Field | Value |
|---------|---------|
| Queue Name | Tier 1 Support |
| Supported Object | Case |

### Queue 2

| Field | Value |
|---------|---------|
| Queue Name | Engineering Escalations |
| Supported Object | Case |

Add support users as members.

---

## Step 6: Create Routing Configuration

Navigation:

```text
Setup → Routing Configurations → New
```

Configuration:

| Field | Value |
|---------|---------|
| Name | Case Routing |
| Routing Priority | 1 |
| Routing Model | Most Available |
| Units of Capacity | 1 |

---

## Step 7: Configure Omni-Channel Routing on Queues

For both queues:

| Field | Value |
|---------|---------|
| Routing Type | Omni-Channel |
| Routing Configuration | Case Routing |

---

## Step 8: Create Case Assignment Rule

Navigation:

```text
Setup → Case Assignment Rules
```

Create:

```text
Support Routing
```

Activate the rule and add both rule entries.

---

## Step 9: Add Omni-Channel Utility

Navigation:

```text
Setup → App Manager
```

Edit Service Console App:

```text
Utility Bar → Add Utility Item → Omni-Channel
```

Save changes.

---

# Testing

## Test Scenario 1

### Input

```text
Subject: Export Failure
Issue Category: Bug
```

### Expected Result

```text
Engineering Escalations Queue
        ↓
Omni-Channel
        ↓
Available Agent
        ↓
Accept Work
```

---

## Test Scenario 2

### Input

```text
Subject: Password Reset Help
Issue Category: Access
```

### Expected Result

```text
Tier 1 Support Queue
        ↓
Omni-Channel
        ↓
Available Agent
        ↓
Accept Work
```

---

# Outcome

This implementation demonstrates:

- Automated Case Assignment
- Queue-Based Routing
- Omni-Channel Work Distribution
- Real-Time Agent Notifications
- Capacity-Based Workload Management
- Improved Support Response Times

The solution eliminates manual case assignment and ensures work is delivered to the most appropriate available support agent.
