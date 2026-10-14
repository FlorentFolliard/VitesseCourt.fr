# Speedrun.com Clone - Projet de SQL Avancé

Plateforme de gestion de speedruns permettant de stocker des scores, d'associer des joueurs à des jeux, de gérer des sanctions et de consulter des classements vérifiés.

## 1. Fonction / Procédure

* Ce qu'il fait : La fonction meilleur_temps_jeu(p_jeu_id integer) prend en paramètre l'identifiant d'un jeu et renvoie directement son record mondial absolu (le temps minimal en millisecondes enregistré sur ce jeu).
* Pourquoi il est là : Il encapsule une logique de calcul agrégée pour éviter d'alourdir le code des applications clientes et centralise la règle de calcul du record.
* La preuve :
SELECT id, titre, meilleur_temps_jeu(id) AS wr_ms FROM jeux;
Résultat observé : Affiche chaque jeu avec son meilleur temps en millisecondes de manière instantanée.

## 2. Trigger

* Ce qu'il fait : Le trigger trg_check_sanction s'exécute automatiquement en BEFORE INSERT sur la table temps. Il vérifie si le joueur qui tente d'enregistrer une run possède une sanction active dans la table sanctions.
* Pourquoi il est là : Plutôt que de déléguer la sécurité anti-triche au code de l'application (ce qui comporte des risques d'oubli), la règle est verrouillée directement au niveau de la base de données. Si le joueur est banni, l'insertion est stoppée net (RAISE EXCEPTION).
* La preuve :
-- Tentative d'insertion avec le joueur 10 (sanctionné)
INSERT INTO temps (joueur_id, jeu_id, categorie_run, temps_ms) VALUES (10, 1, 'Any%', 120000);
Résultat observé : L'erreur ERROR: Action refusée : le joueur ID 10 est banni et ne peut pas soumettre de temps. est levée et l'insertion est annulée.

## 3. Vues et Sécurité (DCL)

* Ce qu'il fait : Deux rôles-métiers ont été créés (speedrun_moderateur et speedrun_visiteur). Ils n'ont aucun droit direct sur les tables brutes de la base. Leurs accès sont strictement cantonnés à deux vues dédiées : vue_moderation (détails complets des runs) et vue_leaderboard_public (classement épuré sans données sensibles).
* Pourquoi il est là : Pour appliquer le principe de moindre privilège et protéger l'intégrité des tables principales face aux utilisateurs de l'API ou du site web.
* La preuve :
Connexion en tant que speedrun_visiteur et test de lecture :
SET ROLE speedrun_visiteur;
SELECT * FROM vue_leaderboard_public LIMIT 5; -- Autorisé
SELECT * FROM joueurs;                       -- Refusé (Permission denied)

## 4. Index et Performance

* Ce qu'il fait : Deux index ont été posés sur la table volumineuse temps (qui contient 10 000 lignes) : un index simple sur la clé étrangère jeu_id et un index composite sur (jeu_id, temps_ms ASC).
* Pourquoi il est là : Accélérer drastiquement les requêtes de recherche de classement par jeu pour l'API React.
* La preuve (EXPLAIN ANALYZE) :
Avant index : Utilisation d'un Seq Scan (parcours complet de la table) — Temps d'exécution : ~12.4 ms.
Après index : Utilisation d'un Index Scan (accès direct via l'arbre de l'index) — Temps d'exécution : ~0.3 ms.

## Membres du groupe

* Florent FOLLIARD
* Oscar VIVIEN
* Joey SPORTES
* Mohamed TRAORE