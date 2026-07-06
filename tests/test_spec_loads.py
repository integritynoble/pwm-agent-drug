def test_agent_spec_valid():
    import pwm_agent_drug as pkg
    from pwm_agent_core import AgentSpec
    assert isinstance(pkg.AGENT, AgentSpec)
    assert pkg.AGENT.name == "drug-design"
    assert pkg.AGENT.capabilities == ("pwm-actions", "pwm-data", "drug-design",
        "compute-providers", "science-router")
