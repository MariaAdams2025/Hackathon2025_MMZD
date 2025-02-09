// Import necessary data files
IMPORT $;
SpotMusic := $.File_Music.SpotDS;
MSDMusic := $.File_Music.MSDDS;
MozMusic := $.File_Music.MozDS;

STRING NormalizeTitle(STRING title) := FUNCTION
    // Convert to uppercase using built-in function
    upperTitle := TRIM(title);
    // Remove hyphens and extra spaces
    noHyphens := REGEXREPLACE('[-]+', upperTitle, ' ');
    // Trim any resulting extra spaces
    RETURN TRIM(noHyphens);
END;

// Define the combined layout for all music records
CombMusicLayout := RECORD
    UNSIGNED    RECID;
    STRING      SongTitle;
    STRING      AlbumTitle;
    STRING      Artist;
    STRING      Genre;
    STRING4     ReleaseYear;
    STRING4     Source;      //MOZ,MSD,SPOT
END;

// Transform MozMusic records
CombMusicLayout TransformMoz($.File_Music.MozLayout L, UNSIGNED C) := TRANSFORM
    SELF.RECID       := C;
    SELF.SongTitle   := TRIM(L.tracktitle);
    SELF.AlbumTitle  := NormalizeTitle(L.tracktitle);
    SELF.Artist      := TRIM(L.name);
    SELF.Genre       := TRIM(L.genre);
    SELF.ReleaseYear := (STRING4)IF(L.releasedate[1..4] > '', L.releasedate[1..4], '0000');
    SELF.Source      := 'MOZ';
END;

// Transform MSDMusic records
CombMusicLayout TransformMSD($.File_Music.MSDLayout L, UNSIGNED C) := TRANSFORM
    SELF.RECID       := C;
    SELF.SongTitle   := NormalizeTitle(L.Title);
    SELF.AlbumTitle  := TRIM(L.Release_Name);
    SELF.Artist      := TRIM(L.Artist_Name);
    SELF.Genre       := '';  // MSD doesn't have genre
    SELF.ReleaseYear := (STRING4)IF(L.Year > 0, (STRING)L.Year, '0000');
    SELF.Source      := 'MSD';
END;

// Transform SpotMusic records
CombMusicLayout TransformSpot($.File_Music.SpotMillion L, UNSIGNED C) := TRANSFORM
    SELF.RECID       := C;
    SELF.SongTitle   := NormalizeTitle(L.track_name);
    SELF.AlbumTitle  := '';  // Spotify Million doesn't have album titles
    SELF.Artist      := TRIM(L.artist_name);
    SELF.Genre       := TRIM(L.genre);
    SELF.ReleaseYear := (STRING4)IF(L.year > 0, (STRING)L.year, '0000');
    SELF.Source      := 'SPOT';
END;

// Create transformed datasets with proper COUNTER
MozTransformed := PROJECT(MozMusic, TransformMoz(LEFT, COUNTER));
MSDTransformed := PROJECT(MSDMusic, TransformMSD(LEFT, COUNTER));
SpotTransformed := PROJECT(SpotMusic, TransformSpot(LEFT, COUNTER));

// Combine all transformed datasets
CombinedMusic := MozTransformed + MSDTransformed + SpotTransformed;

// Sort by Artist and SongTitle
SortedMusic := SORT(CombinedMusic, Artist, SongTitle);

// Output the results
OUTPUT(COUNT(SortedMusic));

//Remove any duplicate songs (3 points)
DedupedMusic := DEDUP(SortedMusic, Artist, SongTitle);

//sequence the song records (3 points)
// Create a new record structure with sequence field
NewMusicLayout := RECORD
    UNSIGNED4   Sequence;    // New sequence field
    UNSIGNED    RECID;
    STRING      SongTitle;
    STRING      AlbumTitle;
    STRING      Artist;
    STRING      Genre;
    STRING4     ReleaseYear;
    STRING4     Source;
END;

// Transform to add sequence numbers
NewMusicLayout AddSequence(DedupedMusic L, UNSIGNED C) := TRANSFORM
    SELF.Sequence := C;
    SELF := L;
END;

// Add sequence numbers
SequencedMusic := PROJECT(DedupedMusic, AddSequence(LEFT, COUNTER));

// Output results
OUTPUT(SequencedMusic, NAMED('SequencedMusic'));
//count the new total (1 point)
// Count total records
TotalCount := COUNT(SequencedMusic);
OUTPUT(TotalCount, NAMED('TotalRecords'));