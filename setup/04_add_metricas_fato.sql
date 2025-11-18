-- ============================================
-- Script 04: Adicionar Novas Métricas na Tabela Fato_Crimes
-- ============================================
-- Este script adiciona duas novas métricas na tabela fato:
-- 1. Tempo_Entre_Ocorrencia_Relato (em horas)
-- 2. Idade_Vitima
-- ============================================

USE `DW_CRIMES_LA`;

-- Adicionar coluna Tempo_Entre_Ocorrencia_Relato
-- Representa a diferença em horas entre a data de ocorrência e a data de relato
ALTER TABLE `Fato_Crimes` 
ADD COLUMN `Tempo_Entre_Ocorrencia_Relato` DECIMAL(10,2) NULL 
COMMENT 'Tempo em horas entre DATE_OCC e Date_Rptd';

-- Adicionar coluna Idade_Vitima
-- Idade da vítima no momento da ocorrência
ALTER TABLE `Fato_Crimes` 
ADD COLUMN `Idade_Vitima` SMALLINT NULL 
COMMENT 'Idade da vítima no momento da ocorrência';

SELECT 'Colunas adicionadas na tabela Fato_Crimes com sucesso!' AS Result;

