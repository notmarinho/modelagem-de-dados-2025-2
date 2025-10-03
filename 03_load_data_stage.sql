-- ============================================
-- Script 02: Carga de Dados na Tabela Stage
-- ============================================
-- Este script carrega os dados do CSV para a tabela stage
-- ============================================

USE `DB_CRIMES_LA`;

LOAD DATA LOCAL INFILE '/Users/marinho/Documents/Projects/ufrpe/MD/crime_from_2023_sanitized.csv'
INTO TABLE CRIME_STAGE
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(DR_NO, Date_Rptd, DATE_OCC, TIME_OCC, AREA, AREA_NAME, Rpt_Dist_No, Part_1_2,
 Crm_Cd, Crm_Cd_Desc, Mocodes, Vict_Age, Vict_Sex, Vict_Descent, Premis_Cd,
 Premis_Desc, Weapon_Used_Cd, Weapon_Desc, Status, Status_Desc, Crm_Cd_1,
 Crm_Cd_2, Crm_Cd_3, Crm_Cd_4, LOCATION, Cross_Street, LAT, LON);

-- Verificar quantos registros foram inseridos
SELECT COUNT(*) AS Total_Registros_Stage FROM CRIME_STAGE;

SELECT 'Dados carregados na tabela CRIME_STAGE com sucesso!' AS Resultado;

