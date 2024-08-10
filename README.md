# Automação de Arquivo Hosts

Este repositório contém um script PowerShell para gerenciar e validar arquivos de hosts. O script inclui dados fictícios para fins de exemplo e demonstração. 

- **Construir uma lista de IPs e hosts** com base no tipo de servidor (Físico ou Virtual).
- **Validar o conteúdo do arquivo hosts** original e atualizar ou criar um novo arquivo se necessário.
- **Criar um backup** do arquivo hosts original antes de fazer alterações.

## Requisitos

- PowerShell 5.0 ou superior
- Acesso ao diretório onde o arquivo `hosts.txt` está localizado

## Estrutura do Script

**Definições Iniciais**
   - Define o diretório onde os arquivos `hosts.txt` e `hosts_backup.txt` estão localizados.

**Função `ConstruirLista`**
   - **Parâmetro:** `$tipo_servidor` - Define se o servidor é "Fisico" ou "Virtual".
   - **Processo:**
     - Cria listas de IPs e nomes de servidores, aplicações, serviços e administração com base no tipo de servidor.
     - Usa dados em JSON para gerar a lista de hosts.

**Função `ValidarConteudo`**
   - **Parâmetros:**
     - `$hosts_extra` - Conteúdo esperado para o arquivo hosts.
     - `$original_hosts_file` - Caminho do arquivo hosts original.
     - `$backup_hosts_file` - Caminho do arquivo de backup.
   - **Processo:**
     - Verifica se o conteúdo do arquivo original está correto.
     - Se não estiver, cria um backup e atualiza o arquivo original.
     - Se o arquivo original não existir, cria um novo arquivo.

**Execução do Script**
   - Inicializa variáveis e executa a função `ConstruirLista` para servidores físicos e virtuais.
   - Processa e valida o conteúdo do arquivo hosts.

## Uso

**Configuração**
   - Modifique o caminho das variáveis `$diretorio`, `$original_hosts_file`, e `$backup_hosts_file` para refletir o diretório onde seus arquivos estão localizados.

**Verificar o Resultado**
   - O script irá criar ou atualizar o arquivo `hosts.txt` e gerar um backup se necessário.
   - Mensagens de status e logs serão exibidos no console do PowerShell.

