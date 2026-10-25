.data
    eka_viesti: .string "Luku: "
    .align 2
    virhe: .string "Luku oltava 0-12"
    .align 2
    tuloste: .string "Kertoma on: "
    .align 2
    eka_kerrottava: .word 0
    tulos: .word 0
    
.text
    main:
        la x11, eka_viesti
        jal x1, kysy_syote
        la  x5, eka_kerrottava
        sw x11, 0(x5)
        addi sp, sp, -4
        sw x10, 0(sp)
        addi x16, x0, 12
        jal x1, vertaa_itseisarvo
        bne x10, x0, vaara_syote
        lw x10, 0(sp)  
        addi x11, x0, 1
        addi x12, x0, 2
        beq x14, x0, yksi
        beq x14, x11, yksi
    kertoma:
        addi x10, x0, 0
        jal x1, kertolasku
        addi x11, x10, 0
        addi x12, x12, 1
        ble x12, x14, kertoma
        la x5, tulos
        sw x10, 0(x5)  
        
        la a0, tuloste
        li a7, 4
        ecall
        la a0, tulos
        lw a0, 0(a0)
        li a7, 1
        ecall
        j loppu
    
    yksi:
        la x5, tulos
        addi x10, x0, 1
        sw x10, 0(x5)

    kertolasku:
        add x13, x0, x12
        blt x12, x0, laskuri_positiiviseksi
        j lisaa_loop
   
    lisaa_loop: beq x13, x0, tarkista_merkki     
        add x10, x10, x11
        addi x13, x13, -1
        j lisaa_loop
    
    tarkista_merkki:
        addi sp, sp, -4
        sw x14, 0(sp)
        xor x14, x11, x12
        srli x14, x14, 31
        addi x13, x10, 0
        srli x13, x13, 31
        bne x14, x13, korjaa_merkki
        lw x14, 0(sp)
        addi sp, sp, 4
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
    
    kysy_syote:
        mv a0, x11
        li a7, 4
        ecall
        li a7, 5
        ecall
        mv x14, a0
        addi a0, x0, 0
        jalr x0, 0(x1)
        
    vertaa_itseisarvo:
        blt x14, x0, itseisarvo_suurempi
        bgt x14, x16, itseisarvo_suurempi
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
