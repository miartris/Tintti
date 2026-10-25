.data
virhe: .string "Syöte väärä"
vakiotuloste: .string "Osoitteessa testi olevan merkkijonon pituus on "
testi:  .ascii "Testimerkkijono"
.align 2

.text
main:
la x12, testi
addi x13, x13, 128
jal x1, laske_merkkijonon_pituus
j tulos

#Pituuden laskeva aliohjelma
#Haetaan tavu muistiosoitteesta joka rekisterissä x12
#Annetaan x12 seuraava muistiosoite
#Lopetetaan kun nähdään tyhjä tavu
laske_merkkijonon_pituus:
lb x11, 0(x12)

#Ascii-merkkijonon pituus välillä (2^0, 2^7 - 1)
blt x11, x0, syote_ei_ascii
bge x11, x13, syote_ei_ascii

bne x0, x11, jatka
jalr x0, 0(x1)

jatka:
addi x20, x20, 1
addi x12, x12, 1
j laske_merkkijonon_pituus

#Jos merkkijono ei ascii, esim jos sisältää ä tai ö
syote_ei_ascii:
la a0, virhe
li a7, 4
ecall
ebreak
j loppu

tulos:
la a0, vakiotuloste
li a7, 4
ecall

addi a0, x20, 0
li a7, 1
ecall

loppu:
j loppu