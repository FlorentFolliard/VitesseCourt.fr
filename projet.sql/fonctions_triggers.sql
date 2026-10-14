
CREATE OR REPLACE FUNCTION meilleur_temps_jeu(p_jeu_id integer)
RETURNS integer
LANGUAGE sql
AS $$
    SELECT MIN(temps_ms)
    FROM temps
    WHERE jeu_id = p_jeu_id;
$$;



CREATE OR REPLACE FUNCTION verifier_joueur_non_banni()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM sanctions 
        WHERE joueur_id = NEW.joueur_id 
          AND active = true
    ) THEN
        RAISE EXCEPTION 'Action refusée : le joueur ID % est banni ou sanctionné et ne peut pas soumettre de temps.', NEW.joueur_id;
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_check_sanction ON temps;
CREATE TRIGGER trg_check_sanction
BEFORE INSERT ON temps
FOR EACH ROW
EXECUTE FUNCTION verifier_joueur_non_banni();