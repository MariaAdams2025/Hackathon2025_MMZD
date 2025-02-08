IMPORT $;
MozMusic  := $.File_Music.MozDS;
MSDMusic  := $.File_Music.MSDDS;
SpotMusic := $.File_Music.SpotDS;

// Define the common layout for all music records
CombMusicLayout := RECORD
    UNSIGNED4 RECID;
    STRING    SongTitle;
    STRING    AlbumTitle;
    STRING    Artist;
    STRING    Genre;
    STRING4   ReleaseYear;
    STRING4   Source;END;

// Transform MozMusic records
CombMusicLayout TransformMoz($.File_Music.MozLayout L, UNSIGNED C) := TRANSFORM
    SELF.RECID      := C;
    SELF.SongTitle  := TRIM(L.tracktitle);
    SELF.AlbumTitle := TRIM(L.title);
    SELF.Artist     := TRIM(L.name);
    SELF.Genre      := TRIM(L.genre);
    SELF.ReleaseYear := (STRING4)IF(L.releasedate[1..4] > '', L.releasedate[1..4], '0000');
    SELF.Source     := 'MOZ';
END;

// Transform MSDMusic records
CombMusicLayout TransformMSD($.File_Music.MSDLayout L) := TRANSFORM
    SELF.RECID      := L.RecID;
    SELF.SongTitle  := TRIM(L.title);
    SELF.AlbumTitle := TRIM(L.release_name);
    SELF.Artist     := TRIM(L.artist_name);
    SELF.Genre      := ''; // MSD doesn't have genre
    SELF.ReleaseYear := (STRING4)IF(L.year > 0, (STRING)L.year, '0000');
    SELF.Source     := 'MSD';
END;

// Transform SpotMusic records
CombMusicLayout TransformSpot($.File_Music.SpotMillion L) := TRANSFORM
    SELF.RECID      := L.recid;
    SELF.SongTitle  := TRIM(L.track_name);
    SELF.AlbumTitle := ''; // Spotify Million doesn't have album titles
    SELF.Artist     := TRIM(L.artist_name);
    SELF.Genre      := TRIM(L.genre);
    SELF.ReleaseYear := (STRING4)IF(L.year > 0, (STRING)L.year, '0000');
    SELF.Source     := 'SPOT';
END;

// Create transformed datasets
MozTransformed := PROJECT(MozMusic, TransformMoz(LEFT, COUNTER));
MSDTransformed := PROJECT(MSDMusic, TransformMSD(LEFT));
SpotTransformed := PROJECT(SpotMusic, TransformSpot(LEFT));

// Combine all transformed datasets
CombinedMusic := MozTransformed + MSDTransformed + SpotTransformed;

// Sort by Artist and SongTitle
SortedMusic := SORT(CombinedMusic, Artist, SongTitle);

//DEDUP(CombinedMusic)
//Sequence
//OUTPUT(COUNT(CombinedMusic), NAMED('TotalRecords'));


//Clean Up
DS := DEDUP(SortedMusic, SongTitle);
OUTPUT(COUNT(DS), NAMED('Duplicate Removed Count'));
//CDS1 := SortedMusic(ReleaseYear <> '0000');
//OUTPUT(COUNT(CDS1));

