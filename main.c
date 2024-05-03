#include "stm8s.h"

// numbrikohtade defineerimine
#define HOME10 (1 << 2)
#define HOME1 (1 << 1)
#define AWAY10 (1 << 4)
#define AWAY1 (1 << 3)

// IO pordi seadistamine numbrid/segmendid
#define COM_ODR GPIOB->ODR
#define SEG_ODR GPIOC->ODR

// segmentide defineerimine
#define SEGA_MASK (1 << 1)
#define SEGB_MASK (1 << 2)
#define SEGC_MASK (1 << 3)
#define SEGD_MASK (1 << 4)
#define SEGE_MASK (1 << 5)
#define SEGF_MASK (1 << 6)
#define SEGG_MASK (1 << 7)

// numbrite kuvamiseks muutujad
volatile uint8_t home_ten = 0;	//volatile ei lase kompilaatoril muutujat välja optimeerida!!!
volatile uint8_t home_one = 0;
volatile uint8_t away_ten = 0;
volatile uint8_t away_one = 0;
volatile uint8_t second = 0;
uint8_t data = 0;
volatile uint8_t home = 0;
volatile uint8_t away = 0;
static uint8_t secCounter = 0;

enum 
{
	CLOCK,
	TEMP,
	SCORE,
	TIMER,
	STOPPER
}state = TEMP;	// oleku muutuja

// temperatuuri arvutuse jaoks muutujad
uint16_t tulemus;
uint8_t taimer;
uint16_t summa;
int32_t temp;

// uardist tähemärgi lugemine
uint8_t readCharacter(uint8_t block)	// loe uardist tähemärk
{
	if (block == 0)
	{
		if(UART1->SR & UART1_SR_RXNE) return UART1->DR; // ootan kuni bait saabub
		else return 0xFF;
	}
	else
	{
		while (!(UART1->SR & UART1_SR_RXNE));
		return UART1->DR;
	}
}

// kuvatatavate tähemärkide jada
const uint8_t tabel[]=
{
  0x7E, // 0
  0x0C, // 1
  0xB6, // 2
  0x9E, // 3
  0xCC, // 4
  0xDA, // 5
  0xFA, // 6
  0x0E, // 7
  0xFE, // 8
  0xDE, // 9
  0xC6, // ¤
  0x72  // C
};

void delay(uint16_t d)	// viite funktsioon
{
	while(d--);
}

void show_temp(void)	// näita temperatuuri funktsioon
{
	uint8_t i;
	summa = 0;
	
	for(i=0; i<64; i++)
	{
		 //test = !test;
		 taimer=200;
		 while(taimer--);
		 //ADC_CR1_bit.ADON=1;  // k?ivitab adc
		 ADC1->CR1 |= ADC1_CR1_ADON;
		 while (((ADC1->CSR)&(1<<7))==0);//(ADC_CSR_bit.EOC==0);
		 //tulemus=ADC1->DRH<<2;  //nihutab 2 kohta vasemale /ADC1 data high
		 //tulemus+=ADC1->DRL;    //liidab alumised 2 bitti /ADC1 Data low
		 tulemus = ADC1->DRL;
		 tulemus |= ADC1->DRH<<8;
		 summa+=tulemus;
	}
	tulemus=summa/64;
	// temp arvutamine trendline järgi
	temp = ((int32_t)(tulemus)) * (-1028);
	temp += 784420;
	temp = temp/10000;			
	home_one = (uint8_t)(temp % 10);
	temp /= 10;
	home_ten = (uint8_t)(temp);
	away_ten = 10;
	away_one = 11;
}

void calc_time(void) // kellaaja uuendamine
{
	secCounter++;
	if(secCounter < 60) return;
	secCounter = 0;
	
	away += 1;
	if (away >= 60)
	{
		home += 1;
		away = 0;
	}
	if (home >= 24)
	{
		home = 0;
	}
	
	home_one = home % 10 & 0x0F;
	home_ten = (home/10)%10 & 0x0F;
	away_one = away %10 & 0x0F;
	away_ten = (away/10)%10 & 0x0F;
	
}

void init(void)	// perifeeria seadistamine
{
	GPIOB->ODR = 0x1E;
	GPIOB->DDR = 0x1E;
	GPIOB->CR1 = 0x1E;
	
	GPIOC->ODR = 0x00;
	GPIOC->DDR = 0xFE;
	GPIOC->CR1 = 0xFE;
	
  UART1->BRR2 = 0x01;     // uart baud rate esimene ja viimane  BRR2 esimesena!!!!!
  UART1->BRR1 = 0x01;     // uart baud rate 2MHZ / 115200 = 17 (keskmised 2)
  UART1->CR2 |= UART1_CR2_TEN;     // uardi saatmine lubatud
  UART1->CR2 |= UART1_CR2_REN;     // uardi vastuvõtmine sees
  
  ADC1->CSR=0x00;         // adc kanal 0
  ADC1->CR1=0x01;         // 0x kiirus, ad sisse
  ADC1->CR2=0x00;         // Left alignment
  ADC1->TDRL=0x10;        // AIN0 sisendbuffer v?lja
  
	COM_ODR &= ~HOME10;
	  // timer settings -> numbrite multipleksimine
	#if 1
  TIM1->ARRH = 0;			// #define TIM1_ARRH_ARR    ((uint8_t)0xFF) /*!< Autoreload Value (MSB) mask. */ #define TIM1_ARRH_RESET_VALUE  ((uint8_t)0xFF)
  TIM1->ARRL = 0x03;		// #define TIM1_ARRL_ARR    ((uint8_t)0xFF) /*!< Autoreload Value (LSB) mask. */ #define TIM1_ARRL_RESET_VALUE  ((uint8_t)0xFF)

  TIM1->PSCRH = 0x07 ;	// #define TIM1_PSCH_PSC    ((uint8_t)0xFF) /*!< Prescaler Value (MSB) mask. */ #define TIM1_PSCRH_RESET_VALUE ((uint8_t)0x00
	TIM1->PSCRL = 0xD0;	// #define TIM1_PSCL_PSC    ((uint8_t)0xFF) /*!< Prescaler Value (LSB) mask. */ #define TIM1_PSCRL_RESET_VALUE ((uint8_t)0x00)
  TIM1->CR1 |= TIM1_CR1_CEN;		// #define TIM1_CR1_CEN     ((uint8_t)0x01) /*!< Counter Enable mask. */
	TIM1->IER |= TIM1_IER_UIE;
	enableInterrupts();
	#endif
	
	// ad muunduri seadistamine temp mõõtmise jaoks
	ADC1->CSR = 0x00;	//control status register 
	//ADC_CSR=0x00;         // adc kanal 0
  ADC1->CR1=0x01;         // 0x kiirus, ad sisse / conf register 1
  ADC1->CR2=0x08;         // Left alignment / conf register 2
  ADC1->TDRL=0x01;        // AIN0 sisendbuffer v?lja / ADC Schmitt trigger disable register low
}

// peaprogramm
int main( void )
{
	// IOde seadistamine
	init();
	
	// kordustsükkel
  while (1)
  {
		
		data = readCharacter(0);
		
		switch(data)
		{
			case 'H':	// omade punktid
				data  = readCharacter(1);
				if (data >= '0' && data <= '9')
				{
					home_ten = data & 0x0F;
				}
				else break;
				
				data  = readCharacter(1);
				if (data >= '0' && data <= '9')
				{
					home_one = data & 0x0F;
				}
				if (state!=SCORE)
				{
					away_one = 0;
					away_ten = 0;
				}
				state = SCORE;
			break;
			
			case 'A':	// vööraste punktid
				data  = readCharacter(1);
				if (data >= '0' && data <= '9')
				{
					away_ten = data & 0x0F;
				}
				else break;
				
				data  = readCharacter(1);
				if (data >= '0' && data <= '9')
				{
					away_one = data & 0x0F;
				}
				if (state!=SCORE)
				{
					home_one = 0;
					home_ten = 0;
				}
				state = SCORE;
			break;
			
			case 'C': // temperatuur
			state = TEMP;
				
			break;
			
			case 'T': // kell
				data  = readCharacter(1);
				if (data >= '0' && data <= '2')
				{
					home = (data & 0x0F)*10;
					//home_ten = data & 0x0F;
				}
				else break;
				
				data  = readCharacter(1);
				if (data >= '0' && data <= '9')
				{
					home += (data & 0x0F);
					//home_one = data & 0x0F;
				}
				else break;
				
				data  = readCharacter(1);
				if (data >= '0' && data <= '5')
				{
					away = (data & 0x0F)*10;
					//away_ten = data & 0x0F;
				}
				else break;
				
				data  = readCharacter(1);
				if (data >= '0' && data <= '9')
				{
					away += (data & 0x0F);
					//away_one = data & 0x0F;
				}
				else break;
				
				data  = readCharacter(1);
				if (data >= '0' && data <= '9'){
					secCounter = 10 * (data & 0x0F);
				}
				else break;
				
				data  = readCharacter(1);
				if (data >= '0' && data <= '9'){
					secCounter += (data & 0x0F);
				}
				else break;
				
				home_one = home % 10 & 0x0F;
				home_ten = (home/10)%10 & 0x0F;
				away_one = away %10 & 0x0F;
				away_ten = (away/10)%10 & 0x0F;
				state = CLOCK;
			break;
			
			default:
			
			break;
			
		}
			if (second)
		{
				second = 0;
			
			switch(state)
		{
			case TEMP:
				show_temp();
			break;
			
			case SCORE:
			
			break;
			
			case CLOCK:
				calc_time();
			break;
			
			default:
			break;
		}
		}
			
		
   // Pritsi kood siia:
    //bt puhvri lugemini kuni LFini
    //esimese sümboli lugemine ja vastava programmijupi täitmine
    //numbri kuvamine ekraanile
    //temperatuuri arvutamine
    //punktide arvutamine/nullimine home/away
    //kella näitamine ja muutmine
    //stopper start/stop/reset
    //taimeri aja saatmine, start/stop/reset
  }
}

// taimeri katkestuste korral tegevused
INTERRUPT void TIM1_IRQHandler(void)
{
	static uint8_t counter = 0;
	static uint8_t i = 0;
	TIM1->SR1 &= ~TIM1_SR1_UIF;
	
	counter++;
	if (counter >= 250) //FIXME: 250
	{
		counter = 0;
		second = 1;
	}
	//COM_ODR ^= HOME10;
	if (i == 0)
	{
		COM_ODR |= AWAY10 | AWAY1| HOME10 | HOME1; //orid maskid kokku
		SEG_ODR = tabel[home_ten];
		COM_ODR &= ~HOME10; //inverteerib home10 maski
	}
	else if (i == 1)
	{
		COM_ODR |= AWAY10 | AWAY1| HOME10 | HOME1; //orid maskid kokku
		SEG_ODR = tabel[home_one];
		COM_ODR &= ~HOME1; //inverteerib home01 maski
	}
	else if (i == 2)
	{
		
		COM_ODR |= AWAY10 | AWAY1| HOME10 | HOME1; //orid maskid kokku
		SEG_ODR = tabel[away_ten];
		COM_ODR &= ~AWAY10; //inverteerib away10 maski
	}
	else if (i == 3)
	{
		COM_ODR |= AWAY10 | AWAY1| HOME10 | HOME1; //orid maskid kokku
		delay(5);
		SEG_ODR = tabel[away_one];
		COM_ODR &= ~AWAY1; //inverteerib away01 maski
	}
	
	i++;
	if (i > 3)
	{
		i=0;
	}
	
}
