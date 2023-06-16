### Import Library
import pandas as pd
import numpy as np

### Import Dataset
Dating_df = pd.read_excel('D:/Data Analysis/Lovoo_v3_DatingApp_Data/DatingApp_Data.xlsx')
Dating_df.head(10)
Dating_df.info()

### Remove Duplicates 
aggregated_df = Dating_df.groupby(["Name","Age", "Gender","Desired_gender","Country", "Counts_profileVisits",
                                   "Counts_likes", "FlirtInterests_chat", "FlirtInterests_date", "FlirtInterests_friends",
                                   "VIP", "Influencer", "Verified","Lang_count", "Lang_English", "Lang_French", "Lang_German",
                                  "Lang_Italian", "Lang_Portuguese", "Lang_Spanish", "Flirtstar", "Highlighted", "Distance",
                                  "Mobile", "ShareProfile_Enabled"], 
                                  as_index = False)["Counts_pictures"].sum()
print(aggregated_df)
display(aggregated_df)
aggregated_df.shape

### Check If There Are Duplicates In The DataFrame named "aggregated_df"
duplicates = aggregated_df.duplicated(subset="Name")
if duplicates.any():
    print("Duplicates found in the 'Name' column.")
else:
    print("No duplicates found in the 'Name' column.")

### Identify Duplicate Rows In The DataFrame Named "aggregated_df"
duplicate_rows = aggregated_df[aggregated_df.duplicated(subset="Name", keep=False)]

### Display the rows with duplicates in the "Name" column
print(duplicate_rows)
#### Since This Doesn't Show Me All The Results, I will Check if There are Null Values Then I will Save The Data To An Excel File To Further Examine It.

### Check If There Is Missing Values Count Per Column
aggregated_df.isnull().sum()
####There Are No Missing Values

### Save the data to file
aggregated_df.to_excel('D:/Data Analysis/Lovoo_v3_DatingApp_Data/CleanDatingApp_Data.xlsx')

#### After Carefully Examining The Data I Have To Assume That The Remaining Duplicated Names Are Of Different Individuals Who Have The Same Name. 
#### I have come to this conclusion because my investigation in the excel file has made me realise that majority of the individuals with duplicated names come from different countries or have different ages or speak different languages. Therefore, I am highly confident that the data that I have is Sufficiently clean.


