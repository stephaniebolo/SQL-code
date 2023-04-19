

--cleaning original dataset by changing the datatype of date_joined column to date, and creating a new column last_valuation_upd with datatype numeric from column last_valuation
UPDATE unicorns
SET date_joined = replace(date_joined,'/','-')

UPDATE unicorns
SET date_joined = todate(date_joined,'mm-dd-yyyy')

ALTER TABLE unicorns
ADD COLUMN last_valuation_upd TEXT;
UPDATE unicorns SET last_valuation_upd = SPLIT_PART(last_valuation,'',2);
ALTER TABLE unicorns
ALTER COLUMN last_valuation_upd TYPE NUMERIC USING (last_valuation_upd::numeric);

ALTER TABLE unicorns
DROP COLUMN last_valuation



--created a new column rank which stores the rank of the company based on its last evaluation
ALTER TABLE unicorns
ADD COLUMN RANK TEXT;
UPDATE unicorns
SET RANK = CASE 
	WHEN last_valuation_upd < 10 THEN 'low'
	WHEN last_valuation_upd BETWEEN 10 AND 20 THEN 'middle'
	when last_valuation_upd > 20 THEN 'high'
END;



--finalized the rest of the data preparation for future analysis
CREATE TABLE us_unicorns AS SELECT * FROM unicorns

DELETE FROM us_unicorns
WHERE CITY IN ('Tokyo','Dublin')