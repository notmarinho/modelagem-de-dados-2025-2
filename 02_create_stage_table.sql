-- ============================================
-- Script 01: Criação da Tabela Stage
-- ============================================
-- Este script cria uma tabela temporária que receberá
-- os dados brutos do arquivo CSV antes da normalização
-- ============================================

USE `DB_CRIMES_LA`;

-- Remove a tabela stage se já existir
DROP TABLE IF EXISTS `CRIME_STAGE`;

-- Cria a tabela stage com a mesma estrutura do CSV
CREATE TABLE `CRIME_STAGE` (
  `DR_NO` INT NOT NULL,
  `Date_Rptd` VARCHAR(50) NULL,
  `DATE_OCC` VARCHAR(50) NULL,
  `TIME_OCC` VARCHAR(10) NULL,
  `AREA` INT NULL,
  `AREA_NAME` VARCHAR(100) NULL,
  `Rpt_Dist_No` INT NULL,
  `Part_1_2` INT NULL,
  `Crm_Cd` INT NULL,
  `Crm_Cd_Desc` VARCHAR(255) NULL,
  `Mocodes` TEXT NULL,
  `Vict_Age` VARCHAR(10) NULL,
  `Vict_Sex` CHAR(1) NULL,
  `Vict_Descent` CHAR(1) NULL,
  `Premis_Cd` VARCHAR(10) NULL,
  `Premis_Desc` VARCHAR(150) NULL,
  `Weapon_Used_Cd` VARCHAR(10) NULL,
  `Weapon_Desc` VARCHAR(150) NULL,
  `Status` CHAR(2) NULL,
  `Status_Desc` VARCHAR(100) NULL,
  `Crm_Cd_1` VARCHAR(10) NULL,
  `Crm_Cd_2` VARCHAR(10) NULL,
  `Crm_Cd_3` VARCHAR(10) NULL,
  `Crm_Cd_4` VARCHAR(10) NULL,
  `LOCATION` VARCHAR(100) NULL,
  `Cross_Street` VARCHAR(100) NULL,
  `LAT` VARCHAR(20) NULL,
  `LON` VARCHAR(20) NULL,
  PRIMARY KEY (`DR_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Índices para melhorar a performance durante a transformação
CREATE INDEX idx_stage_status ON `CRIME_STAGE`(`Status`);
CREATE INDEX idx_stage_weapon ON `CRIME_STAGE`(`Weapon_Used_Cd`);
CREATE INDEX idx_stage_premis ON `CRIME_STAGE`(`Premis_Cd`);
CREATE INDEX idx_stage_crm_cd ON `CRIME_STAGE`(`Crm_Cd`);
CREATE INDEX idx_stage_location ON `CRIME_STAGE`(`LAT`, `LON`);

SELECT 'Tabela CRIME_STAGE criada com sucesso!' AS Resultado;

