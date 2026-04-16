# Bayesian Modelling of ATP Tennis Player Skill from Match Outcomes

**STAT 405 Final Project — Jensen Suhenda (44377570)**

This project applies Bayesian latent-skill models to professional ATP tennis match outcomes, estimating player ability and evaluating whether surface-specific and time-varying skill extensions improve predictive performance.

---

## Research Questions

1. Can a Bayesian latent-skill model recover meaningful player rankings from binary match outcomes?
2. Do surface-specific skill effects improve predictive performance?
3. Does time-varying skill improve match outcome predictions?

---

## Repository Structure

```
bayesian-tennis-model/
├── report/
│   └── STAT405_Report.Rmd       # 4-page PDF submission
├── data_cleaning/
│   └── wrangling_eda.Rmd                  # Full data wrangling, EDA, and subsetting rationale
├── stan/
│   ├── model1.stan              # Bradley-Terry + surface effects
│   └── model2.stan              # Time-varying skill (random walk)
├── df_model.csv                 # Cleaned modelling dataset (output of wrangling_eda.Rmd)
├── atp_tennis.csv               # Raw ATP match data (2000–2026)
└── README.md
```

---

## Models

### Baseline: Bradley-Terry

Each player $i$ is assigned a latent skill $\beta_i$. The probability that player $i$ beats player $j$ is:

$$\text{logit}(p_{ij}) = \beta_i - \beta_j, \qquad \beta_i \sim \mathcal{N}(0, 9)$$

### Model 1: Surface-Specific Skill

Adds a player-surface interaction term $\gamma_{i,s}$ to capture performance differences across Hard, Clay, Grass, and Carpet courts:

$$\text{logit}(p_{ij,s}) = (\beta_i + \gamma_{i,s}) - (\beta_j + \gamma_{j,s}), \qquad \gamma_{i,s} \sim \mathcal{N}(0, \tau_\gamma^2)$$

### Model 2: Time-Varying Skill

Models player skill as a random walk across seasons $t$:

$$\beta_{i,t} = \beta_{i,t-1} + \varepsilon_{i,t}, \qquad \varepsilon_{i,t} \sim \mathcal{N}(0, \tau^2), \qquad \tau \sim \text{HalfNormal}(0.5)$$

---

## Data

**Source:** [ATP Tennis Dataset on Kaggle](https://www.kaggle.com/datasets/dissfya/atp-tennis-2000-2023daily-pull) — ~67,000 ATP matches from 2000–2026.

**Modelling subset:** Top 50 most active players, 2014–2026. Restricted for two reasons:
- **Sparsity** — most player pairs have never met, leaving $\beta_i$ poorly identified for infrequent players.
- **Computational cost** — Stan's HMC scales with the number of parameters; 1,000+ players × 12 seasons is intractable.

See `wrangling_data/eda.Rmd` for the full wrangling pipeline, sparsity analysis, and subsetting rationale.

---

## Dependencies

| Package | Purpose |
|---|---|
| `rstan` | HMC posterior inference |
| `dplyr`, `tidyr` | Data wrangling |
| `lubridate` | Date parsing |
| `ggplot2` | Visualisation |
| `knitr` | Report generation |
| `bayesplot` | MCMC diagnostics |

R version: 4.3+. Stan version: 2.26+.

---

## References

- Bradley, R. A., & Terry, M. E. (1952). Rank analysis of incomplete block designs. *Biometrika*, 39(3–4), 324–345.
- Glickman, M. E. (1999). Parameter estimation in large dynamic paired comparison experiments. *JRSS-C*, 48(3), 377–394.
- Baker, R. D., & McHale, I. G. (2014). A dynamic paired comparisons model. *European J. Operational Research*, 236(2), 677–684.
- Herbrich, R., Minka, T., & Graepel, T. (2006). TrueSkill: A Bayesian skill rating system. *NeurIPS*, 19.

