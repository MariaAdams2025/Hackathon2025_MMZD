#OPTION('obfuscateOutput', TRUE);
IMPORT $;
MozMusic := $.File_Music.MozDS;

//display the first 150 records

OUTPUT(CHOOSEN(MozMusic, 150), NAMED('Moz_MusicDS'));

//*********************************************************************************
//*********************************************************************************

//                                CATEGORY ONE 

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Count all the records in the dataset:

COUNT(MozMusic);

//Result: Total count is 136510

//*********************************************************************************
//*********************************************************************************
//Challenge: 

//Sort by "name",  and display (OUTPUT) the first 50(Hint: use CHOOSEN):

//OUTPUT(CHOOSEN(X, 50));

X := SORT(MozMusic, name);
OUTPUT(CHOOSEN(X, 50));


/*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count total songs in the "Rock" genre and display number:
*/
//MozMusic(genre='Country');

//Result should have 12821 Rock songs

//Display your Rock songs (OUTPUT):

Rocksongs := MozMusic(genre = 'Rock');
TotalRockSongs := COUNT(Rocksongs);
OUTPUT(TotalRockSongs, NAMED('Total_Rock_Songs'));
//OUTPUT(TotalRockSongs);


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count how many songs was released by Depeche Mode between 1980 and 1989

//Filter ds for "Depeche_Mode" AND releasedate BETWEEN 1980 and 1989

// Count and display total
//Result should have 127 songs 


//Bonus points: filter out duplicate tracks (Hint: look at DEDUP):

DepecheMode := MozMusic(name = 'Depeche_Mode' AND releasedate BETWEEN '1980' AND '1989');
TotalDepecheMode := COUNT(DepecheMode);
OUTPUT(TotalDepecheMode);
OUTPUT(DATASET([{TotalDepecheMode}], {INTEGER1 TotalDepecheMode}), NAMED('Total_Depeche_Mode_Tracks'));

UniqueDepecheModeSongs := DEDUP(DepecheMode, Title);
TotalUniqueDepecheModeTracks := COUNT(UniqueDepecheModeSongs);
OUTPUT(DATASET([{TotalUniqueDepecheModeTracks}], {INTEGER1 TotalUniqueDepecheModeTracks}), NAMED('Total_Unique_Depeche_Mode_Tracks'));
//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Who sang the song "My Way"?
//Filter for "My Way" tracktitle

// Result should have 136 records 

//Display count and result 
MyWay := MozMusic(tracktitle = 'My Way');
TotalMyWay := COUNT(MyWay);
OUTPUT(MyWay, NAMED('My_Way_Tracks'));
OUTPUT(TotalMyWay, NAMED('Total_My_Way_Tracks'));


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//What song(s) in the Music Moz Dataset has the longest track title in CD format?

//Get the longest description (tracktitle) field length in CD "formats"
//Filter dataset for tracktitle with the longest value
//Display the result
//Longest track title is by the "The Brand New Heavies" 
CDTracks := MozMusic(formats = 'CD');
MaxTitlelength := MAX(CDTracks, LENGTH(TrackTitle));
LongestTitle := CDTracks(LENGTH(TrackTitle) = MaxTitleLength);              
OUTPUT(LongestTitle, NAMED('Longest_Track_Title'));
OUTPUT(MaxTitleLength, NAMED('Max_Title_Length'));
//*********************************************************************************
//*********************************************************************************

//                                CATEGORY TWO

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Display all songs produced by "U2" , SORT it by title.
//Filter track by artist

//Sort the result by tracktitle

//Output the result

//Count result 

//Result has 190 records
U2Tracks := MozMusic(name = 'U2');
SortedU2Tracks := SORT(U2Tracks, tracktitle);
TotalU2Tracks := COUNT(SortedU2Tracks);
OUTPUT(SortedU2Tracks, NAMED('U2_Tracks'));
U2TracksDataset := COUNT(TotalU2Tracks);

OUTPUT(TotalU2Tracks, NAMED('Total_U2_Tracks'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count all songs where guest musicians appeared 

//Hint: Think of the filter as "not blank" 

//Filter for "guestmusicians"

//Display Count result
                             
//Result should be 44588 songs  


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Create a new recordset which only has "Track", "Release", "Artist", and "Year"
// Get the "track" value from the MusicMoz TrackTitle field
// Get the "release" value from the MusicMoz Title field
// Get the "artist" value from the MusicMoz Name field
// Get the "year" value from the MusicMoz ReleaseDate field

//Result should only have 4 fields. 

//Hint: First create your new RECORD layout  



//Next: Standalone Transform - use TRANSFORM for new fields.


//Use PROJECT, to loop through your music dataset


// Display result  
      

//*********************************************************************************
//*********************************************************************************

//                                CATEGORY THREE

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Display number of songs per "Genre", display genre name and count for each 

//Hint: All you need is a 2 field TABLE using cross-tab

//Display the TABLE result      

//Count and display total records in TABLE

//Result has 2 fields, Genre and TotalSongs, count is 1000

GenreSongCount_Layout := RECORD
    STRING Genre;
    UNSIGNED4 TotalSongs;
END;

GroupedMozMusic := GROUP(MozMusic, genre);
genere_song_count := TABLE(GroupedMozMusic, GenreSongCount_Layout, 
    TRANSFORM(GenreSongCount_Layout, LEFT)
    SELF.Genre := LEFT.genre;
    SELF.TotalSongs := COUNT(LEFT);
END);
OUTPUT(genere_song_count, NAMED('Genere_Song_Count'));
total_genere_song_count := COUNT(genere_song_count);
OUTPUT(total_genere_song_count, NAMED('Total_Records'));

//*********************************************************************************
//*********************************************************************************
//What Artist had the most releases between 2001-2010 (releasedate)?

//Hint: All you need is a cross-tab TABLE 

//Output Name, and Title Count(TitleCnt)

//Filter for year (releasedate)

//Cross-tab TABLE


//Display the result  