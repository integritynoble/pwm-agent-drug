# pwm-agent-drug

The PWM Drug-design agent — computational drug design and medicinal chemistry:
molecular docking, ADMET prediction, similarity search, and lead optimization,
grounded in the PWM registry of principles, digital twins, benchmarks, and
solutions. It runs on the shared `pwm-agent-core` runtime.

Install:

```bash
pip install pwm-agent-drug
```

Log in and run standalone:

```bash
pwm-drug login
pwm-drug
```

It also embeds into [AI4Science](https://github.com/integritynoble/AI4Science)
automatically once installed — AI4Science discovers it via the
`pwm_agent.specs` entry point, so `drug-design` shows up as a selectable
agent alongside the built-in modes with no extra configuration.
