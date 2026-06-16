# Salesforce Omni-Channel Case Routing
### Note: Routing configuration is regarding the work items(what will be there size and the priority and the model), presence configuration is about the agents (How much is there capacity), presence status (indicate when they’re online and available to receive work items from a specific service channel, or whether they’re away or offline.) service channel (selecting the objects : Route work from a Salesforce object, such as cases, chats, leads, or even custom objects, to support agents.) Queues (here we select the routing configuration because work items are present) 

Service Channel      = What can be routed?
Queue                = Where does work wait?
Routing Configuration = How is work distributed?
Presence Status      = Who can receive work?
Presence Configuration = How much work can they receive?
## Overview

This project demonstrates how Salesforce Service Cloud automatically routes Cases to the correct support agents using:

- Case Assignment Rules
- Queues
- Omni-Channel
- Service Channels
- Routing Configurations
- Presence Statuses
- Presence Configurations

The goal is to eliminate manual case assignment and ensure support requests are delivered to the right agent in real time.

---

# Business Scenario

When a customer creates a Case:

- If `Issue_Category__c = Bug`, the Case should be routed to the **Engineering Escalations** queue.
- All other Cases should be routed to the **Tier 1 Support** queue.

Once the Case reaches the appropriate queue, Omni-Channel identifies an available agent and pushes the Case directly to them.

---

# Architecture

```text
Customer Creates Case
        │
        ▼
Case Assignment Rule
        │
        ├── Bug
        │      ▼
        │ Engineering Escalations Queue
        │
        └── Other Issues
               ▼
          Tier 1 Support Queue
               │
               ▼
       Routing Configuration
               │
               ▼
          Omni-Channel
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

# How Components Are Connected

## 1. Case Assignment Rule → Queue

### Purpose

Determines where a Case should be routed.

### Example

```text
Issue_Category__c = Bug
```

Assign To:

```text
Engineering Escalations Queue
```

### What Happens

When a Bug Case is created:

```text
Case
  ↓
Assignment Rule
  ↓
Engineering Escalations Queue
```

The Queue becomes the Case Owner.

---

## 2. Queue → Routing Configuration

### Purpose

Tells Salesforce how work should be distributed once it reaches the queue.

### Configuration

Inside Queue:

| Field | Value |
|---------|---------|
| Routing Type | Omni-Channel |
| Routing Configuration | Case Routing |

### Relationship

```text
Queue
  ↓
Routing Configuration
```

### Why It Is Required

Without this connection:

```text
Case
 ↓
Queue
```

The Case remains in the queue and is never delivered to an agent.

---

## 3. Routing Configuration → Omni-Channel

### Purpose

Defines how Omni-Channel selects an agent.

### Example

Agent A:

```text
8/10 Capacity Used
```

Agent B:

```text
2/10 Capacity Used
```

Routing Model:

```text
Most Available
```

Result:

```text
Agent B receives the Case
```

### Configuration

| Field | Value |
|---------|---------|
| Name | Case Routing |
| Routing Priority | 1 |
| Routing Model | Most Available |
| Units of Capacity | 1 |

---

## 4. Service Channel → Salesforce Object

### Purpose

Tells Omni-Channel which object can be routed.

### Configuration

| Field | Value |
|---------|---------|
| Service Channel Name | Cases |
| Salesforce Object | Case |

### Relationship

```text
Service Channel
      ↓
Case Object
```

### Why It Is Required

Without a Service Channel, Omni-Channel cannot recognize Cases as routeable work.

---

## 5. Presence Status → Service Channel

### Purpose

Defines what type of work an agent can receive.

### Example

Status:

```text
Available for Cases
```

Associated Channel:

```text
Cases
```

### Relationship

```text
Presence Status
        ↓
Service Channel
```

### Why It Is Required

This tells Salesforce:

```text
User can receive Cases
```

---

## 6. Presence Configuration → Presence Status

### Purpose

Defines workload capacity for agents.

### Example

```text
Capacity = 10
```

Each Case:

```text
Consumes 1 Unit
```

Agent can handle:

```text
10 Cases
```

### Relationship

```text
Presence Status
        ↓
Presence Configuration
```

### Why It Is Required

Prevents agents from receiving more work than they can handle.

---

## 7. User → Presence Status

### Purpose

Allows agents to indicate whether they are available.

### Example

User selects:

```text
Available for Cases
```

### Relationship

```text
User
 ↓
Presence Status
```

### Why It Is Required

Only available agents receive work.

---

# Complete Routing Flow

```text
Case Created
      │
      ▼
Case Assignment Rule
      │
      ▼
Queue
      │
      ▼
Routing Configuration
      │
      ▼
Omni-Channel
      │
      ▼
Available Agent
      │
      ▼
Case Delivered
```

---

# Implementation Steps

## Step 1: Enable Omni-Channel

### Navigation

```text
Setup → Omni-Channel Settings
```

### Configuration

| Field | Value |
|---------|---------|
| Enable Omni-Channel | True |

### Why

Activates Salesforce's routing engine.

---

## Step 2: Create Service Channel

### Navigation

```text
Setup → Service Channels → New
```

### Configuration

| Field | Value |
|---------|---------|
| Service Channel Name | Cases |
| Salesforce Object | Case |

### Why

Makes Cases available for Omni-Channel routing.

---

## Step 3: Create Presence Configuration

### Navigation

```text
Setup → Presence Configurations → New
```

### Configuration

| Field | Value |
|---------|---------|
| Name | Support Agents |
| Capacity | 10 |
| Routing Model | Most Available |

### Why

Defines agent workload limits.

---

## Step 4: Create Presence Status

### Navigation

```text
Setup → Presence Statuses → New
```

### Configuration

| Field | Value |
|---------|---------|
| Status Name | Available for Cases |
| Service Channel | Cases |

### Why

Allows agents to receive Case work.

---

## Step 5: Create Queues

### Navigation

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

### Why

Acts as the routing destination for Cases.

---

## Step 6: Create Routing Configuration

### Navigation

```text
Setup → Routing Configurations → New
```

### Configuration

| Field | Value |
|---------|---------|
| Name | Case Routing |
| Routing Priority | 1 |
| Routing Model | Most Available |
| Units of Capacity | 1 |

### Why

Determines how Omni-Channel selects agents.

---

## Step 7: Connect Queues to Omni-Channel

Open each queue and configure:

| Field | Value |
|---------|---------|
| Routing Type | Omni-Channel |
| Routing Configuration | Case Routing |

### Why

Enables Cases in the queue to be routed to agents.

---

## Step 8: Create Case Assignment Rule

### Navigation

```text
Setup → Case Assignment Rules
```

### Rule Name

```text
Support Routing
```

### Rule Entry 1

| Field | Value |
|---------|---------|
| Criteria | Issue_Category__c = Bug |
| Assign To | Engineering Escalations Queue |
| Order | 1 |

### Rule Entry 2

| Field | Value |
|---------|---------|
| Criteria | All Other Cases |
| Assign To | Tier 1 Support Queue |
| Order | 2 |

### Why

Automatically sends Cases to the correct queue.

---

## Step 9: Add Omni-Channel Utility

### Navigation

```text
Setup → App Manager
→ Service Console
→ Edit
→ Utility Bar
→ Add Omni-Channel
```

### Why

Allows agents to receive and accept incoming work.

---

# Test Scenario

## Case 1

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

## Case 2

### Input

```text
Subject: Password Reset Request
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
- Capacity-Based Agent Assignment
- Real-Time Agent Notifications
- Faster Support Response Times
- Improved Agent Productivity

The solution ensures that every Case reaches the most appropriate available support agent with minimal manual effort.
