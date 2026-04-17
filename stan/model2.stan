data {
  int<lower=1> N; 
  int<lower=1> P; 
  int<lower=1> T;
  array[N] int winner; 
  array[N] int loser; 
  array[N] int period;
}
parameters {
  matrix[P-1, T] beta_raw;
  real<lower=0> tau;
}
transformed parameters {
  matrix[P, T] beta;
  beta[1,] = rep_row_vector(0, T);
  beta[2:P,] = beta_raw;
}
model {
  tau ~ normal(0, 0.5);
  beta_raw[,1] ~ normal(0, 3);
  for (t in 2:T) beta_raw[,t] ~ normal(beta_raw[,t-1], tau);
  for (n in 1:N) {
    1 ~ bernoulli_logit(beta[winner[n], period[n]] - beta[loser[n], period[n]]);
  }
}
generated quantities {
  vector[N] log_lik;
  vector[N] p_pred;
  for (n in 1:N) {
    real lp = beta[winner[n], period[n]] - beta[loser[n], period[n]];
    log_lik[n] = bernoulli_logit_lpmf(1 | lp);
    p_pred[n]  = inv_logit(lp);
  }
}