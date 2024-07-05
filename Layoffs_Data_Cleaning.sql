SELECT * FROM layoffs;

-- Remove Duplicates
-- Standardize the data
-- NUll values or blank values
-- Remove Any Columns

create table layoffs_staging
like layoffs;layoffs_staging

SELECT * FROM layoffs_staging;


-- INSERTING DATA FROM LAYOFFS TO LAYOFFS_STAGING
INSERT layoffs_staging
SELECT * FROM layoffs;

SELECT *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, 'date') As row_num
FROM layoffs_staging;

with duplicate_cte as(
SELECT *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, 'date',stage, country,funds_raised_millions) As row_num
FROM layoffs_staging
)select *
From duplicate_cte
where row_num >1

-- CHECKING IF the companies are twice or more
-- SELECT * FROM layoffs_staging where company = "casper";


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_staging2;

-- INSETING DATA FROM LAYOFF_STAGING TO LAYOFF_STAGING2

insert into layoffs_staging2
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, 'date',stage, country,funds_raised_millions) As row_num
FROM layoffs_staging;

SELECT * FROM layoffs_staging2;

delete 
FROM layoffs_staging2
WHERE row_num > 1;

SELECT * FROM layoffs_staging2;


-- Standardizeing data

SELECT company, TRIM(company) FROM layoffs_staging2;
    

UPDATE layoffs_staging2 
SET company = TRIM(company);


SELECT DISTINCT industry 
FROM layoffs_staging2
order by 1;

-- we can see crypto, crypto currency and different same industry name so lets check crypto

SELECT *
FROM layoffs_staging2
WHERE industry like 'Crypto%';

UPDATE layoffs_staging2
set industry = 'Crypto'
WHERE industry like 'crypto%';


-- LOCATION Removing the '.' from two same row United state
select distinct country, trim(Trailing '.' from country)
from layoffs_staging2
order by 1;

-- Now Updatign the US. row with use
update layoffs_staging2
set country = trim(Trailing '.' from country)
where country like 'United States%';

select distinct country
from layoffs_staging2
order by 1;

-- Date is in text form we have to do it in time format

Select `date`from layoffs_staging2;

-- Update date in new form
update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y')


-- Changing text definition of Date colomn to DATE

ALTER table layoffs_staging2 
Modify column `date` Date;

-- Select * from layoffs_staging2;

Select *
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;

-- making all blank industry types as NULL
UPDATE layoffs_staging2
set industry = NULL
where industry = '';


-- Selecting industries which are NULL or Blank

select * 
from layoffs_staging2
where industry is NULL
or industry = '';

-- Checking if black industry company have another row

Select * from layoffs_staging2
where company = 'Airbnb';

-- IF company has different layoffs then industry should be same

Select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is NULL or t1.industry = '')
and t2.industry is NOT nULL;

-- Updating the industry of same company with same industry type

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is NULL
and t2.industry is NOT NULL;

--  we check if any company has industry NULL and Ballys comes so fix it
select * 
from layoffs_staging2
where company like 'Bally%'; -- only one row with null row

-- Data cleaning for Total_laid off and percentage_laid_off
Select *
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;

delete
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;

Select *
from layoffs_staging2;

-- We dont need the row_num column anymore so remove it "Drop a column"
alter table layoffs_staging2
drop column row_num;

Select *
from layoffs_staging2;




