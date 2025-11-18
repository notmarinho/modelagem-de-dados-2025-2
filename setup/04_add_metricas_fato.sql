-- ============================================
-- Script 04: Adicionar Novas Métricas na Tabela Fato_Crimes
-- ============================================
-- Este script adiciona duas novas métricas na tabela fato:
-- 1. Tempo_Entre_Ocorrencia_Relato (em horas)
-- 2. Idade_Vitima
-- 
-- NOTA: Este script é idempotente - pode ser executado múltiplas vezes
-- sem causar erros se as colunas já existirem.
-- ============================================

USE `DW_CRIMES_LA`;

-- Adicionar coluna Tempo_Entre_Ocorrencia_Relato (se não existir)
-- Representa a diferença em horas entre a data de ocorrência e a data de relato
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'DW_CRIMES_LA'
  AND TABLE_NAME = 'Fato_Crimes'
  AND COLUMN_NAME = 'Tempo_Entre_Ocorrencia_Relato';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE `Fato_Crimes` ADD COLUMN `Tempo_Entre_Ocorrencia_Relato` DECIMAL(10,2) NULL COMMENT ''Tempo em horas entre DATE_OCC e Date_Rptd''',
    'SELECT ''Coluna Tempo_Entre_Ocorrencia_Relato já existe'' AS Result');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Adicionar coluna Idade_Vitima (se não existir)
-- Idade da vítima no momento da ocorrência
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'DW_CRIMES_LA'
  AND TABLE_NAME = 'Fato_Crimes'
  AND COLUMN_NAME = 'Idade_Vitima';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE `Fato_Crimes` ADD COLUMN `Idade_Vitima` SMALLINT NULL COMMENT ''Idade da vítima no momento da ocorrência''',
    'SELECT ''Coluna Idade_Vitima já existe'' AS Result');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT 'Verificação de colunas concluída na tabela Fato_Crimes!' AS Result;

