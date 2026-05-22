-- Migrazione iniziale.
-- Aggiungi qui i CREATE TABLE delle tue entità.
-- Esempio:
-- CREATE TABLE users (
--   id BIGSERIAL PRIMARY KEY,
--   email VARCHAR(255) UNIQUE NOT NULL,
--   created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
-- );

-- Placeholder per far girare Flyway anche senza tabelle reali.
-- Crea una tabella tecnica vuota, la puoi rimuovere quando aggiungi le tue.
CREATE TABLE IF NOT EXISTS _bootstrap (
  initialized_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
INSERT INTO _bootstrap (initialized_at) VALUES (NOW());
