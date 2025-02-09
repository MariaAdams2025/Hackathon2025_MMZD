IMPORT $;

MSDMusic := $.File_Music.MSDDS;
IMPORT STD;
IMPORT ML;

//display the first 150 records
OUTPUT(CHOOSEN(MSDMusic, 150), NAMED('Raw_MusicDS'));


//                                CATEGORY ONE 
//*********************************************************************************

//Challenge: 
//Reverse Sort by "year" and count your total music dataset and display the first 50
//Result: Total count is 1000000
TotalCount := COUNT(MSDMusic);
OUTPUT(TotalCount, NAMED('Total_Count'));
//Reverse sort by "year"
SortedData := SORT(MSDMusic, -year);
OUTPUT(SortedData);
//display the first 50
OUTPUT((CHOOSEN(SortedData,50)), NAMED('First_50'));
//Count and display result


//*********************************************************************************

//Challenge: 
//Display first 50 songs by of year 2010 and then count the total 
songs2010 := MSDMusic( year = 2010);
//Result should have 9397 songs for 2010
//Filter for 2010 and display the first 50
OUTPUT((CHOOSEN(songs2010,50)), NAMED('SongsCount'));
//Count total songs released in 2010:
OUTPUT(COUNT(songs2010), NAMED('Total_Songs_2010'));

//*********************************************************************************

//Challenge: 
//Count how many songs was produced by "Prince" in 1982
//Result should have 4 counts
PrinceSongs := MSDMusic(artist_name = 'Prince' AND year = 1982);
//Filter ds for "Prince" AND 1982
//Count and print total 
OUTPUT(COUNT(PrinceSongs), NAMED('PrinceSongs'));

//*********************************************************************************

//Challenge: 
//Who sang "Into Temptation"?
// Result should have 3 records
//Filter for "Into Temptation"
IntoTemptation := MSDMusic (title = 'Into Temptation');
//Display result 
OUTPUT(IntoTemptation, NAMED('IntoTemptation'));

//*********************************************************************************

//Challenge: 
//Sort songs by Artist and song title, output the first 100
SortedSongs := SORT(MSDMusic, artist_name, title);
//Result: The first 10 records have no artist name, followed by "- PlusMinus"                                     
Top100Songs := CHOOSEN(SortedSongs, 100);
//Sort dataset by Artist, and Title
OUTPUT(Top100Songs, NAMED('Top100Songs'));
//Output the first 100

//*********************************************************************************
//Challenge: 
//What is the hottest song by year in the Million Song Dataset?
//Sort Result by Year (filter out zero Year values)
FilteredMusic := MSDMusic(year != 0000);
//Result is 
SortedMusic := SORT(FilteredMusic, year);
//Get the datasets maximum hotness value
MaxHotness := SORT(SortedMusic, -song_hotness);
//Filter dataset for the maxHot value
//Display the result
OUTPUT(MaxHotness, NAMED('Max_hotness'));

//                                CATEGORY TWO
//*********************************************************************************

//Challenge: 
//Display all songs produced by the artist "Coldplay" AND has a 
//"Song Hotness" greater or equal to .75 ( >= .75 ) , SORT it by title.
//Count the total result
//Result has 47 records
//Get songs by defined conditions

ColplayFiltered := MSDMusic(artist_name = 'Coldplay' AND song_hotness >= .75);
OUTPUT(ColplayFiltered, NAMED('ColdPlay'));

//Sort the result
//Output the result
//Count and output result 

//*********************************************************************************

//Challenge: 
//Count all songs where "Duration" is between 200 AND 250 (inclusive) 
//AND "song_hotness" is not equal to 0 
//AND familarity > .9
FilteredDuration := MSDMusic(duration >= 200 AND duration <= 250 AND song_hotness != 0 AND familiarity > .9); 
//Result is 762 songs  
//Hint: (SongDuration BETWEEN 200 AND 250)
//Filter for required conditions
//Count result
OUTPUT((COUNT(FilteredDuration)), NAMED('Filtered_Duration'));                          
//Display result
OUTPUT(FilterDuration, NAMED('iltered_Duration_Display'))

//*********************************************************************************

//*********************************************************************************

//Challenge: 
//Create a new dataset which only has  "Title", "Artist_Name", "Release_Name" and "Year"
//Display the first 50
//Result should only have 4 columns. 
//Hint: Create your new RECORD layout and use TRANSFORM for new fields. 
//Use PROJECT, to loop through your music dataset

NewDateSet := PROJECT(MSDMusic, TRANSFORM({STRING Title, STRING375 Artist_Name, STRING Release_Name, UNSIGNED4 Year}, 
SELF.Title := LEFT.Title,
SELF.Artist_Name := LEFT.Artist_Name,
SELF.Release_Name := LEFT.Release_Name,
SELF.Year := LEFT.Year
));
//Standalone Transform 
//PROJECT
First50Songs := CHOOSEN(NewDateSet,50);
// Display result  
OUTPUT(First50Songs, NAMED('First50Songs'));


//*********************************************************************************


//Challenge: 

//1- What’s the correlation between "song_hotness" AND "artist_hotness"
//2- What’s the correlation between "barsstartdev" AND "beatsstartdev"

FilteredHotness := MSDMusic(song_hotness != 0 AND artist_hotness != 0);
//Result for hotness = 0.4706972681953097, StartDev = 0.8896342348554744
CorrelationValue := CORRELATION(FilteredHotness, song_hotness, artist_hotness);
FilteredBeat := MSDMusic(barsstartdev != 0 AND beatsstartdev != 0);
CorrelationBeatValue := CORRELATION(FilteredBeat, barsstartdev, beatsstartdev);
//DATASET
OUTPUT(CorrelationValue, NAMED('CorrelationValue'));
OUTPUT(CorrelationBeatValue, NAMED('CorrelationBeatValue'));