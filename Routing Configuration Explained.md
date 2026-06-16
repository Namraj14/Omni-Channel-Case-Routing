## Routing Configuration Explained

### Note: Here we select the priority of the work, routing model and the capacity of each work item

A Routing Configuration controls how Omni-Channel distributes work items to agents. It acts as the decision-making engine between a Queue and an Agent.

### Relationship in the Routing Flow

```text
Case
  ↓
Assignment Rule
  ↓
Queue
  ↓
Routing Configuration
  ↓
Omni-Channel
  ↓
Agent
```

When a Case reaches a Queue, Salesforce looks at the Routing Configuration attached to that Queue to determine which agent should receive the work item.

---

### Routing Configuration Name

**Value:** Case Routing

The user-friendly label displayed in Salesforce.

Example:

```text
Case Routing
```

This helps administrators identify the routing configuration.

---

### Developer Name

**Value:** Case_Routing

The API name used internally by Salesforce.

Example:

```text
Case_Routing
```

This value is primarily used in metadata deployments and integrations.

---

### Overflow Assignee

The user who receives work if Omni-Channel cannot successfully route it.

Example:

```text
Support Manager
```

#### Why is it used?

Suppose:

* No agents are online
* No agents have available capacity
* Work cannot be assigned

Instead of leaving the Case stuck indefinitely, Salesforce assigns it to the Overflow Assignee.

#### What happens if left blank?

The Case may remain in the Queue until an agent becomes available.

For simple demos, this field can usually be left blank.

---

### Search Scope

**Value:** User

Determines who can be selected in the Overflow Assignee lookup.

Options may include:

* User
* Queue

For most implementations:

```text
User
```

is sufficient.

---

### Routing Priority

**Value:** 1

Determines the order in which work items are routed when multiple queues contain pending work.

#### Example

Queue A:

```text
Priority = 1
```

Queue B:

```text
Priority = 5
```

Salesforce routes work from Queue A before Queue B.

#### Important

Lower numbers have higher priority.

```text
1 = Highest Priority
10 = Lower Priority
```

For critical support cases, use a lower number.

---

### Routing Model

**Value:** Most Available

Determines how Salesforce chooses an agent when multiple agents are eligible.

#### Available Options

##### Most Available

Routes work to the agent with the most remaining capacity.

Example:

```text
John
Capacity: 10
Current Work: 8
Available: 2
```

```text
Sarah
Capacity: 10
Current Work: 3
Available: 7
```

Result:

```text
Sarah receives the Case
```

because she has more available capacity.

---

##### Least Active

Routes work to the agent with the fewest open work items.

Example:

```text
John = 5 Cases
Sarah = 2 Cases
```

Result:

```text
Sarah receives the Case
```

because she is handling fewer records.

---

### Push Time-Out (seconds)

Defines how long an agent has to accept work.

Example:

```text
30 Seconds
```

Flow:

```text
Case Routed
     ↓
Agent Receives Notification
     ↓
30 Seconds Pass
     ↓
No Response
     ↓
Work Re-Routed
```

#### Recommended

```text
30 - 60 Seconds
```

For demos, 30 seconds works well.

---

### Drop Additional Skills Time-Out (seconds)

Used only for Skills-Based Routing.

After the specified time, Salesforce can remove optional skills and broaden the pool of eligible agents.

Example:

Required Skills:

```text
Product A
French
```

If no matching agent is found:

```text
Drop French
```

and try routing again.

#### For This Demo

Skills-Based Routing is not being used.

This field can be ignored.

---

### Capacity Type

**Value:** Inherited

Determines how Salesforce measures agent workload.

#### Inherited

Uses the capacity model defined elsewhere in Omni-Channel.

This is the most common setting and is suitable for most implementations.

---

### Use with Skills-Based Routing Rules

Determines whether Skills-Based Routing is enabled.

#### Disabled

Work is routed based on:

* Availability
* Capacity
* Routing Model

#### Enabled

Work is routed based on:

* Skills
* Availability
* Capacity

For this project:

```text
Disabled
```

---

### Units of Capacity

**Value:** 5

Defines how much agent capacity a single work item consumes.

#### Example

Agent Capacity:

```text
10
```

Case Work Item Size:

```text
5
```

Result:

```text
Agent can handle 2 Cases
```

because:

```text
10 ÷ 5 = 2
```

---

#### Another Example

Agent Capacity:

```text
10
```

Case Work Item Size:

```text
1
```

Result:

```text
Agent can handle 10 Cases
```

---

### Why This Matters

Suppose:

```text
Agent Capacity = 10
```

and

```text
Units of Capacity = 5
```

After receiving:

```text
Case 1
```

Agent Capacity Remaining:

```text
5
```

After receiving:

```text
Case 2
```

Agent Capacity Remaining:

```text
0
```

Omni-Channel stops routing additional work to that agent until capacity becomes available.

---

### Percentage of Capacity

Alternative to Units of Capacity.

Instead of specifying:

```text
5 Units
```

you specify:

```text
50%
```

Only one option can be used:

* Units of Capacity
  OR
* Percentage of Capacity

Not both.

For this implementation:

```text
Units of Capacity = 5
```

is used.
