USE marketing_campaign_db;
SELECT COUNT(*) FROM campaigns;
TRUNCATE TABLE campaigns;
SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/marketing_campaign_cleaned.csv'
INTO TABLE campaigns
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SELECT COUNT(*) FROM campaigns;
SELECT Campaign_ID, Date FROM campaigns LIMIT 5;

#.....sql queries execution....

#QUERY 1. List all campaigns run through Google Ads.
SELECT * FROM campaigns
WHERE Channel_Used = 'Google Ads';

#2. Find all campaigns with a Conversion_Rate greater than 0.10.
SELECT Campaign_ID, Company, Conversion_Rate
FROM campaigns
WHERE Conversion_Rate > 0.10;
#3. Get the total number of campaigns per Channel_Used.
SELECT Channel_Used, COUNT(*) AS Total_Campaigns
FROM campaigns
GROUP BY Channel_Used;
#4. Find the average Acquisition_Cost by Campaign_Type.
SELECT Campaign_Type, AVG(Acquisition_Cost) AS Avg_Acquisition_Cost
FROM campaigns
GROUP BY Campaign_Type;

#5. List the top 5 campaigns by ROI, highest first.
SELECT Campaign_ID, Company, ROI
FROM campaigns
ORDER BY ROI DESC
LIMIT 5;
#6. Find all distinct locations where campaigns ran
SELECT DISTINCT Location
FROM campaigns;

#7. Get total Clicks and total Impressions for each Location, sorted by highest Impressions.
SELECT Location, SUM(Clicks) AS Total_Clicks, SUM(Impressions) AS Total_Impressions
FROM campaigns
GROUP BY Location
ORDER BY Total_Impressions DESC;

#8. Find campaigns targeting "Men 18-24" with a Duration of "30 days".
SELECT Campaign_ID, Company, Target_Audience, Duration
FROM campaigns
WHERE Target_Audience = 'Men 18-24' AND Duration = '30 days';

#9. Find channels where the average Engagement_Score is above 5, ranked highest first.
SELECT Channel_Used, AVG(Engagement_Score) AS Avg_Engagement
FROM campaigns
GROUP BY Channel_Used
HAVING AVG(Engagement_Score) > 5
ORDER BY Avg_Engagement DESC;
#10. Find the single campaign with the highest Acquisition_Cost, and show all its details.
SELECT *
FROM campaigns
ORDER BY Acquisition_Cost DESC
LIMIT 1;

CREATE VIEW campaign_performance_view AS
SELECT 
    Campaign_ID,
    Company,
    Campaign_Type,
    Channel_Used,
    Location,
    Customer_Segment,
    Date,
    Conversion_Rate,
    Acquisition_Cost,
    ROI,
    Clicks,
    Impressions,
    Engagement_Score,
    RANK() OVER (PARTITION BY Channel_Used ORDER BY ROI DESC) AS ROI_Rank_In_Channel,
    AVG(ROI) OVER (PARTITION BY Channel_Used) AS Channel_Avg_ROI,
    SUM(Acquisition_Cost) OVER (PARTITION BY Company ORDER BY Date) AS Running_Company_Spend
FROM campaigns;

SELECT * FROM campaign_performance_view
WHERE Channel_Used = 'Google Ads'
ORDER BY ROI_Rank_In_Channel
LIMIT 10;

#business query
#1. Which channel delivers the best ROI overall?
SELECT Channel_Used, 
       ROUND(AVG(ROI), 2) AS Avg_ROI,
       ROUND(AVG(Conversion_Rate), 4) AS Avg_Conversion_Rate,
       COUNT(*) AS Campaign_Count
FROM campaigns
GROUP BY Channel_Used
ORDER BY Avg_ROI DESC;

#2. Which Campaign_Type is most cost-efficient (best ROI per rupee spent)?
SELECT Campaign_Type,
       ROUND(SUM(ROI * Acquisition_Cost) / SUM(Acquisition_Cost), 2) AS Weighted_ROI,
       ROUND(AVG(Acquisition_Cost), 2) AS Avg_Cost
FROM campaigns
GROUP BY Campaign_Type
ORDER BY Weighted_ROI DESC;

#3. Which locations are underperforming despite high spend?
SELECT Location,
       SUM(Acquisition_Cost) AS Total_Spend,
       ROUND(AVG(ROI), 2) AS Avg_ROI
FROM campaigns
GROUP BY Location
HAVING SUM(Acquisition_Cost) > (SELECT AVG(Acquisition_Cost) * 100 FROM campaigns)
ORDER BY Avg_ROI ASC;

#4. Does higher Engagement_Score actually correlate with higher Conversion_Rate?
SELECT 
    CASE 
        WHEN Engagement_Score >= 8 THEN 'High (8-10)'
        WHEN Engagement_Score >= 5 THEN 'Medium (5-7)'
        ELSE 'Low (0-4)'
    END AS Engagement_Tier,
    ROUND(AVG(Conversion_Rate), 4) AS Avg_Conversion_Rate,
    COUNT(*) AS Campaign_Count
FROM campaigns
GROUP BY Engagement_Tier
ORDER BY Avg_Conversion_Rate DESC;

#5. Which Customer_Segment is most valuable (best ROI + conversion combined)?
SELECT Customer_Segment,
       ROUND(AVG(ROI), 2) AS Avg_ROI,
       ROUND(AVG(Conversion_Rate), 4) AS Avg_Conversion_Rate
FROM campaigns
GROUP BY Customer_Segment
ORDER BY Avg_ROI DESC, Avg_Conversion_Rate DESC;

#6. Is campaign Duration linked to performance — do longer campaigns fatigue?
SELECT Duration,
       ROUND(AVG(ROI), 2) AS Avg_ROI,
       ROUND(AVG(Engagement_Score), 2) AS Avg_Engagement
FROM campaigns
GROUP BY Duration
ORDER BY Avg_ROI DESC;

#7. Month-over-month trend — is performance improving or declining over time?
SELECT DATE_FORMAT(Date, '%Y-%m') AS Month,
       ROUND(AVG(ROI), 2) AS Avg_ROI,
       SUM(Acquisition_Cost) AS Total_Spend
FROM campaigns
GROUP BY Month
ORDER BY Month;

#8. Bottom 10 campaigns by ROI — what do they have in common?
SELECT Campaign_ID, Company, Campaign_Type, Channel_Used, Location, ROI, Acquisition_Cost
FROM campaigns
ORDER BY ROI ASC
LIMIT 10;
