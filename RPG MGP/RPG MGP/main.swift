
//
//  main.swift
//  RPG MGP
//
//  Created by MURILO GIAMPICCOLO PAPA on 14/11/25.
//

import Foundation

func lerLinha() -> String {
    return (readLine() ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
}

func esperarEnter() {
    print("\n[Aperte ENTER para continuar]")
    _ = readLine()
}

var player = [String: Int]()
player["lvl"] = 1
player["vida"] = 10
player["maxvida"] = 10
player["dano"] = 3

var enemy1 = [String: Int]()
enemy1["vida"] = 12
enemy1["maxvida"] = 12
enemy1["danoMin"] = 1
enemy1["danoMax"] = 4

var enemy2 = [String: Int]()
enemy2["vida"] = 10
enemy2["maxvida"] = 10
enemy2["danoMin"] = 2
enemy2["danoMax"] = 5

let place: [String: String] = [
    "floresta": "enemy1",
    "torre": "enemy2"
]

func danoDoJogador() -> Int {
    let base = player["dano"] ?? 0
    let variacao = Int.random(in: 0...2)
    return base + variacao
}

func danoDoInimigo(_ enemy: [String: Int]) -> Int {
    let min = enemy["danoMin"] ?? 1
    let max = enemy["danoMax"] ?? min
    return Int.random(in: min...max)
}

func mostrarStatus(jogadorNome: String, inimigoNome: String, enemy: [String: Int]) {
    let vidaJogador = player["vida"] ?? 0
    let maxVidaJogador = player["maxvida"] ?? 0
    let lvl = player["lvl"] ?? 1
    let vidaInimigo = enemy["vida"] ?? 0
    let maxVidaInimigo = enemy["maxvida"] ?? 0
    
    print("\n--- Status ---")
    print("\(jogadorNome) • Nível \(lvl) • Vida: \(vidaJogador)/\(maxVidaJogador)")
    print("\(inimigoNome) • Vida: \(vidaInimigo)/\(maxVidaInimigo)")
}

func batalha(inimigoNome: String, enemyBase: [String: Int]) -> Bool {
    var enemy = enemyBase
    print("\nVocê encontrou um(a) \(inimigoNome)!")
    
    batalhaLoop: while (player["vida"] ?? 0) > 0 && (enemy["vida"] ?? 0) > 0 {
        mostrarStatus(jogadorNome: nomeJogador, inimigoNome: inimigoNome, enemy: enemy)
        print("""
              
              Escolha sua ação:
              1) Atacar
              2) Defender
              3) Tentar fugir
              Opção (padrão = 1): 
              """, terminator: "")
        
        let escolha = lerLinha()
        
        switch escolha {
        case "2":
            let danoInimigo = danoDoInimigo(enemy) / 2
            player["vida"] = (player["vida"] ?? 0) - danoInimigo
            print("\nVocê se defende! O inimigo causa \(danoInimigo) de dano reduzido.")
            
        case "3":
            let chance = Int.random(in: 1...100)
            if chance <= 50 {
                print("\nVocê conseguiu fugir da batalha!")
                break batalhaLoop
            } else {
                print("\nVocê tentou fugir, mas o inimigo te alcançou!")
                let danoInimigo = danoDoInimigo(enemy)
                player["vida"] = (player["vida"] ?? 0) - danoInimigo
                print("Enquanto fugia, você levou \(danoInimigo) de dano.")
            }
            
        default:
            let danoJogador = danoDoJogador()
            enemy["vida"] = (enemy["vida"] ?? 0) - danoJogador
            print("\nVocê ataca e causa \(danoJogador) de dano no(a) \(inimigoNome).")
            
            if (enemy["vida"] ?? 0) <= 0 {
                print("Você derrotou o(a) \(inimigoNome)!")
                break batalhaLoop
            }
            
            let danoInimigo = danoDoInimigo(enemy)
            player["vida"] = (player["vida"] ?? 0) - danoInimigo
            print("O(a) \(inimigoNome) reage e causa \(danoInimigo) de dano em você.")
        }
        
        if (player["vida"] ?? 0) <= 0 {
            print("\nVocê foi derrotado...")
        }
    }
    
    return (player["vida"] ?? 0) > 0
}

func subirDeNivel() {
    player["lvl"] = (player["lvl"] ?? 1) + 1
    player["maxvida"] = (player["maxvida"] ?? 10) + 3
    player["dano"] = (player["dano"] ?? 3) + 1
    player["vida"] = player["maxvida"]
    print("\n===== LEVEL UP! =====")
    print("Você subiu para o nível \(player["lvl"] ?? 1)!")
    print("Sua vida máxima agora é \(player["maxvida"] ?? 0) e seu dano base é \(player["dano"] ?? 0).")
}

print("Bem vindo à terra de Midgard!")
print("Qual é o nome do seu herói? ", terminator: "")
var nomeJogador = lerLinha()
if nomeJogador.isEmpty {
    nomeJogador = "Herói"
}

var jogoAtivo = true

while jogoAtivo && (player["vida"] ?? 0) > 0 {
    print("""
          
          \nVocê está na estrada principal de Midgard.
          Deseja explorar a floresta ou a torre?
          1) Floresta (inimigos mais fracos)
          2) Torre (inimigos mais fortes)
          3) Descansar na fogueira (+vida)
          4) Sair do jogo
          Digite 1, 2, 3 ou 4 (ou escreva "floresta"/"torre"):
          """, terminator: " ")
    
    let escolha = lerLinha().lowercased()
    
    switch escolha {
    case "2", "torre":
        print("\nVocê segue em direção à antiga torre sombria...")
        let venceu = batalha(inimigoNome: "Guerreiro Esqueleto", enemyBase: enemy2)
        if venceu {
            subirDeNivel()
        } else {
            jogoAtivo = false
        }
        esperarEnter()
        
    case "3":
        print("\nVocê descansa na fogueira. Sua vida é restaurada.")
        player["vida"] = player["maxvida"]
        esperarEnter()
        
    case "4":
        print("\nVocê decide encerrar sua aventura por hoje. Até a próxima, \(nomeJogador)!")
        jogoAtivo = false
        
    default:
        print("\nVocê entra na floresta densa de Midgard...")
        let venceu = batalha(inimigoNome: "Goblin da Floresta", enemyBase: enemy1)
        if venceu {
            subirDeNivel()
        } else {
            jogoAtivo = false
        }
        esperarEnter()
    }
}

print("\n=== FIM DE JOGO ===")
