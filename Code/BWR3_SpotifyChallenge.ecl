IMPORT $;
IMPORT STD;;
SpotMusic := $.File_Music.SpotDS;


//display the first 150 records


OUTPUT(CHOOSEN(SpotMusic, 150), NAMED('Raw_MusicDS'));


//*********************************************************************************
// CATEGORY ONE
//*********************************************************************************

//Challenge:
//Sort songs by genre and count the number of songs in your total music dataset

//Sort by "genre" (See SORT function)
SortedMusic := SORT(SpotMusic, Genre);

//Display them: (See OUTPUT)
OUTPUT(CHOOSEN(SortedMusic, 150), NAMED('SortedGenreMusic'));

//Count and display result (See COUNT)
//Result: Total count is 1159764:
OUTPUT(COUNT(SpotMusic), NAMED('TotalSongCount'));

//*********************************************************************************
//Challenge:
//Display songs by "garage" genre and then count the total
//Filter for garage genre and OUTPUT them:
FilterGarage := SpotMusic(genre = 'garage');
OUTPUT(FilterGarage, NAMED('FilteredGarageSongs'));

//Count total garage songs
//Result should have 17123 records:
GarageCount := COUNT(FilterGarage);
OUTPUT(GarageCount, NAMED('GarageSongCount'));

//*********************************************************************************
//*********************************************************************************

//Challenge:
//Count how many songs was produced by "Prince" in 2001
//Filter ds for 'Prince' AND 2001
FilteredPrince2001 := SpotMusic(artist_name = 'Prince' AND year = 2001);
Prince2001Count := COUNT(FilteredPrince2001);

//Count and output total - should be 35
OUTPUT(Prince2001Count, NAMED('Prince2001Count'));

//*********************************************************************************

//Challenge:
//Who sang "Temptation to Exist"?
TemptoExistSongs := SpotMusic(STD.Str.ToUpperCase(track_name) = STD.Str.ToUpperCase('Temptation to Exist'));
//Result should have 1 record and the artist is "New York Dolls"
//Filter for "Temptation to Exist" (name is case sensitive)
//Display result
OUTPUT(TemptoExistSongs, NAMED('TemptationToExist'));

//*********************************************************************************

//Challenge:
//Output songs sorted by Artist_name and track_name, respectively

//Result: First few rows should have Artist and Track as follows:
// !!! Californiyeah
// !!! Couldn't Have Known
// !!! Dancing Is The Best Revenge
// !!! Dear Can
// (Yes, there is a valid artist named "!!!")


//Sort dataset by Artist_name, and track_name:


//Output here:

ArtistTrackSorted := SORT(SpotMusic, artist_name, track_name);
OUTPUT(ArtistTrackSorted, NAMED('ArtistTrackSorted'));

//*********************************************************************************
//Challenge:
//Find the MOST Popular song using "Popularity" field
MostPopularSong := SpotMusic(popularity = MAX(SpotMusic, popularity));
//OUTPUT(MostPopularSong);

//Get the most Popular value (Hint: use MAX)
//Filter dataset for the mostPop value
//Display the result - should be "Flowers" by Miley Cyrus
OUTPUT(CHOOSEN(MostPopularSong, 1), NAMED('MostPopularSong'));

//*********************************************************************************
//*********************************************************************************

// CATEGORY TWO

//*********************************************************************************
//*********************************************************************************

//Challenge:
//Display all games produced by "Coldplay" Artist AND has a
//"Popularity" greater or equal to 75 ( >= 75 ) , SORT it by title.
//Count the total result
//Result has 9 records

//Get songs by defined conditions
coldPopular := SpotMusic(artist_name = 'Coldplay' AND popularity >= 75);

//Sort the result
coldPopularSorted := SORT(coldPopular, track_name);

//Output the result
OUTPUT(coldPopularSorted, NAMED('ColdplayPopularSongs'));

//Count and output result
CountColdPopular := COUNT(coldPopularSorted);
OUTPUT(CountColdPopular, NAMED('ColdplayPopularSongCount'));

//*********************************************************************************
//*********************************************************************************

//Challenge:
//Count all songs that whose "SongDuration" (duration_ms) is between 200000 AND 250000 AND "Speechiness" is above .75
//Hint: (Duration_ms BETWEEN 200000 AND 250000)
Time := SpotMusic(duration_ms BETWEEN 200000 AND 250000 AND speechiness > .75);
//Filter for required conditions
countTime := COUNT(time);
//Count result (should be 2153):
//Display result:
OUTPUT(countTime, NAMED('CountTime'));
//*********************************************************************************
//*********************************************************************************

//Challenge:
//Create a new dataset which only has "Artist", "Title" and "Year"
//Output them

//Result should only have 3 columns.

//Hint: Create your new layout and use TRANSFORM for new fields.
//Use PROJECT, to loop through your music dataset

//Define RECORD here:
NewRecord := RECORD
STRING artist_name;
STRING track_name;
UNSIGNED4 year;

END;
//Standalone TRANSFORM Here
NewDataset := PROJECT(SpotMusic, TRANSFORM(NewRecord,
SELF.artist_name := LEFT.artist_name,
SELF.track_name := LEFT.track_name,
SELF.year := LEFT.year
));
//PROJECT here:

//OUTPUT your PROJECT here:
OUTPUT(NewDataset);

//*********************************************************************************

//COORELATION Challenge:
//1- What’s the correlation between "Popularity" AND "Liveness"
// Create a clean dataset with proper numeric conversions
// Define a new record layout with energy as REAL4
// Convert energy from STRING8 to REAL4 and create the new dataset
CleanSpotMusic := PROJECT(SpotMusic,
    TRANSFORM(
        {
            REAL4 popularity,
            REAL4 loudness,
            REAL4 energy,
            REAL4 liveness
        },
        SELF.popularity := (REAL4)LEFT.popularity,
        SELF.loudness := LEFT.loudness,
        SELF.energy := (REAL4)LEFT.energy,
        SELF.liveness := LEFT.liveness
    )
);
//Calculate the correlation between popularity and liveness
corrPopLiveness := CORRELATION(CleanSpotMusic, popularity, liveness);
// Calculate the correlation between loudness and energy from the transformed dataset
corrLoudEnergy := CORRELATION(CleanSpotMusic, energy,loudness);
// Output 
OUTPUT(corrPopLiveness, NAMED('PopularityVsLiveness'));
OUTPUT(corrLoudEnergy, NAMED('LoudnessVsEnergy'));
//*********************************************************************************
//*********************************************************************************

// CATEGORY THREE

//*********************************************************************************
//*********************************************************************************

//Challenge:
//Create a new dataset which only has following conditions
// * STRING Column(field) named "Song" that has "Track_Name" values
// * STRING Column(field) named "Artist" that has "Artist_name" values
// * New BOOLEAN Column called isPopular, and it's TRUE is IF "Popularity" is greater than 80
// * New DECIMAL3_2 Column called "Funkiness" which is "Energy" + "Danceability"
//Display the output
//Result should have 4 columns called "Song", "Artist", "isPopular", and "Funkiness"
//Hint: Create your new layout and use TRANSFORM for new fields.
// Use PROJECT, to loop through your music dataset

//Define the RECORD layout
NewSpotLayout := RECORD
    STRING     Song;
    STRING     Artist;
    BOOLEAN    isPopular;
    DECIMAL3_2 Funkiness;
END;


//Build TRANSFORM
NewSpotDataset := PROJECT(SpotMusic,
    TRANSFORM(NewSpotLayout,
        SELF.Song := LEFT.track_name,
        SELF.Artist := LEFT.artist_name,
        SELF.isPopular := LEFT.popularity > 80,
        SELF.Funkiness := (DECIMAL3_2)((REAL4)LEFT.energy + LEFT.danceability)
    )
);

//Display result here:
OUTPUT(NewSpotDataset, NAMED('NewDataSet'));

//*********************************************************************************
//*********************************************************************************

//Challenge:
//Display number of songs for each "Genre", output and count your total
GenreSongCount_Layout := RECORD
SpotMusic.genre;
TotalSongs := COUNT(SpotMusic);
END;
//Result has 2 col, Genre and TotalSongs, count is 82
genre_song_count := TABLE(SpotMusic, GenreSongCount_Layout, genre);
//Hint: All you need is a TABLE - this is a CrossTab report
unique_genre := COUNT(genre_song_count);
OUTPUT(unique_genre, NAMED('Unique_Genres_Count'));

//Printing the first 50 records of the result
OUTPUT(CHOOSEN(genre_song_count, 50), NAMED('Genre_Song_Count'));
//Count and display total - there should be 82 unique genres

//Bonus: What is the top genre?
sorted_genres := SORT(genre_song_count, -TotalSongs);
top_genre := CHOOSEN(sorted_genres, 1);
OUTPUT(top_genre, NAMED('Top_Genre'));
//*********************************************************************************
//*********************************************************************************
//Calculate the average "Danceability" per "Artist" for "Year" 2023

//Hint: All you need is a TABLE
year_2023 := SpotMusic(year = 2023);
DanceArtist_Layout := RECORD
year_2023.artist_name;
DancableRate := AVE(year_2023.danceability);
END;
//Result has 37600 records with two col, Artist, and DancableRate.
danceability_table := TABLE(year_2023, DanceArtist_Layout, artist_name);
//Filter for year 2023

//OUTPUT the result
OUTPUT(danceability_table, NAMED('Danceability'));