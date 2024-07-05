-- Exploratory Data Analysis

select *
from layoffs_staging2;

select MAX(total_laid_off),MAX(percentage_laid_off)
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions DESC; -- Decending order of total_laid_off

select company, sum(total_laid_off)
from layoffs_staging2
group by company    -- group by 
order by 2 desc;

select min(`date`), max(`date`)
from layoffs_staging2;

select country, sum(total_laid_off)
from layoffs_staging2
group by country    -- group by 
order by 2 desc;

-- By date or Year Group by
select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)    -- group by 
order by 1 desc;

-- By the Stage
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage    -- group by 
order by 2 desc;


-- Group by Month
select substring(`date`,1,7) as `Month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not NULL
group by `Month`    -- group by 
order by 1 asc;


-- Rolling Total
with rolling_total as
(
select substring(`date`,1,7) as `Month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not NULL
group by `Month`    -- group by 
order by 1 asc
)
select `Month`, total_off , SUM(total_off) over(order by `Month`) as rolling_total
from rolling_total;

select company, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)    -- group by 
order by 3 desc;

-- Ranking company for each years layoffs count
with company_year(company,years, total_laid_off) as
(
select company, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)    -- group by 
), company_year_rank as
(select *, dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *
from company_year_rank
where ranking <= 5
;









