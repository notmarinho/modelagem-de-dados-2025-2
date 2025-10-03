import pandas as pd

# 1. Carregar o arquivo CSV
try:
    df = pd.read_csv("Crime_Data_from_2023_to_Present.csv", encoding='latin1')
except UnicodeDecodeError:
    # Tente 'utf-8' se 'latin1' não funcionar, ou vice-versa
    df = pd.read_csv("Crime_Data_from_2023_to_Present.csv", encoding='utf-8') 

# 2. Definir as colunas que precisam de correção
# Adicione aqui todas as colunas que dão o erro 1366
colunas_para_corrigir = ['Weapon Used Cd', 'Crm Cd 1', 'Crm Cd 2', 'Crm Cd 3', 'Crm Cd 4']

# 3. Substituir valores vazios/nulos (NaN) por 0 nas colunas
# O método .fillna(0) é muito rápido e eficiente
df[colunas_para_corrigir] = df[colunas_para_corrigir].fillna(0)

# Opcional: Se houver strings vazias reais (não apenas nulos), 
# você pode forçar a substituição (geralmente .fillna(0) já resolve)
df[colunas_para_corrigir] = df[colunas_para_corrigir].replace('', 0)

# 4. Salvar o novo arquivo CSV corrigido
df.to_csv("Crime_Data_from_2023_to_Present_corrigido.csv", index=False)

print("Arquivo corrigido salvo como 'Crime_Data_from_2023_to_Present_corrigido.csv'.")