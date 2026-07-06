from pwm_agent_core import AgentSpec
from .prompts import PROMPT

AGENT = AgentSpec(
    name="drug-design",
    tier="science",
    category="specific",
    title="Drug design",
    description=(
        "Computational drug design: molecular docking, ADMET prediction, "
        "similarity search, lead optimization, and PWM registry benchmarking."
    ),
    keywords=("drug", "molecule", "ligand", "docking", "admet", "pharmacophore",
              "qsar", "binding", "protein", "target", "inhibitor", "scaffold",
              "lead", "fragment", "smiles", "rdkit", "vina", "fep", "generative"),
    system_prompt=PROMPT,
    capabilities=("pwm-actions", "pwm-data", "drug-design", "compute-providers",
                  "science-router"),
    aliases=("drug", "drug design", "docking", "medicinal chemistry", "cheminformatics"),
    order=10,
)
