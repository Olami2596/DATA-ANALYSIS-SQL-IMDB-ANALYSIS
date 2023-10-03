### IMDb Movie Dataset Analysis
This SQL script aims to analyze and preprocess the IMDb movie dataset. The dataset contains information about movies including their runtime, ratings, directors, genres, and more.

### Dataset Overview
The IMDb movie dataset provides a comprehensive collection of movies along with associated details like runtime, ratings, directors, and actors.

### Data Preprocessing
The provided SQL script performs several preprocessing steps to clean and enhance the dataset for further analysis:

Creating a Copy: A new dataset (IMDBMOVIEDATASETNEW) is created as a copy of the original IMDb movie dataset.

Cleaning Runtime Column:

Rows with "not-released" in the Run_Time column are removed.

Rows with runtime in unusual formats (e.g., containing "$25,000,000 (estimated)") are removed.

Rows with runtime containing specific units (e.g., "THB", "$", "£", "?") are removed. 

Rows without the term "hour" are removed.

The Run_Time column is converted to minutes.

Cleaning Year Column:

Extraneous characters in the year column are removed.

Cleaning User Rating and Rating Columns:

User ratings are standardized and converted to numeric format.

The Rating column is converted to float.

Trimming Year Column:

The year column is trimmed and stored in a new column trimmed_year.

Removing Null or Zero Values:

Rows with null or zero values in certain columns are deleted.




### Analytical Queries

Creating Views:

Views are created to display the most frequent directors, actors, keywords, and genres.

Several analytical queries are performed to extract valuable insights from the dataset:

Top rated movies by IMDb rating and user rating.

Top movies with the longest runtime.

Number of movies per year.
