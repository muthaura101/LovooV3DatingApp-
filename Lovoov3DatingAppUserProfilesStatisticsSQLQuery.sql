-- SOURCE OF DATA IS KAGGLE. Link <https://www.kaggle.com/datasets/thedevastator/lovoo-v3-dating-app-user-profiles-and-statistics>-- 
--This is an Historical Data Collected In The Year 2015 From A Dating App Called Lovoo Which is Widely Popular In Europe.
--The Data Collected Was Fully Treated With With Absolute Anonimity. No Personal Data Of Any User Was Used.  
-- I Credit Jeffrey Mvutu Mabilama For Providing the Dataset In Kaggle

--View The Two Tables--

SELECT DISTINCT *
FROM LovooV3_DatingApp..usersapi_results$

SELECT DISTINCT *
FROM LovooV3_DatingApp..users_instances$

--Perform INNER JOIN To Create One Table--

SELECT DISTINCT
	usersapi_results$.Name, usersapi_results$.Age, usersapi_results$.Gender, usersapi_results$.Desired_gender, usersapi_results$.Country,
	usersapi_results$.Counts_pictures, usersapi_results$.Counts_profileVisits, usersapi_results$.Counts_likes, usersapi_results$.FlirtInterests_chat,
	usersapi_results$.FlirtInterests_date, usersapi_results$.FlirtInterests_friends, usersapi_results$.VIP, usersapi_results$.Influencer, usersapi_results$.Verified,
	usersapi_results$.Lang_count, usersapi_results$.Lang_English, usersapi_results$.Lang_French, usersapi_results$.Lang_German, usersapi_results$.Lang_Italian,
	usersapi_results$.Lang_Portuguese, usersapi_results$.Lang_Spanish, usersapi_results$.Flirtstar, usersapi_results$.Highlighted, usersapi_results$.Distance,
	usersapi_results$.Mobile, usersapi_results$.ShareProfile_Enabled
FROM LovooV3_DatingApp..usersapi_results$
INNER JOIN LovooV3_DatingApp..users_instances$
	ON usersapi_results$.Name = users_instances$.Name 


--I WILL IMPORT THE RESULTS INTO AN EXCEL WORKBOOK CALLED "DatingApp_Data"--

--Remove Duplicates In The New Data. Here I Used Python Jupyter and Saved The Data In Another Workbook Called "CleanDatingApp_Data"--

--View the new table "CleanDatingApp_Data" Which I have renamed to "V3_Data$"--
SELECT *
FROM LovooV3_DatingApp..V3_Data$


--I Will Use The New Table To Carry Out EDA--

--#1) Calculate Basic Statistics--
SELECT
	ROUND(AVG(Age), 0) AS Average_Age, ROUND(AVG(Counts_pictures),0) AS Avg_Pics, ROUND(AVG(Counts_likes), 0) AS Avg_Likes, 
	ROUND(AVG(Lang_count), 0) AS Avg_Lang, ROUND(AVG(Distance),0) AS Avg_Distance, ROUND(AVG(Counts_profileVisits),0) AS Avg_ProfileVisits,
	MIN (Age) AS Min_Age, MIN(Counts_pictures) AS Min_Pictures, MIN(Counts_likes) AS Min_Likes, MIN(Lang_count) AS Min_Num_Lang, MIN(Distance) AS Min_Distance,
	MAX(Age) AS Max_Age, MAX(Counts_pictures) AS Max_Pictures, MAX(Counts_likes) AS Max_Likes, MAX(Lang_count) AS Max_Num_Lang, MAX(Distance) AS Max_Distance
FROM LovooV3_DatingApp..V3_Data$

-- Investigate Who Speaks More Than The 6 Languages That Are Provided In The Data--
SELECT *
FROM 
	LovooV3_DatingApp..V3_Data$
WHERE
	Lang_count >6
-- I Want To Assume That The Error Was Done During Data Entry. Therefore, I Will Delete The Two Entries--

-- Get Total Number of Users Per Country--
SELECT
	Country,
	COUNT(*) AS Total_Users
FROM
	LovooV3_DatingApp..V3_Data$
GROUP BY 
	Country
ORDER BY 
	Total_Users DESC

--Calculate The Average Likes, Profile Yisits, Pictures and Number Of Languages Spoken Per Age Group--
SELECT
	Age,
	COUNT(*) AS Total_Users,
	ROUND(AVG(Counts_profileVisits),0) AS Avg_ProfileVisits,
	ROUND(AVG(Counts_likes), 0) AS Avg_Likes,
	ROUND(AVG(Counts_pictures),0) AS Avg_Pics,
	ROUND(AVG(Lang_count), 0) AS Avg_Lang
FROM
	LovooV3_DatingApp..V3_Data$
GROUP BY
	Age
ORDER BY
	Age ASC

--How Many Users According To Age Are Interested To Chat, Go On A Date Or Be Friends--
SELECT
	Age,
	COUNT(CASE WHEN FlirtInterests_chat = 'TRUE' THEN 'TRUE' END) AS Total_Want_Chat,
	COUNT(CASE WHEN FlirtInterests_date = 'TRUE' THEN 'TRUE' END) AS Total_Want_Dates,
	COUNT(CASE WHEN FlirtInterests_friends = 'TRUE' THEN 'TRUE' END) AS Total_Want_Friends
FROM
	LovooV3_DatingApp..V3_Data$
GROUP BY
	Age
ORDER BY 
	Age ASC

-- How Many Users According To Age Are Not Interested To Chat, Go On A Date Or Be Friends
SELECT
	Age,
	COUNT(CASE WHEN FlirtInterests_chat = 'FALSE' THEN 'FALSE' END) AS Total_DontWant_Chat,
	COUNT(CASE WHEN FlirtInterests_date = 'FALSE' THEN 'FALSE' END) AS Total_DontWant_Dates,
	COUNT(CASE WHEN FlirtInterests_friends = 'FALSE' THEN 'FALSE' END) AS Total_DontWant_Friends
FROM
	LovooV3_DatingApp..V3_Data$
GROUP BY
	Age
ORDER BY 
	Age ASC

-- Get Percentage Of Those With Interest And Without Interest--
SELECT 
	Age, 
   ROUND(100.0 * SUM(CASE WHEN FlirtInterests_chat = 1 THEN 1 ELSE 0 END) / COUNT(*),2) AS Percent_WantChat,
   ROUND(100.0 * SUM(CASE WHEN FlirtInterests_chat = 0 THEN 1 ELSE 0 END) / COUNT(*),2) AS Percent_DontWantChat,
   ROUND(100.0 * SUM(CASE WHEN FlirtInterests_date = 1 THEN 1 ELSE 0 END) / COUNT(*),2) AS Percent_WantDate,
   ROUND(100.0 * SUM(CASE WHEN FlirtInterests_date = 0 THEN 1 ELSE 0 END) / COUNT(*),2) AS Percent_DontWantDate,
   ROUND(100.0 * SUM(CASE WHEN FlirtInterests_friends = 1 THEN 1 ELSE 0 END) / COUNT(*),2) AS Percent_WantFriends,
   ROUND(100.0 * SUM(CASE WHEN FlirtInterests_friends = 0 THEN 1 ELSE 0 END) / COUNT(*),2) AS Percent_DontWantFriends
FROM 
	LovooV3_DatingApp..V3_Data$
GROUP BY 
	Age
ORDER BY
	Age

--How Many Users Are VIPS, Verified, Influencers, Are Flirtstars, Have Enabled Profile Sharing And Are Using Mobile Phones and Vice Vera?--

SELECT
	Age,
	COUNT(CASE WHEN VIP = 'TRUE' THEN 'TRUE' END) AS Total_VIPs,
	COUNT(CASE WHEN VIP = 'FALSE' THEN 'FALSE' END) AS Total_NOTVIPS,
	COUNT(CASE WHEN Influencer = 'TRUE' THEN 'TRUE' END) AS Total_Influencers,
	COUNT(CASE WHEN Influencer = 'FALSE' THEN 'FALSE' END) AS Total_NOTInfluencers,
	COUNT(CASE WHEN  Verified = 'TRUE' THEN 'TRUE' END) AS Total_VerifiedProfile,
	COUNT(CASE WHEN  Verified = 'FALSE' THEN 'FALSE' END) AS Total_NOTVerifiedProfile,
	COUNT(CASE WHEN  Flirtstar = 'TRUE' THEN 'TRUE' END) AS Total_Flirtstars,
	COUNT(CASE WHEN  Flirtstar = 'FALSE' THEN 'FALSE' END) AS Total_NOTFlirtstar,
	COUNT(CASE WHEN  Highlighted = 'TRUE' THEN 'TRUE' END) AS Total_HighlitedProfile,
	COUNT(CASE WHEN  Highlighted = 'FALSE' THEN 'FALSE' END) AS Total_NOTHighlitedProfile,
	COUNT(CASE WHEN  Mobile = 'TRUE' THEN 'TRUE' END) AS Total_UseMobile,
	COUNT(CASE WHEN  Mobile = 'FALSE' THEN 'FALSE' END) AS Total_DONTUseMobile,
	COUNT(CASE WHEN  ShareProfile_Enabled = 'TRUE' THEN 'TRUE' END) AS Total_ShareableProfile,
	COUNT(CASE WHEN  ShareProfile_Enabled = 'FALSE' THEN 'FALSE' END) AS Total_NonShareableProfile
FROM
	LovooV3_DatingApp..V3_Data$
GROUP BY
	Age
ORDER BY 
	Age ASC

--What Is Total Profile Visits Per Age Group? And Compare The Results To Other Variables.
SELECT
	Age,
	SUM(Counts_profileVisits) AS Total_ProfileVisits,
	ROUND(100*SUM(Counts_profileVisits)/SUM(SUM(Counts_profileVisits)) OVER(),2) AS Percent_ProfileVisits,
	SUM(Counts_likes) AS Total_LikesonProfile,
	ROUND(100*SUM(Counts_likes)/SUM(SUM(Counts_likes)) OVER(),2) AS Percent_LikesonProfile,
	SUM(Counts_pictures) AS SUM_PicturesInProfile,
	ROUND(100*SUM(Counts_pictures)/SUM(SUM(Counts_pictures)) OVER(),2) AS Percent_PicturesInProfile
FROM
	LovooV3_DatingApp..V3_Data$
GROUP BY
	Age
ORDER BY
	Percent_ProfileVisits DESC

--By looking at the data I can see that likes received on an individuals received contributed to how frequently others visited there profile--
--It doesn't seem that the amount of pictures posted in the profile directly affect the frequency of how others visit your profile--
--Therefore, I am making the assumption that in pictures quality surpasses quantity--
--However, I have to investigate the correlation between the variables using statistical methods.

--Does Speaking More Languages Increase The Frequency Of Profile Visits?
SELECT
	ROUND(AVG(Counts_profileVisits),2) AS Avg_ProfileVisits,
	Lang_count
FROM
	LovooV3_DatingApp..V3_Data$
GROUP BY
	Lang_count
ORDER BY
	Avg_ProfileVisits DESC
--Speaking more Languages doesn't necessarily increase the frequency of profile visits

--Combine All Results Into One Query To Get Data For Visualization.
SELECT
	Age,
	COUNT(*) AS Total_Users,
	SUM(Counts_profileVisits) AS Total_ProfileVisits,
	ROUND(AVG(Counts_profileVisits),0) AS Avg_ProfileVisits,
	ROUND(100*SUM(Counts_profileVisits)/SUM(SUM(Counts_profileVisits)) OVER(),2) AS Percent_ProfileVisits,
	ROUND(AVG(Counts_likes), 0) AS Avg_Likes,
	ROUND(100*SUM(Counts_likes)/SUM(SUM(Counts_likes)) OVER(),2) AS Percent_LikesonProfile,
	ROUND(AVG(Counts_pictures),0) AS Avg_Pics,
	ROUND(100*SUM(Counts_pictures)/SUM(SUM(Counts_pictures)) OVER(),2) AS Percent_PicturesInProfile,
	ROUND(100.0 * SUM(CASE WHEN FlirtInterests_chat = 1 THEN 1 ELSE 0 END) / COUNT(*),2) AS Percent_WantChat,
	ROUND(100.0 * SUM(CASE WHEN FlirtInterests_chat = 0 THEN 1 ELSE 0 END) / COUNT(*),2) AS Percent_DontWantChat,
	ROUND(100.0 * SUM(CASE WHEN FlirtInterests_date = 1 THEN 1 ELSE 0 END) / COUNT(*),2) AS Percent_WantDate,
	ROUND(100.0 * SUM(CASE WHEN FlirtInterests_date = 0 THEN 1 ELSE 0 END) / COUNT(*),2) AS Percent_DontWantDate,
	ROUND(100.0 * SUM(CASE WHEN FlirtInterests_friends = 1 THEN 1 ELSE 0 END) / COUNT(*),2) AS Percent_WantFriends,
	ROUND(100.0 * SUM(CASE WHEN FlirtInterests_friends = 0 THEN 1 ELSE 0 END) / COUNT(*),2) AS Percent_DontWantFriends,
	COUNT(CASE WHEN VIP = 'TRUE' THEN 'TRUE' END) AS Total_VIPs,
	COUNT(CASE WHEN VIP = 'FALSE' THEN 'FALSE' END) AS Total_NOTVIPS,
	COUNT(CASE WHEN Influencer = 'TRUE' THEN 'TRUE' END) AS Total_Influencers,
	COUNT(CASE WHEN Influencer = 'FALSE' THEN 'FALSE' END) AS Total_NOTInfluencers,
	COUNT(CASE WHEN  Verified = 'TRUE' THEN 'TRUE' END) AS Total_VerifiedProfile,
	COUNT(CASE WHEN  Verified = 'FALSE' THEN 'FALSE' END) AS Total_NOTVerifiedProfile,
	COUNT(CASE WHEN  Flirtstar = 'TRUE' THEN 'TRUE' END) AS Total_Flirtstars,
	COUNT(CASE WHEN  Flirtstar = 'FALSE' THEN 'FALSE' END) AS Total_NOTFlirtstar,
	COUNT(CASE WHEN  Highlighted = 'TRUE' THEN 'TRUE' END) AS Total_HighlitedProfile,
	COUNT(CASE WHEN  Highlighted = 'FALSE' THEN 'FALSE' END) AS Total_NOTHighlitedProfile,
	COUNT(CASE WHEN  Mobile = 'TRUE' THEN 'TRUE' END) AS Total_UseMobile,
	COUNT(CASE WHEN  Mobile = 'FALSE' THEN 'FALSE' END) AS Total_DONTUseMobile,
	COUNT(CASE WHEN  ShareProfile_Enabled = 'TRUE' THEN 'TRUE' END) AS Total_ShareableProfile,
	COUNT(CASE WHEN  ShareProfile_Enabled = 'FALSE' THEN 'FALSE' END) AS Total_NonShareableProfile
FROM
	LovooV3_DatingApp..V3_Data$
GROUP BY
	Age
ORDER BY
	Percent_ProfileVisits DESC

-- I WILL IMPORT THE RESULTS INTO AN EXCEL WORKBOOK CALLED "Lovoo_Results"--