$diretorio = "D:\caminho\seu_diretorio"
$original_hosts_file = Join-Path -Path $diretorio -ChildPath "hosts.txt"
$backup_hosts_file = Join-Path -Path $diretorio -ChildPath "hosts_backup.txt"

# Função para montar lista de IPs e hosts
function ConstruirLista {
    param(
        [string]$tipo_servidor
    )

    $hosts_extra = @()
    try {
        if ($tipo_servidor -eq "Fisico") {
            # Hosts servidores
            $json_ips = '[{"ip": "192.168.10.10"}, {"ip": "192.168.10.11"}]'
            $nomes_servidores = @("SERVER01", "SERVER02")
            $ips = $json_ips | ConvertFrom-Json
            
            for ($i = 0; $i -lt $nomes_servidores.Length; $i++) {
                $nome_servidor = $nomes_servidores[$i]
                $ip = $ips[$i].ip
                $hosts_extra += "$ip $nome_servidor"
            }
            
            # Hosts Aplicações
            $json_ips = '[{"ip": "192.168.10.12"}, {"ip": "192.168.10.13"}]'
            $nomes_aplicacoes = @("appA.com", "appB.com")
            $ips = $json_ips | ConvertFrom-Json
            
            for ($i = 0; $i -lt $nomes_aplicacoes.Length; $i++) {
                $nome_aplicacao = $nomes_aplicacoes[$i]
                $ip = $ips[$i].ip
                $hosts_extra += "$ip $nome_aplicacao"
            }
            
            # Hosts Serviços
            $json_ips = '[{"ip": "192.168.10.14"}]'
            $nomes_servicos = @("servicoX")
            $ips = $json_ips | ConvertFrom-Json
            
            for ($i = 0; $i -lt $nomes_servicos.Length; $i++) {
                $nome_servico = $nomes_servicos[$i]
                $ip = $ips[$i].ip
                $hosts_extra += "$ip $nome_servico"
            }
            
            # Hosts Administração
            $json_ips = '[{"ip": "192.168.10.15"}]'
            $nomes_admin = @("admin.exemplo.local")
            $ips = $json_ips | ConvertFrom-Json
            
            for ($i = 0; $i -lt $nomes_admin.Length; $i++) {
                $nome_admin = $nomes_admin[$i]
                $ip = $ips[$i].ip
                $hosts_extra += "$ip $nome_admin"
            }
            
        } elseif ($tipo_servidor -eq "Virtual") {
            # Hosts servidores
            $json_ips = '[{"ip": "192.168.20.10"}, {"ip": "192.168.20.11"}]'
            $nomes_servidores = @("VSERVER01", "VSERVER02")
            $ips = $json_ips | ConvertFrom-Json
            
            for ($i = 0; $i -lt $nomes_servidores.Length; $i++) {
                $nome_servidor = $nomes_servidores[$i]
                $ip = $ips[$i].ip
                $hosts_extra += "$ip $nome_servidor"
            }
            
            # Hosts Aplicações
            $json_ips = '[{"ip": "192.168.20.12"}, {"ip": "192.168.20.13"}]'
            $nomes_aplicacoes = @("appX.com", "appY.com")
            $ips = $json_ips | ConvertFrom-Json
            
            for ($i = 0; $i -lt $nomes_aplicacoes.Length; $i++) {
                $nome_aplicacao = $nomes_aplicacoes[$i]
                $ip = $ips[$i].ip
                $hosts_extra += "$ip $nome_aplicacao"
            }
            
            # Hosts Serviços
            $json_ips = '[{"ip": "192.168.20.14"}]'
            $nomes_servicos = @("servicoY")
            $ips = $json_ips | ConvertFrom-Json
            
            for ($i = 0; $i -lt $nomes_servicos.Length; $i++) {
                $nome_servico = $nomes_servicos[$i]
                $ip = $ips[$i].ip
                $hosts_extra += "$ip $nome_servico"
            }
            
            # Hosts Administração
            $json_ips = '[{"ip": "192.168.20.15"}]'
            $nomes_admin = @("admin.exemplo.local")
            $ips = $json_ips | ConvertFrom-Json
            
            for ($i = 0; $i -lt $nomes_admin.Length; $i++) {
                $nome_admin = $nomes_admin[$i]
                $ip = $ips[$i].ip
                $hosts_extra += "$ip $nome_admin"
            }
            
        }
    } catch {
        Write-Host "Erro ao construir a lista de hosts: $_"
    }
    return $hosts_extra
}

# Função para processar o conteúdo
function ValidarConteudo {
    param (
        [string]$hosts_extra,
        [string]$original_hosts_file,
        [string]$backup_hosts_file
    )

    try {
        # Verifica se o arquivo original existe
        if (Test-Path $original_hosts_file) {
            $conteudo = Get-Content -Path $original_hosts_file -Raw
            # Verifica se o conteúdo do arquivo é diferente do esperado
            if ($conteudo -ne $hosts_extra) {
                $trace_log += "$original_hosts_file esta incorreto! Conteudo: $conteudo. Gerando um backup e corrigindo o arquivo original...`n"
                # Cria uma cópia do arquivo original para backup
                Copy-Item -Path $original_hosts_file -Destination $backup_hosts_file -Force
                $trace_log += "$backup_hosts_file criado `n"
                # Atualiza o arquivo original com o conteúdo correto
                $hosts_extra | Out-File -FilePath $original_hosts_file -Force
                $exec_mensagem = "$original_hosts_file foi corrigido"
            } else {
                $exec_mensagem = "$original_hosts_file esta correto"
            }
            $trace_log += "$exec_mensagem`n"
        } else {
            $trace_log += "Nao existe arquivo, gerando novo arquivo...`n"
            $hosts_extra | Out-File -FilePath $original_hosts_file -Force
            $exec_mensagem = "$original_hosts_file foi gerado"
            $trace_log += "$exec_mensagem`n"
        }
        
        if($exec_mensagem -match [Regex]::Escape("$original_hosts_file")) {
            return $true, $exec_mensagem, $trace_log
        }

        return $true, $exec_mensagem, $trace_log
    } catch {
        Write-Host "Erro: $_"
        $trace_log += "Erro: $_`n"
    }

    return $trace_log
}

# Inicializa as variáveis
$pre_msg = "Mensagem de pré-execução aqui."
$trace_log = "" 
$servidorNomeValido = $true

# Trata as exceções e a saída final
try {
    $trace_log = "Iniciando o processo `n"
    if ($servidorNomeValido) {
        $exec_status = "SUCESSO"
        $resultado_categoria = "CONCLUIDO"
    }
} catch {
    $resultado_categoria = "ERRO_SCRIPT"
    $exec_mensagem = "Erro ao executar o script: $_"
    $trace_log += "$($_.Exception.Message) $_ $($_.ScriptStackTrace)"
} finally {
    $exec_mensagem = "$pre_msg `n`n$exec_mensagem"
    Write-Host "$exec_status;$resultado_categoria;$($exec_mensagem.Replace('`n', '\n'));$($trace_log.Replace('`n', '\n'))"
}

# Lista de IPs e hosts para os servidores 
$extra_fisico = ConstruirLista -tipo_servidor "Fisico"
$extra_virtual = ConstruirLista -tipo_servidor "Virtual"
$extra = $extra_fisico + $extra_virtual

# Processando o conteúdo
ValidarConteudo -hosts_extra ($extra -join "`n") -original_hosts_file $original_hosts_file -backup_hosts_file $backup_hosts_file
