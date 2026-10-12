-- Demo pour la fonction du trigger de joueur banni
INSERT INTO temps (joueur_id, jeu_id, categorie_run, temps_ms, video_url) 
VALUES (10, 1, 'Any%', 150000, 'https://youtu.be/test');

--Demo pour la fonction du meilleur temps par jeu :
SELECT titre, meilleur_temps_jeu(id) FROM jeux;