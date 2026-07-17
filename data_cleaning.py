import pandas as pd

# Load the raw CSV into a table-like structure called a DataFrame
df = pd.read_csv('marketing_campaign_raw.csv')

# Check the shape before cleaning: (rows, columns)
print("Before cleaning:", df.shape)

# Remove duplicate rows (keeps the first occurrence, drops repeats)
df = df.drop_duplicates()

# Check how many missing values exist in each column
print(df.isnull().sum())

# Handle missing values:
# For numeric columns, fill missing values with the column's median
# (median is safer than average/mean because it isn't skewed by extreme outliers)
numeric_cols = df.select_dtypes(include='number').columns
df[numeric_cols] = df[numeric_cols].fillna(df[numeric_cols].median())

# For text/category columns, fill missing values with "Unknown"
text_cols = df.select_dtypes(include='object').columns
df[text_cols] = df[text_cols].fillna('Unknown')

# Standardize the Date column into a consistent format (YYYY-MM-DD)
df['Date'] = pd.to_datetime(df['Date'], dayfirst=True).dt.strftime('%Y-%m-%d')

# Check the shape after cleaning
print("After cleaning:", df.shape)

# Export the cleaned data to a new CSV file
df.to_csv('marketing_campaign_cleaned.csv', index=False)

print("Cleaned file saved successfully!")
