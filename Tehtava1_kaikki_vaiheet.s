.data
    eka_viesti: .string "Eka kerrottava: "
    .align 2
    toka_viesti: .string "Toka kerrottava: "
    .align 2
    virhe: .string "Kerrottavan luvun oltava pienempi kuin 1000"
    eka_kerrottava: .word 0
    toka_kerrottava: .word 0
    tulos: .word 0
    
.text
    main:
        la x11, eka_viesti
        la x12, toka_viesti
        jal x1, kysy_syote
        la  x5, eka_kerrottava
        sw x11, 0(x5)
        la x5, toka_kerrottava
        sw x12, 0(x5)
        addi sp, sp, -4
        sw x10, 0(sp)
        addi x16, x0, 1000
        jal x1, vertaa_itseisarvo
        bne x10, x0, vaara_syote
        lw x10, 0(sp)
        jal x1, kertolasku
        la x5, tulos
        sw x10, 0(x5)
        j loppu
        
    kertolasku:
        add x13, x0, x12
        blt x12, x0, laskuri_positiiviseksi
        j lisaa_loop
   
    lisaa_loop: beq x13, x0, tarkista_merkki     
        add x10, x10, x11
        addi x13, x13, -1
        j lisaa_loop
    
    tarkista_merkki:
        xor x14, x11, x12
        srli x14, x14, 31
        addi x13, x10, 0
        srli x13, x13, 31
        bne x14, x13, korjaa_merkki
        jalr x0, 0(x1)
    
    korjaa_merkki:
        blt x10, x0, kaanna_neg
        #Jos positiivinen 
        not x10, x10
        addi x10, x10, +1
        jalr x0, 0(x1)
    kaanna_neg:
        addi x10, x10, -1
        not x10, x10 
        jalr x0, 0(x1)
 
    laskuri_positiiviseksi:
        addi x13, x13, -1
        not x13, x13
        j lisaa_loop
    
    #Pyytää käyttäjää antamaan kaksi
    #kokonaislukua jotka kerrotaan
    kysy_syote:
        mv a0, x11
        li a7, 4
        ecall
        li a7, 5
        ecall
        mv x11, a0
        
        mv a0, x12
        li a7, 4
        ecall
        addi a0, x0, 0
        li a7, 5
        ecall
        mv x12, a0
        addi a0, x0, 0
        jalr x0, 0(x1)

    #Vertaa rekistereissä x11 ja x12 olevien lukujen
    #arvoa lukuun x rekisterissä x16 ja -x rekisterissä x15
    vertaa_itseisarvo:
        not x15, x16
        addi x15, x15, 1
        blt x11, x15, itseisarvo_suurempi
        bgt x11, x16, itseisarvo_suurempi
        blt x12, x15, itseisarvo_suurempi
        bgt x12, x16, itseisarvo_suurempi
        addi x10, x0, 0
        jalr x0, 0(x1)
        itseisarvo_suurempi:
        addi x10, x0, 1
    
    vaara_syote:
        la a0, virhe
        li a7, 4
        ecall
        j loppu
    
    loppu:
        j loppu     
