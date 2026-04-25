USE home_credit;

CREATE INDEX idx_application_curr ON application_train(SK_ID_CURR);
CREATE INDEX idx_bureau_curr ON bureau(SK_ID_CURR);
CREATE INDEX idx_bureau_bureau ON bureau(SK_ID_BUREAU);
CREATE INDEX idx_bureau_balance_bureau ON bureau_balance(SK_ID_BUREAU);
CREATE INDEX idx_credit_card_balance_prev ON credit_card_balance(SK_ID_PREV);
CREATE INDEX idx_credit_card_balance_curr ON credit_card_balance(SK_ID_CURR);
CREATE INDEX idx_installments_payments_curr ON installments_payments(SK_ID_CURR);
CREATE INDEX idx_installments_payments_prev ON installments_payments(SK_ID_PREV);
CREATE INDEX idx_pos_cash_balance_prev ON pos_cash_balance(SK_ID_PREV);
CREATE INDEX idx_pos_cash_balance_curr ON pos_cash_balance(SK_ID_CURR);
CREATE INDEX idx_previous_application_prev ON previous_application(SK_ID_PREV);
CREATE INDEX idx_previous_application_curr ON previous_application(SK_ID_CURR);

SET sql_mode = '';

CREATE TABLE application_features AS
SELECT
	a.SK_ID_CURR AS SK_ID_CURR_a,
	(a.EXT_SOURCE_1 + a.EXT_SOURCE_2 + a.EXT_SOURCE_3) / 3 AS avg_ext_source_a,
    a.EXT_SOURCE_1 * a.EXT_SOURCE_2 * a.EXT_SOURCE_3 AS prod_ext_source_a,
    a.AMT_CREDIT / NULLIF(a.AMT_ANNUITY, 0) AS ratio_credit_annuity_a,
    a.AMT_ANNUITY / NULLIF(a.AMT_INCOME_TOTAL, 0) AS ratio_annuity_income_a
FROM application_train a;

CREATE TABLE bureau_features AS
SELECT
	b.SK_ID_CURR AS SK_ID_CURR_b,
    SUM(CASE WHEN b.CREDIT_ACTIVE = 'active' THEN 1 ELSE 0 END) AS amt_active_credits_b,
    SUM(CASE WHEN b.CREDIT_ACTIVE = 'closed' THEN 1 ELSE 0 END) AS amt_closed_credits_b,
    SUM(CASE WHEN b.CREDIT_CURRENCY = 'currency 1' THEN 1 ELSE 0 END) AS amt_currency1_credits_b,
    MIN(b.DAYS_CREDIT) AS oldest_credit_b,
    MAX(b.DAYS_CREDIT) AS youngest_credit_b,
    AVG(b.DAYS_CREDIT) AS avg_age_credit_b,
    MAX(b.CREDIT_DAY_OVERDUE) AS max_days_overdue_b,
    AVG(b.CREDIT_DAY_OVERDUE) AS avg_days_overdue_b,
    MIN(b.DAYS_CREDIT_ENDDATE) AS min_enddate_active_b,
    MAX(b.DAYS_CREDIT_ENDDATE) AS max_enddate_active_b,
    AVG(b.DAYS_CREDIT_ENDDATE) AS avg_enddate_active_b,
	MIN(b.DAYS_ENDDATE_FACT) AS min_enddate_closed_b,
    MAX(b.DAYS_ENDDATE_FACT) AS max_enddate_closed_b,
    AVG(b.DAYS_ENDDATE_FACT) AS avg_enddate_closed_b,
    MIN(b.AMT_CREDIT_MAX_OVERDUE) AS min_max_overdue_amt_b,
    MAX(b.AMT_CREDIT_MAX_OVERDUE) AS max_max_overdue_amt_b,
    AVG(b.AMT_CREDIT_MAX_OVERDUE) AS avg_max_overdue_amt_b,
    SUM(b.CNT_CREDIT_PROLONG) AS sum_prolonged_b,
    MIN(b.AMT_CREDIT_SUM) AS min_credit_sum_b,
    MAX(b.AMT_CREDIT_SUM) AS max_credit_sum_b,
    AVG(b.AMT_CREDIT_SUM) AS avg_credit_sum_b,
    MIN(b.AMT_CREDIT_SUM_DEBT) AS min_credit_debt_b,
    MAX(b.AMT_CREDIT_SUM_DEBT) AS max_credit_debt_b,
    AVG(b.AMT_CREDIT_SUM_DEBT) AS avg_credit_debt_b,
    MIN(b.AMT_CREDIT_SUM_LIMIT) AS min_credit_limit_b,
    MAX(b.AMT_CREDIT_SUM_LIMIT) AS max_credit_limit_b,
    AVG(b.AMT_CREDIT_SUM_LIMIT) AS avg_credit_limit_b,
	MIN(b.AMT_CREDIT_SUM_OVERDUE) AS min_credit_overdue_b,
    MAX(b.AMT_CREDIT_SUM_OVERDUE) AS max_credit_overdue_b,
    AVG(b.AMT_CREDIT_SUM_OVERDUE) AS avg_credit_overdue_b,
    SUM(CASE WHEN b.CREDIT_TYPE = 'Consumer credit' THEN 1 ELSE 0 END) AS amt_consumer_credits_b,
    SUM(CASE WHEN b.CREDIT_TYPE = 'Credit card' THEN 1 ELSE 0 END) AS amt_credit_cards_b,
    SUM(CASE WHEN b.CREDIT_TYPE IN ('Mortgage','Credit_card') THEN 0 ELSE 1 END) AS amt_other_credits_b,
	MIN(b.DAYS_CREDIT_UPDATE) AS min_days_update_b,
    MAX(b.DAYS_CREDIT_UPDATE) AS max_days_update_b,
    AVG(b.DAYS_CREDIT_UPDATE) AS avg_days_update_b,
	MIN(b.AMT_ANNUITY) AS min_annuity_b,
    MAX(b.AMT_ANNUITY) AS max_annuity_b,
    AVG(b.AMT_ANNUITY) AS avg_annuity_b,
    AVG(b.AMT_CREDIT_SUM_DEBT / NULLIF(b.AMT_CREDIT_SUM, 0)) AS avg_debt_to_credit_ratio_b
FROM bureau b
GROUP BY b.SK_ID_CURR;

CREATE TABLE bureau_balance_features AS
SELECT
	b.SK_ID_CURR AS SK_ID_CURR_bb,
    SUM(CASE WHEN bb.STATUS = '0' THEN 1 ELSE 0 END) AS amt_on_time_bb,
	SUM(CASE WHEN bb.STATUS = '1' THEN 1 ELSE 0 END) AS amt_30d_late_bb,
	SUM(CASE WHEN bb.STATUS = '2' THEN 1 ELSE 0 END) AS amt_60d_late_bb,
	SUM(CASE WHEN bb.STATUS = 'X' THEN 1 ELSE 0 END) AS amt_status_unknown_bb
FROM bureau_balance bb
LEFT JOIN bureau b USING (SK_ID_BUREAU)
GROUP BY b.SK_ID_CURR;

CREATE TABLE credit_card_balance_features AS
SELECT
	ccb.SK_ID_CURR AS SK_ID_CURR_ccb,
    COUNT(DISTINCT (ccb.SK_ID_PREV)) AS amt_credit_cards_ccb,
	MIN(ccb.AMT_BALANCE) AS min_balance_ccb,
    MAX(ccb.AMT_BALANCE) AS max_balance_ccb,
    AVG(ccb.AMT_BALANCE) AS avg_balance_ccb,
	MIN(ccb.AMT_CREDIT_LIMIT_ACTUAL) AS min_credit_limit_ccb,
    MAX(ccb.AMT_CREDIT_LIMIT_ACTUAL) AS max_credit_limit_ccb,
    AVG(ccb.AMT_CREDIT_LIMIT_ACTUAL) AS avg_credit_limit_ccb,
	MIN(ccb.AMT_DRAWINGS_ATM_CURRENT) AS min_drawings_atm_ccb,
    MAX(ccb.AMT_DRAWINGS_ATM_CURRENT) AS max_drawings_atm_ccb,
    AVG(ccb.AMT_DRAWINGS_ATM_CURRENT) AS avg_drawings_atm_ccb,
    AVG(ccb.AMT_DRAWINGS_OTHER_CURRENT) AS avg_drawings_other_ccb,
	MIN(ccb.AMT_DRAWINGS_POS_CURRENT) AS min_drawings_pos_ccb,
    MAX(ccb.AMT_DRAWINGS_POS_CURRENT) AS max_drawings_pos_ccb,
    AVG(ccb.AMT_DRAWINGS_POS_CURRENT) AS avg_drawings_pos_ccb,
    AVG(ccb.AMT_INST_MIN_REGULARITY) AS avg_inst_min_ccb,
    AVG(ccb.AMT_PAYMENT_CURRENT) AS avg_payment_ccb,
    AVG(ccb.AMT_INST_MIN_REGULARITY/NULLIF(ccb.AMT_PAYMENT_CURRENT, 0)) AS avg_ratio_inst_payment_ccb,
	MIN(ccb.AMT_PAYMENT_TOTAL_CURRENT) AS min_total_payment_ccb,
    MAX(ccb.AMT_PAYMENT_TOTAL_CURRENT) AS max_total_payment_ccb,
    AVG(ccb.AMT_PAYMENT_TOTAL_CURRENT) AS avg_total_payment_ccb,
    AVG(ccb.AMT_RECEIVABLE_PRINCIPAL) AS avg_receivable_ccb,
    AVG(ccb.AMT_TOTAL_RECEIVABLE) AS avg_total_receivable_ccb,
    AVG(ccb.CNT_DRAWINGS_ATM_CURRENT) AS avg_cnt_drawings_atm_ccb,
    AVG(ccb.CNT_DRAWINGS_CURRENT) AS avg_cnt_drawings_ccb,
    AVG(ccb.CNT_DRAWINGS_OTHER_CURRENT) AS avg_cnt_drawings_other_ccb,
    AVG(ccb.CNT_DRAWINGS_POS_CURRENT) AS avg_cnt_drawings_pos_ccb,
    AVG(ccb.CNT_INSTALMENT_MATURE_CUM) AS avg_cnt_installments_ccb,
    SUM(CASE WHEN ccb.NAME_CONTRACT_STATUS = 'Active' THEN 1 ELSE 0 END) AS amt_active_contracts_ccb,
    SUM(CASE WHEN ccb.NAME_CONTRACT_STATUS = 'Completed' THEN 1 ELSE 0 END) AS amt_completed_contracts_ccb,
    SUM(CASE WHEN ccb.NAME_CONTRACT_STATUS IN ('Active', 'Completed') THEN 0 ELSE 1 END) AS amt_other_contracts_ccb,
	AVG(ccb.SK_DPD) AS avg_dpd_ccb,
    AVG(ccb.SK_DPD_DEF) AS avg_dpd_def_ccb
FROM credit_card_balance ccb
GROUP BY ccb.SK_ID_CURR;

CREATE TABLE installments_payments_features AS
SELECT
	ip.SK_ID_CURR AS SK_ID_CURR_ip,
	MIN(ip.NUM_INSTALMENT_VERSION) AS min_instalment_version_ip,
    MAX(ip.NUM_INSTALMENT_VERSION) AS max_instalment_version_ip,
    AVG(ip.NUM_INSTALMENT_VERSION) AS avg_instalment_version_ip,
	AVG(ip.DAYS_ENTRY_PAYMENT - ip.DAYS_INSTALMENT) AS avg_days_overdue_ip,
    AVG(ip.AMT_INSTALMENT - ip.AMT_PAYMENT) AS avg_amt_underpaid_ip,
    AVG(ip.AMT_INSTALMENT) AS avg_amt_instalment_ip,
    AVG(ip.AMT_PAYMENT) AS avg_amt_payment_ip
FROM installments_payments ip
GROUP BY ip.SK_ID_CURR;

CREATE TABLE pos_cash_balance_features AS
SELECT
		pcb.SK_ID_CURR AS SK_ID_CURR_pcb,
        AVG(pcb.CNT_INSTALMENT) AS avg_cnt_instalments_pcb,
        AVG(pcb.CNT_INSTALMENT_FUTURE) AS avg_cnt_future_instalments_pcb,
        SUM(CASE WHEN pcb.NAME_CONTRACT_STATUS = 'Active' THEN 1 ELSE 0 END) AS amt_active_contracts_pcb,
        SUM(CASE WHEN pcb.NAME_CONTRACT_STATUS = 'Completed' THEN 1 ELSE 0 END) AS amt_completed_contracts_pcb,
        SUM(CASE WHEN pcb.NAME_CONTRACT_STATUS NOT IN ('Active','Completed') THEN 1 ELSE 0 END) AS amt_other_contracts_pcb,
        AVG(pcb.SK_DPD) AS avg_dpd_pcb,
		AVG(pcb.SK_DPD_DEF) AS avg_dpd_def_pcb
FROM pos_cash_balance pcb
GROUP BY pcb.SK_ID_CURR;

CREATE TABLE previous_application_features AS
SELECT
	pa.SK_ID_CURR AS SK_ID_CURR_pa,
    SUM(CASE WHEN pa.NAME_CONTRACT_TYPE = 'Cash loan' THEN 1 ELSE 0 END) / NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_cash_loans_pa,
    SUM(CASE WHEN pa.NAME_CONTRACT_TYPE = 'Consumer loan' THEN 1 ELSE 0 END) / NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_consumer_loans_pa,
    AVG(pa.amt_annuity) AS avg_annuity_pa,
    AVG(pa.AMT_APPLICATION/NULLIF(pa.AMT_CREDIT,0)) AS avg_ratio_application_credit_pa,
    AVG(pa.AMT_GOODS_PRICE/NULLIF(pa.AMT_CREDIT,0)) AS avg_ratio_goods_credit_pa,
    SUM(CASE WHEN pa.WEEKDAY_APPR_PROCESS_START IN ('SATURDAY','SUNDAY') THEN 1 ELSE 0 END) / NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_weekend_appl_pa,
    AVG(pa.HOUR_APPR_PROCESS_START) AS avg_hour_appl_pa,
    SUM(CASE WHEN pa.FLAG_LAST_APPL_PER_CONTRACT = 'N' THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_failed_appl_pa,
    SUM(pa.NFLAG_LAST_APPL_IN_DAY)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_last_appl_day_pa,
    AVG(pa.RATE_DOWN_PAYMENT) AS avg_rate_down_payment_pa,
    AVG(pa.RATE_INTEREST_PRIMARY) AS avg_rate_interest_pa,
    AVG(pa.RATE_INTEREST_PRIMARY-pa.RATE_INTEREST_PRIVILEGED) AS avg_diff_interest_privileged_pa,
    SUM(CASE WHEN pa.NAME_CASH_LOAN_PURPOSE IN ('XNA','XAP') THEN 1 ELSE 0 END) /NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_purpose_unknown_pa,
    SUM(CASE WHEN pa.NAME_CONTRACT_STATUS IN ('Approved') THEN 1 ELSE 0 END) /NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_approved_pa,
    AVG(pa.DAYS_DECISION) AS avg_days_decision_pa,
    SUM(CASE WHEN pa.NAME_PAYMENT_TYPE = "Cash through the bank" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_payment_cash_pa,
    SUM(CASE WHEN pa.NAME_PAYMENT_TYPE = "XNA" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_payment_unknown_pa,
    SUM(CASE WHEN pa.CODE_REJECT_REASON = "XAP" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_reject_xap_pa,
    SUM(CASE WHEN pa.CODE_REJECT_REASON = "HC" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_reject_hc_pa,
    SUM(CASE WHEN pa.NAME_TYPE_SUITE = "Unaccompanied" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_unaccompanied_pa,
    SUM(CASE WHEN pa.NAME_TYPE_SUITE IN ('Spouse, partner', 'Family') THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_accompanied_pa,
    SUM(CASE WHEN pa.NAME_CLIENT_TYPE = "Repeater" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_repeater_pa,
    SUM(CASE WHEN pa.NAME_CLIENT_TYPE = "New" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_new_client_pa,
    SUM(CASE WHEN pa.NAME_GOODS_CATEGORY = 'XNA' THEN 1 ELSE 0 END) / NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_goods_unknown_pa,
	SUM(CASE WHEN pa.NAME_GOODS_CATEGORY = 'Mobile' THEN 1 ELSE 0 END) / NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_goods_mobile_pa,
	SUM(CASE WHEN pa.NAME_GOODS_CATEGORY = 'Consumer Electronics' THEN 1 ELSE 0 END) / NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_goods_electronics_pa,
    SUM(CASE WHEN pa.NAME_PORTFOLIO = "POS" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_portfolio_pos_pa,
    SUM(CASE WHEN pa.NAME_PORTFOLIO = "Cash" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_portfolio_cash_pa,
    SUM(CASE WHEN pa.NAME_PRODUCT_TYPE = "XNA" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_product_unknown_pa,
    SUM(CASE WHEN pa.NAME_PRODUCT_TYPE = "x-sell" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_product_xsell_pa,
    SUM(CASE WHEN pa.CHANNEL_TYPE = "Credit and cash offices" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_channel_office_pa,
    SUM(CASE WHEN pa.CHANNEL_TYPE = "Country-wide" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_channel_countrywide_pa,
    SUM(CASE WHEN pa.CHANNEL_TYPE = "Regional / Local" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_channel_local_pa,
    AVG(NULLIF(pa.SELLERPLACE_AREA, -1)) AS avg_sellerplace_area_pa,
    SUM(CASE WHEN pa.SELLERPLACE_AREA = -1 THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_sellerplace_unknown_pa,
    SUM(CASE WHEN pa.NAME_SELLER_INDUSTRY = "XNA" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_seller_unknown_pa,
    SUM(CASE WHEN pa.NAME_SELLER_INDUSTRY = "Consumer electronics" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_seller_electronics_pa,
    SUM(CASE WHEN pa.NAME_SELLER_INDUSTRY = "Furniture" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_seller_furniture_pa,
    SUM(CASE WHEN pa.CNT_PAYMENT = 0 THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_zero_payment_pa,
    AVG(pa.CNT_PAYMENT) AS avg_cnt_payment_pa,
    SUM(CASE WHEN pa.NAME_YIELD_GROUP = "XNA" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_yield_unknown_pa,
    SUM(CASE WHEN pa.NAME_YIELD_GROUP = "high" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_yield_high_pa,
    SUM(CASE WHEN pa.NAME_YIELD_GROUP = "middle" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_yield_middle_pa,
    SUM(CASE WHEN pa.NAME_YIELD_GROUP = "low_normal" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_yield_low_normal_pa,
    SUM(CASE WHEN pa.NAME_YIELD_GROUP = "low_action" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_yield_low_action_pa,
	SUM(CASE WHEN pa.PRODUCT_COMBINATION = "POS industry with interest" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_pos_interest_pa,
    SUM(CASE WHEN pa.PRODUCT_COMBINATION = "POS industry without interest" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_pos_no_interest_pa,
    SUM(CASE WHEN pa.PRODUCT_COMBINATION = "Cash" THEN 1 ELSE 0 END)/NULLIF(COUNT(DISTINCT(pa.SK_ID_PREV)),0) AS share_cash_product_pa
FROM previous_application pa
GROUP BY pa.SK_ID_CURR;

CREATE TABLE home_credit_table AS
SELECT
	a.*,
    af.*,
	bf.*,
    bbf.*,
    ccbf.*,
    ipf.*,
    pcbf.*,
    paf.*
FROM application_train a
LEFT JOIN application_features af ON a.SK_ID_CURR = af.SK_ID_CURR_a
LEFT JOIN bureau_features bf ON a.SK_ID_CURR = bf.SK_ID_CURR_b
LEFT JOIN bureau_balance_features bbf ON a.SK_ID_CURR = bbf.SK_ID_CURR_bb
LEFT JOIN credit_card_balance_features ccbf ON a.SK_ID_CURR = ccbf.SK_ID_CURR_ccb
LEFT JOIN installments_payments_features ipf ON a.SK_ID_CURR = ipf.SK_ID_CURR_ip
LEFT JOIN pos_cash_balance_features pcbf ON a.SK_ID_CURR = pcbf.SK_ID_CURR_pcb
LEFT JOIN previous_application_features paf ON a.SK_ID_CURR = paf.SK_ID_CURR_pa;