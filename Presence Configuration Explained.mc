# Presence Configuration Explained

## What is a Presence Configuration?

A Presence Configuration defines:

1. How much work an agent can handle.
2. How Omni-Channel interacts with the agent.
3. Whether agents can decline work.
4. What happens when work times out.
5. Which users or profiles can use the configuration.

Think of it as the **agent-side settings** of Omni-Channel.

---

## Relationship with Other Components

```text
Case
 ↓
Queue
 ↓
Routing Configuration
 ↓
Omni-Channel
 ↓
Presence Status
 ↓
Presence Configuration
 ↓
Agent
```

### Important Difference

**Routing Configuration**

Determines:

```text
How work is distributed
```

**Presence Configuration**

Determines:

```text
How much work an agent can receive
```

---

## Presence Configuration Name

### Value

```text
Support Agents
```

### Purpose

The display name visible to administrators.

This identifies the configuration assigned to support agents.

---

## Developer Name

### Value

```text
Support_Agents
```

### Purpose

API name used internally by Salesforce.

Mainly used for:

* Metadata deployments
* APIs
* Change Sets

---

## Capacity

### Value

```text
10
```

### Purpose

Defines the maximum amount of work an agent can handle simultaneously.

### Example

Agent Capacity:

```text
10
```

Routing Configuration:

```text
Units of Capacity = 5
```

Result:

```text
10 ÷ 5 = 2 Cases
```

The agent can receive two cases.

---

### Another Example

Agent Capacity:

```text
10
```

Case Work Size:

```text
1
```

Result:

```text
10 Cases
```

---

### Why It Matters

Without capacity limits:

```text
Agent receives unlimited work
```

which can overload agents.

---

## Interruptible Capacity

### Purpose

Used when agents can switch between different types of work.

Example:

```text
Voice Call
Chat
Case
```

A higher-priority item may interrupt lower-priority work.

### For This Project

Not required.

Standard Case Routing does not typically use interruptible capacity.

---

## Automatically Accept Work Requests

### Purpose

Automatically accepts incoming work without requiring agent interaction.

### Enabled

```text
Case Assigned
 ↓
Automatically Opened
```

### Disabled

```text
Case Assigned
 ↓
Agent Clicks Accept
```

### Recommendation

For demos:

```text
Disabled
```

This allows the audience to see the Omni notification.

---

## Allow Agents to Decline Work Requests

### Purpose

Allows agents to reject incoming work.

### Enabled

Agent sees:

```text
Accept
Decline
```

### Disabled

Agent only sees:

```text
Accept
```

### Example

If an agent is about to leave for lunch:

```text
Decline
```

and another agent receives the Case.

---

## Update Status on Decline

### Purpose

Changes the agent's Presence Status after declining work.

### Example

Current Status:

```text
Available for Cases
```

After Decline:

```text
Away
```

### Why

Prevents work from immediately being sent back to the same agent.

---

## Allow Agents to Choose a Decline Reason

### Purpose

Allows agents to specify why they rejected work.

### Example

```text
Busy
Meeting
Training
Lunch Break
```

### Benefits

Provides supervisors with visibility into routing behavior.

---

## Update Status on Push Timeout

### Purpose

Changes an agent's status if they ignore incoming work.

### Example

Agent receives:

```text
New Case
```

No response for:

```text
30 seconds
```

Status automatically changes to:

```text
Away
```

### Why

Prevents inactive agents from continuously receiving work.

---

# Audio Settings

## Play a Notification Sound for Work Requests

### Purpose

Plays an alert sound when new work arrives.

### Example

```text
Case Assigned
 ↓
Sound Plays
```

### Why

Ensures agents notice incoming work immediately.

---

## Notification Sound

### Available Options

```text
Default
Custom
```

### Recommended

```text
Default
```

for demonstration environments.

---

## Sound Length

### Purpose

Defines how long the notification plays.

### Example

```text
5 Seconds
```

### Maximum

```text
30 Seconds
```

---

## Play Notification Sound if Omni Loses Connection

### Purpose

Alerts agents when Omni-Channel disconnects.

### Example

```text
Internet Lost
 ↓
Sound Alert
```

### Why

Agents become aware that work may not be routed correctly.

---

# After Conversation Work Time

## Purpose

Provides wrap-up time after conversations.

### Example

Agent finishes:

```text
Chat
Voice Call
Messaging Session
```

Salesforce waits:

```text
30 Seconds
```

before routing new work.

### For This Project

Not required because Cases do not typically use wrap-up time.

---

# Transfer Destinations

## Purpose

Determines where agents can transfer work.

### Types

* Profiles
* Queues
* Flows

---

## Transfer to Queue

### Example

Tier 1 Agent receives:

```text
Password Issue
```

During investigation:

```text
Product Bug Identified
```

Agent transfers Case to:

```text
Engineering Escalations Queue
```

---

## Transfer to Profile

### Example

Transfer work directly to users with:

```text
System Administrator Profile
```

---

## Transfer to Flow

### Example

Agent transfers work to:

```text
Case Escalation Flow
```

which automatically performs additional routing.

---

# Assign Users

## Purpose

Specifies individual users who use this Presence Configuration.

### Example

```text
Jay Service
Tim Service
Brenda Service
```

These users inherit:

```text
Capacity = 10
```

and all other configuration settings.

---

# Assign Profiles

## Purpose

Assigns the Presence Configuration to entire profiles.

### Selected Profiles

```text
System Administrator
Einstein Agent User
```

### Why

Every user with these profiles automatically receives:

* Capacity Settings
* Decline Rules
* Omni Permissions

without needing individual assignments.

---

# Configuration Used in This Project

| Field                        | Value                |
| ---------------------------- | -------------------- |
| Presence Configuration Name  | Support Agents       |
| Developer Name               | Support_Agents       |
| Capacity                     | 10                   |
| Automatically Accept Work    | No                   |
| Allow Agents to Decline Work | Yes                  |
| Notification Sound           | Default              |
| Assigned Profile             | System Administrator |
| Assigned Profile             | Einstein Agent User  |

---

# Real-World Example

Agent Sarah has:

```text
Presence Configuration = Support Agents
Capacity = 10
```

Routing Configuration:

```text
Case Routing
Units of Capacity = 5
```

Sarah receives:

```text
Case #1
```

Capacity Remaining:

```text
5
```

Sarah receives:

```text
Case #2
```

Capacity Remaining:

```text
0
```

Omni-Channel stops assigning additional Cases until one of the existing Cases is completed or reassigned.

This ensures workload balancing and prevents agent overload.
