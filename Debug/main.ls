   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.9 - 19 Apr 2023
   3                     ; Generator (Limited) V4.5.6 - 18 Jul 2023
  14                     	bsct
  15  0000               _home_ten:
  16  0000 00            	dc.b	0
  17  0001               _home_one:
  18  0001 00            	dc.b	0
  19  0002               _away_ten:
  20  0002 00            	dc.b	0
  21  0003               _away_one:
  22  0003 00            	dc.b	0
  23  0004               _second:
  24  0004 00            	dc.b	0
  25  0005               _data:
  26  0005 00            	dc.b	0
  27  0006               _home:
  28  0006 00            	dc.b	0
  29  0007               _away:
  30  0007 00            	dc.b	0
  31  0008               _state:
  32  0008 01            	dc.b	1
  72                     ; 48 uint8_t readCharacter(uint8_t block)	// loe uardist tähemärk
  72                     ; 49 {
  74                     	switch	.text
  75  0000               _readCharacter:
  79                     ; 50 	if (block == 0)
  81  0000 4d            	tnz	a
  82  0001 260e          	jrne	L14
  83                     ; 52 		if(UART1->SR & UART1_SR_RXNE) return UART1->DR; // ootan kuni bait saabub
  85  0003 c65230        	ld	a,21040
  86  0006 a520          	bcp	a,#32
  87  0008 2704          	jreq	L13
  90  000a c65231        	ld	a,21041
  93  000d 81            	ret
  94  000e               L13:
  95                     ; 53 		else return 0xFF;
  97  000e a6ff          	ld	a,#255
 100  0010 81            	ret
 101  0011               L14:
 102                     ; 57 		while (!(UART1->SR & UART1_SR_RXNE));
 104  0011 c65230        	ld	a,21040
 105  0014 a520          	bcp	a,#32
 106  0016 27f9          	jreq	L14
 107                     ; 58 		return UART1->DR;
 109  0018 c65231        	ld	a,21041
 112  001b 81            	ret
 115                     .const:	section	.text
 116  0000               _tabel:
 117  0000 7e            	dc.b	126
 118  0001 0c            	dc.b	12
 119  0002 b6            	dc.b	182
 120  0003 9e            	dc.b	158
 121  0004 cc            	dc.b	204
 122  0005 da            	dc.b	218
 123  0006 fa            	dc.b	250
 124  0007 0e            	dc.b	14
 125  0008 fe            	dc.b	254
 126  0009 de            	dc.b	222
 127  000a c6            	dc.b	198
 128  000b 72            	dc.b	114
 160                     ; 79 void delay(uint16_t d)	// viite funktsioon
 160                     ; 80 {
 161                     	switch	.text
 162  001c               _delay:
 164  001c 89            	pushw	x
 165       00000000      OFST:	set	0
 168  001d               L56:
 169                     ; 81 	while(d--);
 171  001d 1e01          	ldw	x,(OFST+1,sp)
 172  001f 1d0001        	subw	x,#1
 173  0022 1f01          	ldw	(OFST+1,sp),x
 174  0024 1c0001        	addw	x,#1
 175  0027 a30000        	cpw	x,#0
 176  002a 26f1          	jrne	L56
 177                     ; 82 }
 180  002c 85            	popw	x
 181  002d 81            	ret
 223                     	switch	.const
 224  000c               L41:
 225  000c fffffbfc      	dc.l	-1028
 226  0010               L61:
 227  0010 00002710      	dc.l	10000
 228  0014               L02:
 229  0014 0000000a      	dc.l	10
 230                     ; 84 void show_temp(void)	// näita temperatuuri funktsioon
 230                     ; 85 {
 231                     	switch	.text
 232  002e               _show_temp:
 234  002e 88            	push	a
 235       00000001      OFST:	set	1
 238                     ; 87 	summa = 0;
 240  002f 5f            	clrw	x
 241  0030 bf04          	ldw	_summa,x
 242                     ; 89 	for(i=0; i<64; i++)
 244  0032 0f01          	clr	(OFST+0,sp)
 246  0034               L701:
 247                     ; 92 		 taimer=200;
 249  0034 35c80006      	mov	_taimer,#200
 251  0038               L121:
 252                     ; 93 		 while(taimer--);
 254  0038 b606          	ld	a,_taimer
 255  003a 3a06          	dec	_taimer
 256  003c 4d            	tnz	a
 257  003d 26f9          	jrne	L121
 258                     ; 95 		 ADC1->CR1 |= ADC1_CR1_ADON;
 260  003f 72105401      	bset	21505,#0
 262  0043               L721:
 263                     ; 96 		 while (((ADC1->CSR)&(1<<7))==0);//(ADC_CSR_bit.EOC==0);
 265  0043 c65400        	ld	a,21504
 266  0046 a580          	bcp	a,#128
 267  0048 27f9          	jreq	L721
 268                     ; 99 		 tulemus = ADC1->DRL;
 270  004a c65405        	ld	a,21509
 271  004d 5f            	clrw	x
 272  004e 97            	ld	xl,a
 273  004f bf07          	ldw	_tulemus,x
 274                     ; 100 		 tulemus |= ADC1->DRH<<8;
 276  0051 c65404        	ld	a,21508
 277  0054 5f            	clrw	x
 278  0055 97            	ld	xl,a
 279  0056 4f            	clr	a
 280  0057 02            	rlwa	x,a
 281  0058 01            	rrwa	x,a
 282  0059 ba08          	or	a,_tulemus+1
 283  005b 01            	rrwa	x,a
 284  005c ba07          	or	a,_tulemus
 285  005e 01            	rrwa	x,a
 286  005f bf07          	ldw	_tulemus,x
 287                     ; 101 		 summa+=tulemus;
 289  0061 be04          	ldw	x,_summa
 290  0063 72bb0007      	addw	x,_tulemus
 291  0067 bf04          	ldw	_summa,x
 292                     ; 89 	for(i=0; i<64; i++)
 294  0069 0c01          	inc	(OFST+0,sp)
 298  006b 7b01          	ld	a,(OFST+0,sp)
 299  006d a140          	cp	a,#64
 300  006f 25c3          	jrult	L701
 301                     ; 103 	tulemus=summa/64;
 303  0071 be04          	ldw	x,_summa
 304  0073 a606          	ld	a,#6
 305  0075               L21:
 306  0075 54            	srlw	x
 307  0076 4a            	dec	a
 308  0077 26fc          	jrne	L21
 309  0079 bf07          	ldw	_tulemus,x
 310                     ; 105 	temp = ((int32_t)(tulemus)) * (-1028);
 312  007b be07          	ldw	x,_tulemus
 313  007d cd0000        	call	c_uitolx
 315  0080 ae000c        	ldw	x,#L41
 316  0083 cd0000        	call	c_lmul
 318  0086 ae0000        	ldw	x,#_temp
 319  0089 cd0000        	call	c_rtol
 321                     ; 106 	temp += 784420;
 323  008c aef824        	ldw	x,#63524
 324  008f bf02          	ldw	c_lreg+2,x
 325  0091 ae000b        	ldw	x,#11
 326  0094 bf00          	ldw	c_lreg,x
 327  0096 ae0000        	ldw	x,#_temp
 328  0099 cd0000        	call	c_lgadd
 330                     ; 107 	temp = temp/10000;			
 332  009c ae0000        	ldw	x,#_temp
 333  009f cd0000        	call	c_ltor
 335  00a2 ae0010        	ldw	x,#L61
 336  00a5 cd0000        	call	c_ldiv
 338  00a8 ae0000        	ldw	x,#_temp
 339  00ab cd0000        	call	c_rtol
 341                     ; 108 	home_one = (uint8_t)(temp % 10);
 343  00ae ae0000        	ldw	x,#_temp
 344  00b1 cd0000        	call	c_ltor
 346  00b4 ae0014        	ldw	x,#L02
 347  00b7 cd0000        	call	c_lmod
 349  00ba b603          	ld	a,c_lreg+3
 350  00bc b701          	ld	_home_one,a
 351                     ; 109 	temp /= 10;
 353  00be ae0000        	ldw	x,#_temp
 354  00c1 cd0000        	call	c_ltor
 356  00c4 ae0014        	ldw	x,#L02
 357  00c7 cd0000        	call	c_ldiv
 359  00ca ae0000        	ldw	x,#_temp
 360  00cd cd0000        	call	c_rtol
 362                     ; 110 	home_ten = (uint8_t)(temp);
 364  00d0 450300        	mov	_home_ten,_temp+3
 365                     ; 111 	away_ten = 10;
 367  00d3 350a0002      	mov	_away_ten,#10
 368                     ; 112 	away_one = 11;
 370  00d7 350b0003      	mov	_away_one,#11
 371                     ; 113 }
 374  00db 84            	pop	a
 375  00dc 81            	ret
 378                     	bsct
 379  0009               L331_counter:
 380  0009 00            	dc.b	0
 418                     ; 115 void calc_time(void) // kellaaja uuendamine
 418                     ; 116 {
 419                     	switch	.text
 420  00dd               _calc_time:
 424                     ; 119 	counter++;
 426  00dd 3c09          	inc	L331_counter
 427                     ; 120 	if(counter < 60) return;
 429  00df b609          	ld	a,L331_counter
 430  00e1 a13c          	cp	a,#60
 431  00e3 2401          	jruge	L351
 435  00e5 81            	ret
 436  00e6               L351:
 437                     ; 121 	counter = 0;
 439  00e6 3f09          	clr	L331_counter
 440                     ; 123 	away += 1;
 442  00e8 3c07          	inc	_away
 443                     ; 124 	if (away >= 60)
 445  00ea b607          	ld	a,_away
 446  00ec a13c          	cp	a,#60
 447  00ee 2504          	jrult	L551
 448                     ; 126 		home += 1;
 450  00f0 3c06          	inc	_home
 451                     ; 127 		away = 0;
 453  00f2 3f07          	clr	_away
 454  00f4               L551:
 455                     ; 129 	if (home >= 24)
 457  00f4 b606          	ld	a,_home
 458  00f6 a118          	cp	a,#24
 459  00f8 2502          	jrult	L751
 460                     ; 131 		home = 0;
 462  00fa 3f06          	clr	_home
 463  00fc               L751:
 464                     ; 134 	home_one = home % 10 & 0x0F;
 466  00fc b606          	ld	a,_home
 467  00fe 5f            	clrw	x
 468  00ff 97            	ld	xl,a
 469  0100 a60a          	ld	a,#10
 470  0102 62            	div	x,a
 471  0103 5f            	clrw	x
 472  0104 97            	ld	xl,a
 473  0105 9f            	ld	a,xl
 474  0106 a40f          	and	a,#15
 475  0108 b701          	ld	_home_one,a
 476                     ; 135 	home_ten = (home/10)%10 & 0x0F;
 478  010a b606          	ld	a,_home
 479  010c 5f            	clrw	x
 480  010d 97            	ld	xl,a
 481  010e a60a          	ld	a,#10
 482  0110 cd0000        	call	c_sdivx
 484  0113 a60a          	ld	a,#10
 485  0115 cd0000        	call	c_smodx
 487  0118 01            	rrwa	x,a
 488  0119 a40f          	and	a,#15
 489  011b 5f            	clrw	x
 490  011c b700          	ld	_home_ten,a
 491                     ; 136 	away_one = away %10 & 0x0F;
 493  011e b607          	ld	a,_away
 494  0120 5f            	clrw	x
 495  0121 97            	ld	xl,a
 496  0122 a60a          	ld	a,#10
 497  0124 62            	div	x,a
 498  0125 5f            	clrw	x
 499  0126 97            	ld	xl,a
 500  0127 9f            	ld	a,xl
 501  0128 a40f          	and	a,#15
 502  012a b703          	ld	_away_one,a
 503                     ; 137 	away_ten = (away/10)%10 & 0x0F;
 505  012c b607          	ld	a,_away
 506  012e 5f            	clrw	x
 507  012f 97            	ld	xl,a
 508  0130 a60a          	ld	a,#10
 509  0132 cd0000        	call	c_sdivx
 511  0135 a60a          	ld	a,#10
 512  0137 cd0000        	call	c_smodx
 514  013a 01            	rrwa	x,a
 515  013b a40f          	and	a,#15
 516  013d 5f            	clrw	x
 517  013e b702          	ld	_away_ten,a
 518                     ; 139 }
 521  0140 81            	ret
 545                     ; 141 void init(void)	// perifeeria seadistamine
 545                     ; 142 {
 546                     	switch	.text
 547  0141               _init:
 551                     ; 143 	GPIOB->ODR = 0x1E;
 553  0141 351e5005      	mov	20485,#30
 554                     ; 144 	GPIOB->DDR = 0x1E;
 556  0145 351e5007      	mov	20487,#30
 557                     ; 145 	GPIOB->CR1 = 0x1E;
 559  0149 351e5008      	mov	20488,#30
 560                     ; 147 	GPIOC->ODR = 0x00;
 562  014d 725f500a      	clr	20490
 563                     ; 148 	GPIOC->DDR = 0xFE;
 565  0151 35fe500c      	mov	20492,#254
 566                     ; 149 	GPIOC->CR1 = 0xFE;
 568  0155 35fe500d      	mov	20493,#254
 569                     ; 151   UART1->BRR2 = 0x01;     // uart baud rate esimene ja viimane  BRR2 esimesena!!!!!
 571  0159 35015233      	mov	21043,#1
 572                     ; 152   UART1->BRR1 = 0x01;     // uart baud rate 2MHZ / 115200 = 17 (keskmised 2)
 574  015d 35015232      	mov	21042,#1
 575                     ; 153   UART1->CR2 |= UART1_CR2_TEN;     // uardi saatmine lubatud
 577  0161 72165235      	bset	21045,#3
 578                     ; 154   UART1->CR2 |= UART1_CR2_REN;     // uardi vastuvõtmine sees
 580  0165 72145235      	bset	21045,#2
 581                     ; 156   ADC1->CSR=0x00;         // adc kanal 0
 583  0169 725f5400      	clr	21504
 584                     ; 157   ADC1->CR1=0x01;         // 0x kiirus, ad sisse
 586  016d 35015401      	mov	21505,#1
 587                     ; 158   ADC1->CR2=0x00;         // Left alignment
 589  0171 725f5402      	clr	21506
 590                     ; 159   ADC1->TDRL=0x10;        // AIN0 sisendbuffer v?lja
 592  0175 35105407      	mov	21511,#16
 593                     ; 161 	COM_ODR &= ~HOME10;
 595  0179 72155005      	bres	20485,#2
 596                     ; 164   TIM1->ARRH = 0;			// #define TIM1_ARRH_ARR    ((uint8_t)0xFF) /*!< Autoreload Value (MSB) mask. */ #define TIM1_ARRH_RESET_VALUE  ((uint8_t)0xFF)
 598  017d 725f5262      	clr	21090
 599                     ; 165   TIM1->ARRL = 0x03;		// #define TIM1_ARRL_ARR    ((uint8_t)0xFF) /*!< Autoreload Value (LSB) mask. */ #define TIM1_ARRL_RESET_VALUE  ((uint8_t)0xFF)
 601  0181 35035263      	mov	21091,#3
 602                     ; 167   TIM1->PSCRH = 0x07 ;	// #define TIM1_PSCH_PSC    ((uint8_t)0xFF) /*!< Prescaler Value (MSB) mask. */ #define TIM1_PSCRH_RESET_VALUE ((uint8_t)0x00
 604  0185 35075260      	mov	21088,#7
 605                     ; 168 	TIM1->PSCRL = 0xD0;	// #define TIM1_PSCL_PSC    ((uint8_t)0xFF) /*!< Prescaler Value (LSB) mask. */ #define TIM1_PSCRL_RESET_VALUE ((uint8_t)0x00)
 607  0189 35d05261      	mov	21089,#208
 608                     ; 169   TIM1->CR1 |= TIM1_CR1_CEN;		// #define TIM1_CR1_CEN     ((uint8_t)0x01) /*!< Counter Enable mask. */
 610  018d 72105250      	bset	21072,#0
 611                     ; 170 	TIM1->IER |= TIM1_IER_UIE;
 613  0191 72105254      	bset	21076,#0
 614                     ; 171 	enableInterrupts();
 617  0195 9a            rim
 619                     ; 175 	ADC1->CSR = 0x00;	//control status register 
 622  0196 725f5400      	clr	21504
 623                     ; 177   ADC1->CR1=0x01;         // 0x kiirus, ad sisse / conf register 1
 625  019a 35015401      	mov	21505,#1
 626                     ; 178   ADC1->CR2=0x08;         // Left alignment / conf register 2
 628  019e 35085402      	mov	21506,#8
 629                     ; 179   ADC1->TDRL=0x01;        // AIN0 sisendbuffer v?lja / ADC Schmitt trigger disable register low
 631  01a2 35015407      	mov	21511,#1
 632                     ; 180 }
 635  01a6 81            	ret
 671                     ; 183 int main( void )
 671                     ; 184 {
 672                     	switch	.text
 673  01a7               _main:
 677                     ; 186 	init();
 679  01a7 ad98          	call	_init
 681  01a9               L322:
 682                     ; 192 		data = readCharacter(0);
 684  01a9 4f            	clr	a
 685  01aa cd0000        	call	_readCharacter
 687  01ad b705          	ld	_data,a
 688                     ; 194 		switch(data)
 690  01af b605          	ld	a,_data
 692                     ; 282 			default:
 692                     ; 283 			
 692                     ; 284 			break;
 693  01b1 a041          	sub	a,#65
 694  01b3 2760          	jreq	L371
 695  01b5 a002          	sub	a,#2
 696  01b7 2603          	jrne	L03
 697  01b9 cc025f        	jp	L571
 698  01bc               L03:
 699  01bc a005          	sub	a,#5
 700  01be 270b          	jreq	L171
 701  01c0 a00c          	sub	a,#12
 702  01c2 2603          	jrne	L23
 703  01c4 cc0267        	jp	L771
 704  01c7               L23:
 705  01c7 ac2b032b      	jpf	L132
 706  01cb               L171:
 707                     ; 196 			case 'H':	// omade punktid
 707                     ; 197 				data  = readCharacter(1);
 709  01cb a601          	ld	a,#1
 710  01cd cd0000        	call	_readCharacter
 712  01d0 b705          	ld	_data,a
 713                     ; 198 				if (data >= '0' && data <= '9')
 715  01d2 b605          	ld	a,_data
 716  01d4 a130          	cp	a,#48
 717  01d6 2403          	jruge	L43
 718  01d8 cc032b        	jp	L132
 719  01db               L43:
 721  01db b605          	ld	a,_data
 722  01dd a13a          	cp	a,#58
 723  01df 2503          	jrult	L63
 724  01e1 cc032b        	jp	L132
 725  01e4               L63:
 726                     ; 200 					home_ten = data & 0x0F;
 728  01e4 b605          	ld	a,_data
 729  01e6 a40f          	and	a,#15
 730  01e8 b700          	ld	_home_ten,a
 732                     ; 204 				data  = readCharacter(1);
 734  01ea a601          	ld	a,#1
 735  01ec cd0000        	call	_readCharacter
 737  01ef b705          	ld	_data,a
 738                     ; 205 				if (data >= '0' && data <= '9')
 740  01f1 b605          	ld	a,_data
 741  01f3 a130          	cp	a,#48
 742  01f5 250c          	jrult	L732
 744  01f7 b605          	ld	a,_data
 745  01f9 a13a          	cp	a,#58
 746  01fb 2406          	jruge	L732
 747                     ; 207 					home_one = data & 0x0F;
 749  01fd b605          	ld	a,_data
 750  01ff a40f          	and	a,#15
 751  0201 b701          	ld	_home_one,a
 752  0203               L732:
 753                     ; 209 				if (state!=SCORE)
 755  0203 b608          	ld	a,_state
 756  0205 a102          	cp	a,#2
 757  0207 2704          	jreq	L142
 758                     ; 211 					away_one = 0;
 760  0209 3f03          	clr	_away_one
 761                     ; 212 					away_ten = 0;
 763  020b 3f02          	clr	_away_ten
 764  020d               L142:
 765                     ; 214 				state = SCORE;
 767  020d 35020008      	mov	_state,#2
 768                     ; 215 			break;
 770  0211 ac2b032b      	jpf	L132
 771  0215               L371:
 772                     ; 217 			case 'A':	// vööraste punktid
 772                     ; 218 				data  = readCharacter(1);
 774  0215 a601          	ld	a,#1
 775  0217 cd0000        	call	_readCharacter
 777  021a b705          	ld	_data,a
 778                     ; 219 				if (data >= '0' && data <= '9')
 780  021c b605          	ld	a,_data
 781  021e a130          	cp	a,#48
 782  0220 2403          	jruge	L04
 783  0222 cc032b        	jp	L132
 784  0225               L04:
 786  0225 b605          	ld	a,_data
 787  0227 a13a          	cp	a,#58
 788  0229 2503          	jrult	L24
 789  022b cc032b        	jp	L132
 790  022e               L24:
 791                     ; 221 					away_ten = data & 0x0F;
 793  022e b605          	ld	a,_data
 794  0230 a40f          	and	a,#15
 795  0232 b702          	ld	_away_ten,a
 797                     ; 225 				data  = readCharacter(1);
 799  0234 a601          	ld	a,#1
 800  0236 cd0000        	call	_readCharacter
 802  0239 b705          	ld	_data,a
 803                     ; 226 				if (data >= '0' && data <= '9')
 805  023b b605          	ld	a,_data
 806  023d a130          	cp	a,#48
 807  023f 250c          	jrult	L742
 809  0241 b605          	ld	a,_data
 810  0243 a13a          	cp	a,#58
 811  0245 2406          	jruge	L742
 812                     ; 228 					away_one = data & 0x0F;
 814  0247 b605          	ld	a,_data
 815  0249 a40f          	and	a,#15
 816  024b b703          	ld	_away_one,a
 817  024d               L742:
 818                     ; 230 				if (state!=SCORE)
 820  024d b608          	ld	a,_state
 821  024f a102          	cp	a,#2
 822  0251 2704          	jreq	L152
 823                     ; 232 					home_one = 0;
 825  0253 3f01          	clr	_home_one
 826                     ; 233 					home_ten = 0;
 828  0255 3f00          	clr	_home_ten
 829  0257               L152:
 830                     ; 235 				state = SCORE;
 832  0257 35020008      	mov	_state,#2
 833                     ; 236 			break;
 835  025b ac2b032b      	jpf	L132
 836  025f               L571:
 837                     ; 238 			case 'C': // temperatuur
 837                     ; 239 			state = TEMP;
 839  025f 35010008      	mov	_state,#1
 840                     ; 241 			break;
 842  0263 ac2b032b      	jpf	L132
 843  0267               L771:
 844                     ; 243 			case 'T': // kell
 844                     ; 244 				data  = readCharacter(1);
 846  0267 a601          	ld	a,#1
 847  0269 cd0000        	call	_readCharacter
 849  026c b705          	ld	_data,a
 850                     ; 245 				if (data >= '0' && data <= '2')
 852  026e b605          	ld	a,_data
 853  0270 a130          	cp	a,#48
 854  0272 2403          	jruge	L44
 855  0274 cc032b        	jp	L132
 856  0277               L44:
 858  0277 b605          	ld	a,_data
 859  0279 a133          	cp	a,#51
 860  027b 2503          	jrult	L64
 861  027d cc032b        	jp	L132
 862  0280               L64:
 863                     ; 247 					home = (data & 0x0F)*10;
 865  0280 b605          	ld	a,_data
 866  0282 a40f          	and	a,#15
 867  0284 97            	ld	xl,a
 868  0285 a60a          	ld	a,#10
 869  0287 42            	mul	x,a
 870  0288 9f            	ld	a,xl
 871  0289 b706          	ld	_home,a
 873                     ; 252 				data  = readCharacter(1);
 875  028b a601          	ld	a,#1
 876  028d cd0000        	call	_readCharacter
 878  0290 b705          	ld	_data,a
 879                     ; 253 				if (data >= '0' && data <= '9')
 881  0292 b605          	ld	a,_data
 882  0294 a130          	cp	a,#48
 883  0296 2403          	jruge	L05
 884  0298 cc032b        	jp	L132
 885  029b               L05:
 887  029b b605          	ld	a,_data
 888  029d a13a          	cp	a,#58
 889  029f 2503          	jrult	L25
 890  02a1 cc032b        	jp	L132
 891  02a4               L25:
 892                     ; 255 					home += (data & 0x0F);
 894  02a4 b605          	ld	a,_data
 895  02a6 a40f          	and	a,#15
 896  02a8 bb06          	add	a,_home
 897  02aa b706          	ld	_home,a
 899                     ; 260 				data  = readCharacter(1);
 901  02ac a601          	ld	a,#1
 902  02ae cd0000        	call	_readCharacter
 904  02b1 b705          	ld	_data,a
 905                     ; 261 				if (data >= '0' && data <= '5')
 907  02b3 b605          	ld	a,_data
 908  02b5 a130          	cp	a,#48
 909  02b7 2572          	jrult	L132
 911  02b9 b605          	ld	a,_data
 912  02bb a136          	cp	a,#54
 913  02bd 246c          	jruge	L132
 914                     ; 263 					away = (data & 0x0F)*10;
 916  02bf b605          	ld	a,_data
 917  02c1 a40f          	and	a,#15
 918  02c3 97            	ld	xl,a
 919  02c4 a60a          	ld	a,#10
 920  02c6 42            	mul	x,a
 921  02c7 9f            	ld	a,xl
 922  02c8 b707          	ld	_away,a
 924                     ; 268 				data  = readCharacter(1);
 926  02ca a601          	ld	a,#1
 927  02cc cd0000        	call	_readCharacter
 929  02cf b705          	ld	_data,a
 930                     ; 269 				if (data >= '0' && data <= '9')
 932  02d1 b605          	ld	a,_data
 933  02d3 a130          	cp	a,#48
 934  02d5 2554          	jrult	L132
 936  02d7 b605          	ld	a,_data
 937  02d9 a13a          	cp	a,#58
 938  02db 244e          	jruge	L132
 939                     ; 271 					away += (data & 0x0F);
 941  02dd b605          	ld	a,_data
 942  02df a40f          	and	a,#15
 943  02e1 bb07          	add	a,_away
 944  02e3 b707          	ld	_away,a
 946                     ; 275 				home_one = home % 10 & 0x0F;
 948  02e5 b606          	ld	a,_home
 949  02e7 5f            	clrw	x
 950  02e8 97            	ld	xl,a
 951  02e9 a60a          	ld	a,#10
 952  02eb 62            	div	x,a
 953  02ec 5f            	clrw	x
 954  02ed 97            	ld	xl,a
 955  02ee 9f            	ld	a,xl
 956  02ef a40f          	and	a,#15
 957  02f1 b701          	ld	_home_one,a
 958                     ; 276 				home_ten = (home/10)%10 & 0x0F;
 960  02f3 b606          	ld	a,_home
 961  02f5 5f            	clrw	x
 962  02f6 97            	ld	xl,a
 963  02f7 a60a          	ld	a,#10
 964  02f9 cd0000        	call	c_sdivx
 966  02fc a60a          	ld	a,#10
 967  02fe cd0000        	call	c_smodx
 969  0301 01            	rrwa	x,a
 970  0302 a40f          	and	a,#15
 971  0304 5f            	clrw	x
 972  0305 b700          	ld	_home_ten,a
 973                     ; 277 				away_one = away %10 & 0x0F;
 975  0307 b607          	ld	a,_away
 976  0309 5f            	clrw	x
 977  030a 97            	ld	xl,a
 978  030b a60a          	ld	a,#10
 979  030d 62            	div	x,a
 980  030e 5f            	clrw	x
 981  030f 97            	ld	xl,a
 982  0310 9f            	ld	a,xl
 983  0311 a40f          	and	a,#15
 984  0313 b703          	ld	_away_one,a
 985                     ; 278 				away_ten = (away/10)%10 & 0x0F;
 987  0315 b607          	ld	a,_away
 988  0317 5f            	clrw	x
 989  0318 97            	ld	xl,a
 990  0319 a60a          	ld	a,#10
 991  031b cd0000        	call	c_sdivx
 993  031e a60a          	ld	a,#10
 994  0320 cd0000        	call	c_smodx
 996  0323 01            	rrwa	x,a
 997  0324 a40f          	and	a,#15
 998  0326 5f            	clrw	x
 999  0327 b702          	ld	_away_ten,a
1000                     ; 279 				state = CLOCK;
1002  0329 3f08          	clr	_state
1003                     ; 280 			break;
1005  032b               L102:
1006                     ; 282 			default:
1006                     ; 283 			
1006                     ; 284 			break;
1008  032b               L132:
1009                     ; 287 			if (second)
1011  032b 3d04          	tnz	_second
1012  032d 2603          	jrne	L45
1013  032f cc01a9        	jp	L322
1014  0332               L45:
1015                     ; 289 				second = 0;
1017  0332 3f04          	clr	_second
1018                     ; 291 			switch(state)
1020  0334 b608          	ld	a,_state
1022                     ; 305 			default:
1022                     ; 306 			break;
1023  0336 4d            	tnz	a
1024  0337 2711          	jreq	L702
1025  0339 4a            	dec	a
1026  033a 2703          	jreq	L65
1027  033c cc01a9        	jp	L322
1028  033f               L65:
1029                     ; 293 			case TEMP:
1029                     ; 294 				show_temp();
1031  033f cd002e        	call	_show_temp
1033                     ; 295 			break;
1035  0342 aca901a9      	jpf	L322
1036  0346               L502:
1037                     ; 297 			case SCORE:
1037                     ; 298 			
1037                     ; 299 			break;
1039  0346 aca901a9      	jpf	L322
1040  034a               L702:
1041                     ; 301 			case CLOCK:
1041                     ; 302 				calc_time();
1043  034a cd00dd        	call	_calc_time
1045                     ; 303 			break;
1047  034d aca901a9      	jpf	L322
1048  0351               L112:
1049                     ; 305 			default:
1049                     ; 306 			break;
1051  0351 aca901a9      	jpf	L322
1052  0355               L772:
1053  0355 aca901a9      	jpf	L322
1056                     	bsct
1057  000a               L103_counter:
1058  000a 00            	dc.b	0
1059  000b               L303_i:
1060  000b 00            	dc.b	0
1108                     ; 324 INTERRUPT void TIM1_IRQHandler(void)
1108                     ; 325 {
1110                     	switch	.text
1111  0359               f_TIM1_IRQHandler:
1113  0359 8a            	push	cc
1114  035a 84            	pop	a
1115  035b a4bf          	and	a,#191
1116  035d 88            	push	a
1117  035e 86            	pop	cc
1118  035f 3b0002        	push	c_x+2
1119  0362 be00          	ldw	x,c_x
1120  0364 89            	pushw	x
1121  0365 3b0002        	push	c_y+2
1122  0368 be00          	ldw	x,c_y
1123  036a 89            	pushw	x
1126                     ; 328 	TIM1->SR1 &= ~TIM1_SR1_UIF;
1128  036b 72115255      	bres	21077,#0
1129                     ; 330 	counter++;
1131  036f 3c0a          	inc	L103_counter
1132                     ; 331 	if (counter >= 250) //FIXME: 250
1134  0371 b60a          	ld	a,L103_counter
1135  0373 a1fa          	cp	a,#250
1136  0375 2506          	jrult	L723
1137                     ; 333 		counter = 0;
1139  0377 3f0a          	clr	L103_counter
1140                     ; 334 		second = 1;
1142  0379 35010004      	mov	_second,#1
1143  037d               L723:
1144                     ; 337 	if (i == 0)
1146  037d 3d0b          	tnz	L303_i
1147  037f 2618          	jrne	L133
1148                     ; 339 		COM_ODR |= AWAY10 | AWAY1| HOME10 | HOME1; //orid maskid kokku
1150  0381 c65005        	ld	a,20485
1151  0384 aa1e          	or	a,#30
1152  0386 c75005        	ld	20485,a
1153                     ; 340 		SEG_ODR = tabel[home_ten];
1155  0389 b600          	ld	a,_home_ten
1156  038b 5f            	clrw	x
1157  038c 97            	ld	xl,a
1158  038d d60000        	ld	a,(_tabel,x)
1159  0390 c7500a        	ld	20490,a
1160                     ; 341 		COM_ODR &= ~HOME10; //inverteerib home10 maski
1162  0393 72155005      	bres	20485,#2
1164  0397 205e          	jra	L333
1165  0399               L133:
1166                     ; 343 	else if (i == 1)
1168  0399 b60b          	ld	a,L303_i
1169  039b a101          	cp	a,#1
1170  039d 2618          	jrne	L533
1171                     ; 345 		COM_ODR |= AWAY10 | AWAY1| HOME10 | HOME1; //orid maskid kokku
1173  039f c65005        	ld	a,20485
1174  03a2 aa1e          	or	a,#30
1175  03a4 c75005        	ld	20485,a
1176                     ; 346 		SEG_ODR = tabel[home_one];
1178  03a7 b601          	ld	a,_home_one
1179  03a9 5f            	clrw	x
1180  03aa 97            	ld	xl,a
1181  03ab d60000        	ld	a,(_tabel,x)
1182  03ae c7500a        	ld	20490,a
1183                     ; 347 		COM_ODR &= ~HOME1; //inverteerib home01 maski
1185  03b1 72135005      	bres	20485,#1
1187  03b5 2040          	jra	L333
1188  03b7               L533:
1189                     ; 349 	else if (i == 2)
1191  03b7 b60b          	ld	a,L303_i
1192  03b9 a102          	cp	a,#2
1193  03bb 2618          	jrne	L143
1194                     ; 352 		COM_ODR |= AWAY10 | AWAY1| HOME10 | HOME1; //orid maskid kokku
1196  03bd c65005        	ld	a,20485
1197  03c0 aa1e          	or	a,#30
1198  03c2 c75005        	ld	20485,a
1199                     ; 353 		SEG_ODR = tabel[away_ten];
1201  03c5 b602          	ld	a,_away_ten
1202  03c7 5f            	clrw	x
1203  03c8 97            	ld	xl,a
1204  03c9 d60000        	ld	a,(_tabel,x)
1205  03cc c7500a        	ld	20490,a
1206                     ; 354 		COM_ODR &= ~AWAY10; //inverteerib away10 maski
1208  03cf 72195005      	bres	20485,#4
1210  03d3 2022          	jra	L333
1211  03d5               L143:
1212                     ; 356 	else if (i == 3)
1214  03d5 b60b          	ld	a,L303_i
1215  03d7 a103          	cp	a,#3
1216  03d9 261c          	jrne	L333
1217                     ; 358 		COM_ODR |= AWAY10 | AWAY1| HOME10 | HOME1; //orid maskid kokku
1219  03db c65005        	ld	a,20485
1220  03de aa1e          	or	a,#30
1221  03e0 c75005        	ld	20485,a
1222                     ; 359 		delay(5);
1224  03e3 ae0005        	ldw	x,#5
1225  03e6 cd001c        	call	_delay
1227                     ; 360 		SEG_ODR = tabel[away_one];
1229  03e9 b603          	ld	a,_away_one
1230  03eb 5f            	clrw	x
1231  03ec 97            	ld	xl,a
1232  03ed d60000        	ld	a,(_tabel,x)
1233  03f0 c7500a        	ld	20490,a
1234                     ; 361 		COM_ODR &= ~AWAY1; //inverteerib away01 maski
1236  03f3 72175005      	bres	20485,#3
1237  03f7               L333:
1238                     ; 364 	i++;
1240  03f7 3c0b          	inc	L303_i
1241                     ; 365 	if (i > 3)
1243  03f9 b60b          	ld	a,L303_i
1244  03fb a104          	cp	a,#4
1245  03fd 2502          	jrult	L743
1246                     ; 367 		i=0;
1248  03ff 3f0b          	clr	L303_i
1249  0401               L743:
1250                     ; 370 }
1253  0401 85            	popw	x
1254  0402 bf00          	ldw	c_y,x
1255  0404 320002        	pop	c_y+2
1256  0407 85            	popw	x
1257  0408 bf00          	ldw	c_x,x
1258  040a 320002        	pop	c_x+2
1259  040d 80            	iret
1442                     	xdef	f_TIM1_IRQHandler
1443                     	xdef	_main
1444                     	xdef	_init
1445                     	xdef	_calc_time
1446                     	xdef	_show_temp
1447                     	xdef	_delay
1448                     	xdef	_tabel
1449                     	xdef	_readCharacter
1450                     	switch	.ubsct
1451  0000               _temp:
1452  0000 00000000      	ds.b	4
1453                     	xdef	_temp
1454  0004               _summa:
1455  0004 0000          	ds.b	2
1456                     	xdef	_summa
1457  0006               _taimer:
1458  0006 00            	ds.b	1
1459                     	xdef	_taimer
1460  0007               _tulemus:
1461  0007 0000          	ds.b	2
1462                     	xdef	_tulemus
1463                     	xdef	_state
1464                     	xdef	_away
1465                     	xdef	_home
1466                     	xdef	_data
1467                     	xdef	_second
1468                     	xdef	_away_one
1469                     	xdef	_away_ten
1470                     	xdef	_home_one
1471                     	xdef	_home_ten
1472                     	xref.b	c_lreg
1473                     	xref.b	c_x
1474                     	xref.b	c_y
1494                     	xref	c_smodx
1495                     	xref	c_sdivx
1496                     	xref	c_lmod
1497                     	xref	c_ldiv
1498                     	xref	c_ltor
1499                     	xref	c_lgadd
1500                     	xref	c_rtol
1501                     	xref	c_lmul
1502                     	xref	c_uitolx
1503                     	end
