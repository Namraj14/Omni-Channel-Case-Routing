# Where Should Routing Configuration Be Applied?

One of the most common questions when configuring Salesforce Omni-Channel is:

> Why does Salesforce allow Routing Configuration to be associated with both Service Channels and Queues?

The answer depends on the routing architecture being used.

Salesforce supports two primary Omni-Channel routing models:

1. Queue-Based Routing (Traditional Omni-Channel)
2. Flow-Based Routing / Enhanced Omni Routing

This project uses **Queue-Based Routing**.

---

# Understanding the Difference

## Queue-Based Routing

In Queue-Based Routing, work items are first assigned to a Queue and then routed to agents.

### Architecture

```text
Case
 ↓
Case Assignment Rule
 ↓
Queue
 ↓
Routing Configuration
 ↓
Omni-Channel
 ↓
Agent
```

### Example

Customer creates a Case:

```text
Issue Category = Bug
```

Case Assignment Rule:

```text
Bug
 ↓
Engineering Escalations Queue
```

Queue Configuration:

```text
Routing Type = Omni-Channel
Routing Configuration = Case Routing
```

Omni-Channel uses the Routing Configuration attached to the Queue to determine which agent should receive the Case.

### Why Configure Routing Configuration on the Queue?

The Queue acts as the source of work.

When a Case enters the Queue, Salesforce asks:

> Which routing logic should be used for work in this queue?

The Queue answers:

```text
Case Routing
```

The Routing Configuration then determines:

* Routing Model
* Agent Capacity Usage
* Work Distribution Rules
* Push Timeout Behavior

### Configuration Example

Queue:

| Field                 | Value                   |
| --------------------- | ----------------------- |
| Queue Name            | Engineering Escalations |
| Routing Type          | Omni-Channel            |
| Routing Configuration | Case Routing            |

---

# Service Channel Routing

In newer Salesforce implementations, work can be routed directly through Flows instead of Queues.

This is called:

* Enhanced Omni Routing
* Flow-Based Routing

### Architecture

```text
Case
 ↓
Flow
 ↓
Service Channel
 ↓
Routing Configuration
 ↓
Agent
```

In this model, work does not necessarily wait in a Queue.

Instead, a Flow determines how work should be routed and uses the Service Channel configuration.

### Why Configure Routing Configuration on the Service Channel?

The Service Channel becomes the routing entry point.

Salesforce asks:

> What routing logic should be used for this type of work?

The Service Channel provides the Routing Configuration.

### Example

Service Channel:

| Field                 | Value        |
| --------------------- | ------------ |
| Service Channel Name  | Cases        |
| Salesforce Object     | Case         |
| Routing Configuration | Case Routing |

This setup is typically used with Omni Flows rather than Assignment Rules and Queues.

---

# Which Model Is Used in This Project?

This implementation uses:

* Case Assignment Rules
* Queues
* Omni-Channel Queue Routing

Workflow:

```text
Customer Creates Case
 ↓
Case Assignment Rule
 ↓
Engineering Escalations Queue
or
Tier 1 Support Queue
 ↓
Routing Configuration
 ↓
Omni-Channel
 ↓
Available Agent
```

Because Cases are routed through Queues, the Routing Configuration is configured on the Queue.

---

# Configuration Used

## Service Channel

Purpose:

```text
Defines what object can be routed.
```

Configuration:

| Field                | Value |
| -------------------- | ----- |
| Service Channel Name | Cases |
| Salesforce Object    | Case  |

The Service Channel identifies the work type but does not control routing in this project.

---

## Routing Configuration

Configuration:

| Field                      | Value          |
| -------------------------- | -------------- |
| Routing Configuration Name | Case Routing   |
| Routing Priority           | 1              |
| Routing Model              | Most Available |
| Units of Capacity          | 5              |

Purpose:

```text
Determines how work is distributed among agents.
```

---

## Queue Configuration

Engineering Escalations Queue:

| Field                 | Value                   |
| --------------------- | ----------------------- |
| Queue Name            | Engineering Escalations |
| Routing Type          | Omni-Channel            |
| Routing Configuration | Case Routing            |

Tier 1 Support Queue:

| Field                 | Value          |
| --------------------- | -------------- |
| Queue Name            | Tier 1 Support |
| Routing Type          | Omni-Channel   |
| Routing Configuration | Case Routing   |

Purpose:

```text
Connects incoming work to the routing logic.
```

---

# Decision Guide

## Use Routing Configuration on the Queue When

You are using:

* Case Assignment Rules
* Queues
* Traditional Omni-Channel Routing

Architecture:

```text
Case
 ↓
Queue
 ↓
Routing Configuration
 ↓
Agent
```

This is the approach used in this project.

---

## Use Routing Configuration on the Service Channel When

You are using:

* Omni Flows
* Flow-Based Routing
* Enhanced Omni Routing

Architecture:

```text
Case
 ↓
Flow
 ↓
Service Channel
 ↓
Routing Configuration
 ↓
Agent
```

---

# Key Takeaway

For this project:

```text
Case Assignment Rule
 ↓
Queue
 ↓
Routing Configuration
 ↓
Omni-Channel
 ↓
Agent
```

Therefore:

✅ Routing Configuration is applied to the Queue.

❌ Routing Configuration on the Service Channel is not required for this implementation.

A simple rule to remember:

* **Using Queues → Configure Routing Configuration on the Queue**
* **Using Omni Flows → Configure Routing Configuration on the Service Channel**
