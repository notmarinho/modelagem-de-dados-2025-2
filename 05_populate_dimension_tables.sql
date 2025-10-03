-- ============================================
-- Script 03: Popular Tabelas de Dimensão
-- ============================================
-- Este script popula as tabelas de dimensão (lookup tables)
-- a partir dos dados da tabela CRIME_STAGE
-- ============================================

USE `DB_CRIMES_LA`;

-- ============================================
-- 1. Popular tabela STATUS
-- ============================================
-- ✅ CORRIGIDO: Inserir status válidos
INSERT IGNORE INTO STATUS (Status, Status_Desc)
SELECT DISTINCT 
    Status,
    Status_Desc
FROM CRIME_STAGE
WHERE Status IS NOT NULL 
  AND Status != '';

-- ✅ CORRIGIDO: Inserir status padrão para valores vazios/NULL
INSERT IGNORE INTO STATUS (Status, Status_Desc)
VALUES ('UN', 'Unknown/Empty Status');

SELECT CONCAT('STATUS: ', COUNT(*), ' registros inseridos') AS Resultado FROM STATUS;

-- ============================================
-- 2. Popular tabela ARMA (Weapon)
-- ============================================
-- ✅ CORRIGIDO: Converte VARCHAR → DECIMAL → INT
INSERT IGNORE INTO ARMA (Weapon_Used_Cd, Weapon_Desc)
SELECT DISTINCT 
    CAST(CAST(NULLIF(Weapon_Used_Cd, '') AS DECIMAL(10,1)) AS SIGNED),
    Weapon_Desc
FROM CRIME_STAGE
WHERE Weapon_Used_Cd IS NOT NULL 
  AND Weapon_Used_Cd != ''
  AND CAST(NULLIF(Weapon_Used_Cd, '') AS DECIMAL(10,1)) != 0;

SELECT CONCAT('ARMA: ', COUNT(*), ' registros inseridos') AS Resultado FROM ARMA;

-- ============================================
-- 3. Popular tabela PREMISSA (Premise)
-- ============================================
-- MANTÉM DECIMAL: Premis_Cd aceita valores como 104.5
INSERT IGNORE INTO PREMISSA (Premis_Cd, Premis_Desc)
SELECT DISTINCT 
    CAST(NULLIF(Premis_Cd, '') AS DECIMAL(5,1)),
    Premis_Desc
FROM CRIME_STAGE
WHERE Premis_Cd IS NOT NULL 
  AND Premis_Cd != ''
  AND CAST(NULLIF(Premis_Cd, '') AS DECIMAL(5,1)) != 0;

SELECT CONCAT('PREMISSA: ', COUNT(*), ' registros inseridos') AS Resultado FROM PREMISSA;

-- ============================================
-- 4. Popular tabela INFRACAO_PENAL
-- ============================================
-- Primeiro, inserir o crime principal
INSERT IGNORE INTO INFRACAO_PENAL (Crm_Cd, Crm_Cd_Desc, Part_1_2)
SELECT DISTINCT 
    Crm_Cd,
    Crm_Cd_Desc,
    Part_1_2
FROM CRIME_STAGE
WHERE Crm_Cd IS NOT NULL AND Crm_Cd != 0;

-- ✅ CORRIGIDO: Inserir crimes adicionais (Crm_Cd_1)
INSERT IGNORE INTO INFRACAO_PENAL (Crm_Cd, Crm_Cd_Desc, Part_1_2)
SELECT DISTINCT 
    CAST(CAST(NULLIF(Crm_Cd_1, '') AS DECIMAL(10,1)) AS SIGNED),
    NULL,
    NULL
FROM CRIME_STAGE
WHERE Crm_Cd_1 IS NOT NULL 
  AND Crm_Cd_1 != ''
  AND CAST(NULLIF(Crm_Cd_1, '') AS DECIMAL(10,1)) != 0;

-- ✅ CORRIGIDO: Inserir crimes adicionais (Crm_Cd_2)
INSERT IGNORE INTO INFRACAO_PENAL (Crm_Cd, Crm_Cd_Desc, Part_1_2)
SELECT DISTINCT 
    CAST(CAST(NULLIF(Crm_Cd_2, '') AS DECIMAL(10,1)) AS SIGNED),
    NULL,
    NULL
FROM CRIME_STAGE
WHERE Crm_Cd_2 IS NOT NULL 
  AND Crm_Cd_2 != ''
  AND CAST(NULLIF(Crm_Cd_2, '') AS DECIMAL(10,1)) != 0;

-- ✅ CORRIGIDO: Inserir crimes adicionais (Crm_Cd_3)
INSERT IGNORE INTO INFRACAO_PENAL (Crm_Cd, Crm_Cd_Desc, Part_1_2)
SELECT DISTINCT 
    CAST(CAST(NULLIF(Crm_Cd_3, '') AS DECIMAL(10,1)) AS SIGNED),
    NULL,
    NULL
FROM CRIME_STAGE
WHERE Crm_Cd_3 IS NOT NULL 
  AND Crm_Cd_3 != ''
  AND CAST(NULLIF(Crm_Cd_3, '') AS DECIMAL(10,1)) != 0;

-- ✅ CORRIGIDO: Inserir crimes adicionais (Crm_Cd_4)
INSERT IGNORE INTO INFRACAO_PENAL (Crm_Cd, Crm_Cd_Desc, Part_1_2)
SELECT DISTINCT 
    CAST(CAST(NULLIF(Crm_Cd_4, '') AS DECIMAL(10,1)) AS SIGNED),
    NULL,
    NULL
FROM CRIME_STAGE
WHERE Crm_Cd_4 IS NOT NULL 
  AND Crm_Cd_4 != ''
  AND CAST(NULLIF(Crm_Cd_4, '') AS DECIMAL(10,1)) != 0;

SELECT CONCAT('INFRACAO_PENAL: ', COUNT(*), ' registros inseridos') AS Resultado FROM INFRACAO_PENAL;

-- ============================================
-- 5. Popular tabela VITIMA
-- ============================================
-- ✅ CORRIGIDO: Inserir vítimas únicas
INSERT INTO VITIMA (Vict_Age, Vict_Sex, Vict_Descent)
SELECT DISTINCT 
    CASE 
        WHEN Vict_Age = '' OR Vict_Age IS NULL THEN NULL
        ELSE CAST(CAST(Vict_Age AS DECIMAL(10,1)) AS SIGNED)
    END,
    NULLIF(Vict_Sex, ''),
    NULLIF(Vict_Descent, '')
FROM CRIME_STAGE;

SELECT CONCAT('VITIMA: ', COUNT(*), ' registros inseridos') AS Resultado FROM VITIMA;

-- ============================================
-- 6. Popular tabela LOCALIDADE
-- ============================================
-- Inserir localidades únicas (baseado em LAT, LON e Rpt_Dist_No)
INSERT INTO LOCALIDADE (LOCATION, Cross_Street, LAT, LON, AREA, AREA_NAME, Rpt_Dist_No)
SELECT DISTINCT 
    NULLIF(LOCATION, ''),
    NULLIF(Cross_Street, ''),
    CASE 
        WHEN LAT = '' OR LAT IS NULL THEN NULL
        ELSE CAST(LAT AS DECIMAL(10,6))
    END,
    CASE 
        WHEN LON = '' OR LON IS NULL THEN NULL
        ELSE CAST(LON AS DECIMAL(10,6))
    END,
    AREA,
    AREA_NAME,
    Rpt_Dist_No
FROM CRIME_STAGE
ON DUPLICATE KEY UPDATE
    LOCATION = VALUES(LOCATION),
    Cross_Street = VALUES(Cross_Street),
    AREA = VALUES(AREA),
    AREA_NAME = VALUES(AREA_NAME);

SELECT CONCAT('LOCALIDADE: ', COUNT(*), ' registros inseridos') AS Resultado FROM LOCALIDADE;

-- ============================================
-- Resumo Final
-- ============================================
SELECT 'Todas as tabelas de dimensão foram populadas com sucesso!' AS Resultado;

SELECT 
    'STATUS' AS Tabela, COUNT(*) AS Total_Registros FROM STATUS
UNION ALL
SELECT 
    'ARMA' AS Tabela, COUNT(*) AS Total_Registros FROM ARMA
UNION ALL
SELECT 
    'PREMISSA' AS Tabela, COUNT(*) AS Total_Registros FROM PREMISSA
UNION ALL
SELECT 
    'INFRACAO_PENAL' AS Tabela, COUNT(*) AS Total_Registros FROM INFRACAO_PENAL
UNION ALL
SELECT 
    'VITIMA' AS Tabela, COUNT(*) AS Total_Registros FROM VITIMA
UNION ALL
SELECT 
    'LOCALIDADE' AS Tabela, COUNT(*) AS Total_Registros FROM LOCALIDADE;
