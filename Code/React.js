import React, { useState } from "react";

export default function MusicSearch() {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState([]);

  const searchMusic = async () => {
    const response = await fetch(`http://localhost:5000/search?q=${query}`);
    const data = await response.json();
    setResults(data);
  };

  return (
    <div className="p-4 max-w-lg mx-auto">
      <h1 className="text-2xl font-bold mb-4">Music Search</h1>
      <input
        type="text"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Search by Song or Artist"
        className="border p-2 w-full"
      />
      <button onClick={searchMusic} className="bg-blue-500 text-white p-2 mt-2">
        Search
      </button>

      {results.length > 0 && (
        <div className="mt-4">
          <h2 className="text-xl font-semibold">Results:</h2>
          <ul>
            {results.map((song, index) => (
              <li key={index}>
                <strong>{song.SongTitle}</strong> - {song.Artist} ({song.ReleaseYear})
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}
