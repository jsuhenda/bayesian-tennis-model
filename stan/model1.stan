data {
  int<lower=1> N; 
  int<lower=1> P; 
  int<lower=1> S;
  array[N] int winner; 
  array[N] int loser; 
  array[N] int surface;
}
parameters {
  vector[P-1] beta_raw;
  matrix[P, S] gamma_raw;
  real<lower=0> tau_gamma;
}
transformed parameters {
  vector[P] beta;
  beta[1] = 0; beta[2:P] = beta_raw;
  matrix[P, S] gamma;
  for (p in 1:P) gamma[p,] = gamma_raw[p,] - mean(gamma_raw[p,]);
}
model {
  beta_raw ~ normal(0, 3);
  tau_gamma ~ normal(0, 1);
  to_vector(gamma_raw) ~ normal(0, tau_gamma);
  for (n in 1:N) {
    real lp = beta[winner[n]] + gamma[winner[n], surface[n]]
            - beta[loser[n]]  - gamma[loser[n],  surface[n]];
    1 ~ bernoulli_logit(lp);
  }
}
generated quantities {
  vector[N] log_lik;
  vector[N] p_pred;
  for (n in 1:N) {
    real lp = beta[winner[n]] + gamma[winner[n], surface[n]]
            - beta[loser[n]]  - gamma[loser[n],  surface[n]];
    log_lik[n] = bernoulli_logit_lpmf(1 | lp);
    p_pred[n]  = inv_logit(lp);
  }
}