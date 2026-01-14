-- 1. Revenue & Segment Analysis
-- Question: Which Occupation and Income Band contributes the most to the bank's total wealth (Deposits + Savings + Foreign Currency)?

select 
occupation, 
case when estimated_income <100000 then 'Low'
	 when estimated_income <300000 then 'Medium'
     when estimated_income >300000 then 'High'
     end as income_band,
     round(SUM(bank_deposits + saving_accounts + foreign_Currency_account),2) AS Total_Assets
FROM banking_case.customer
GROUP BY Occupation, case when estimated_income <100000 then 'Low'
	 when estimated_income <300000 then 'Medium'
     when estimated_income >300000 then 'High'
     end
ORDER BY Total_Assets DESC
LIMIT 10;

-- 2. Risk vs. Loyalty Performance
-- Question: Does a higher Loyalty Classification correlate with a lower Risk Weighting? (Validating if "Platinum" or "Jade" customers are actually safer).
SELECT 
loyalty_classification, 
AVG(risk_weighting) AS average_risk_score,
COUNT(*) AS Customer_Count
FROM banking_case.customer
GROUP BY loyalty_classification
ORDER BY average_risk_score ASC;

-- 3. Credit Card Utilization Analysis
-- -- Question: Which Nationality has the highest average Credit Card Balance relative to their Estimated Income?
SELECT 
    nationality, 
    round(AVG(credit_card_balance)) AS Avg_CC_Balance,
    round(AVG(estimated_income)) AS Avg_Income,
    round((AVG(credit_Card_balance) / AVG(estimated_income)) * 100 ,2)AS Debt_to_Income_Ratio
FROM customer
WHERE estimated_income > 0
GROUP BY nationality
HAVING COUNT(*) > 10
ORDER BY debt_to_income_ratio DESC;

-- 4. Relationship Manager/Branch Performance
-- Question: Which Branch (BRId) is managing the most Business Lending volume and how many Properties Owned are associated with that branch?
SELECT 
    BRId, 
    round(SUM(business_lending),2) AS Total_Business_Loans,
    SUM(properties_owned) AS Total_Properties_Collateral
FROM customer
GROUP BY BRId
ORDER BY total_business_loans DESC;

-- 5. The "High-Value Multi-Product" Analysis
-- Question: Which customers are "Power Users" (those who have a Bank Loan, a Credit Card, and a Savings Account) and what is their total liquidity versus their total debt?

SELECT 
    client_Id,
    name,
    occupation,
    case when estimated_income <100000 then 'Low'
	 when estimated_income <300000 then 'Medium'
     when estimated_income >300000 then 'High'
     end as income_band,
    -- Calculating Total Debt
    round((bank_loans +  credit_card_balance + business_lending),2) AS Total_Debt,
    -- Calculating Total Liquidity
    round((bank_deposits + checking_accounts + saving_accounts + foreign_currency_account),2) AS Total_Liquidity,
    -- Identifying Product Diversification
    amount_of_credit_cards,
    properties_owned
FROM customer
WHERE bank_loans > 0 
  AND saving_accounts > 0 
  AND credit_card_balance > 0
ORDER BY Total_Liquidity DESC
LIMIT 20;
-- select * from customer
