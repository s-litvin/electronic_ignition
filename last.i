
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb OCDR=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);
int printf(char flash *fmtstr,...);
int sprintf(char *str, char flash *fmtstr,...);
int vprintf(char flash * fmtstr, va_list argptr);
int vsprintf(char *str, char flash * fmtstr, va_list argptr);

char *gets(char *str,unsigned int len);
int snprintf(char *str, unsigned int size, char flash *fmtstr,...);
int vsnprintf(char *str, unsigned int size, char flash * fmtstr, va_list argptr);

int scanf(char flash *fmtstr,...);
int sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

#pragma used+
unsigned char w1_init(void);
unsigned char w1_read(void);
unsigned char w1_write(unsigned char data);
unsigned char w1_search(unsigned char cmd,void *p);
unsigned char w1_dow_crc8(void *p,unsigned char n);
#pragma used-

#pragma used+
extern struct __ds18b20_scratch_pad_struct
{
unsigned char temp_lsb,temp_msb;
signed char   temp_high,temp_low;
unsigned char conf_register,
res1,
res2,
res3,
crc;
} __ds18b20_scratch_pad;

unsigned char ds18b20_select(unsigned char *addr);
unsigned char ds18b20_read_spd(unsigned char *addr);
float ds18b20_temperature(unsigned char *addr);
unsigned char ds18b20_init(unsigned char *addr,signed char temp_low,signed char temp_high,
unsigned char resolution);
#pragma used-

#pragma library ds18b20.lib

void _lcd_write_data(unsigned char data);

unsigned char lcd_read_byte(unsigned char addr);

void lcd_write_byte(unsigned char addr, unsigned char data);

void lcd_gotoxy(unsigned char x, unsigned char y);

void lcd_clear(void);
void lcd_putchar(char c);

void lcd_puts(char *str);

void lcd_putsf(char flash *str);

void lcd_putse(char eeprom *str);

void lcd_init(unsigned char lcd_columns);

#pragma library alcd.lib

unsigned char devices;
unsigned char RomCode[2][9];

char buffer[16];
int oper=0,yes=0,oboroty=0,ob_y=0,uoz_i=0,zn1=0,zn2=0,sek=2,ob_min=0,temp1,temp2,temp_buf,i=0,kk=7;
int temp_ugly[15]={480,480,480,480,480,480,480,480,480,480,480,480,480,480,480};

eeprom int temp_f,f,percent[4][8],prer_ugly[8]; 

interrupt [10] void timer0_ovf_isr(void)
{

TCNT0=0x05;   

zn1=zn2;             
zn2=PINA.6;          

if(zn1==zn2)

if(zn2==1) 
if(yes<(prer_ugly[7]+prer_ugly[7])) yes++;
else PORTD.3=0;                                 
else 
if(yes>0) yes--;
else PORTD.3=0;        

else

if(yes==0) {PORTD.3=1; ob_min++;}   
else
{   

if(yes>prer_ugly[3])                   
if(yes>prer_ugly[5])
if(yes>prer_ugly[6]) kk=7;
else kk=6;
else 
if(yes>prer_ugly[4]) kk=5;
else kk=4;       
else 
if(yes>prer_ugly[1])
if(yes>prer_ugly[2]) kk=3;
else kk=2;
else 
if(yes>prer_ugly[0]) kk=1;
else kk=0;      

ob_y=yes;        
oper=yes-((yes*percent[f][kk])/100);
yes=oper;            
}          

}

interrupt [9] void timer1_ovf_isr(void)
{
TCNT1=34000;   
sek++;   
}

interrupt [7] void timer1_compa_isr(void)
{                 
}

interrupt [8] void timer1_compb_isr(void)
{
}  

void menu1(void)
{
lcd_clear(); 
sprintf(buffer,"  %dx",uoz_i); 
lcd_puts(buffer);
sprintf(buffer,"%d",percent[f][7-uoz_i]);
lcd_puts(buffer);
lcd_puts("\x25");   
lcd_gotoxy(0,1);        
lcd_puts("<2 3> 4\x7E");  

}

void menu2(void)
{       lcd_gotoxy(0,0);

sprintf(buffer,"\xA5\xB7\xBC. %d",percent[f][7-uoz_i]);
lcd_puts(buffer);
lcd_puts("\x25 ");   
lcd_gotoxy(0,1);        
lcd_puts("< 2  3 >");   
delay_ms(20);

}

void menu_temp(void)
{

lcd_puts("   \xF7    ");

if (temp1>1000)                   
temp1=(-1)*(4096-temp1);        

sprintf(buffer,"%d\x27",temp1);  
lcd_puts(buffer);

if (temp2>1000)                   
temp2=(-1)*(4096-temp2);        

lcd_gotoxy(5,1);
sprintf(buffer,"%d\x27",temp2);  
lcd_puts(buffer);

delay_ms(1000);

}

void default_set (void)
{

prer_ugly[0]=60;
prer_ugly[1]=69;
prer_ugly[2]=80;
prer_ugly[3]=96;
prer_ugly[4]=120;
prer_ugly[5]=160;
prer_ugly[6]=240;
prer_ugly[7]=480;

percent[0][0]=98;  percent[1][0]=62;  percent[2][0]=58;   percent[3][0]=68;   
percent[0][1]=98;  percent[1][1]=60;  percent[2][1]=57;   percent[3][1]=68;   
percent[0][2]=98;  percent[1][2]=59;  percent[2][2]=54;   percent[3][2]=65;   
percent[0][3]=98;  percent[1][3]=55;  percent[2][3]=52;   percent[3][3]=54;   
percent[0][4]=98;  percent[1][4]=50;  percent[2][4]=49;   percent[3][4]=49;   
percent[0][5]=98;  percent[1][5]=19;  percent[2][5]=48;   percent[3][5]=48;   
percent[0][6]=98;  percent[1][6]=5;   percent[2][6]=18;   percent[3][6]=18;   
percent[0][7]=0;   percent[1][7]=0;   percent[2][7]=0;    percent[3][7]=0;    

f=0;
temp_f=4;                                    
}

void main(void)
{

PORTA=0xff;
DDRA=0x00;             

PORTB=0x00;
DDRB=0xFF;             

PORTC=0x00;
DDRC=0xFF;

PORTD=0b10110111;
DDRD=0b11001000;  

TCCR0=0x01;
TCNT0=0x05;
OCR0=0x00;

TCCR1A=0x00;
TCCR1B=0x04;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;
MCUCSR=0x00;

TIMSK=0x1D;

ACSR=0x80;
SFIOR=0x00;

lcd_init(8);             
lcd_clear();

for(i=0;i<8;i++)
{ 
lcd_gotoxy(i,0); 
lcd_putsf("\xFF");
lcd_gotoxy(i,1);
lcd_putsf("\xFF");
delay_ms(40);
}

lcd_clear();

devices=w1_search(0xf0, RomCode); 

if(devices)
{   

lcd_gotoxy(0,0);
sprintf(buffer,"device=%u", devices); 
lcd_puts(buffer);
lcd_gotoxy( 0,1 ); 
lcd_puts("reading");
delay_ms(300);

ds18b20_init(&RomCode[0][0], 50, 140, 0  ); 
ds18b20_init(&RomCode[1][0], 50, 140, 0  ); 
lcd_clear();  
temp1=ds18b20_temperature(&RomCode[0][0]);
temp2=ds18b20_temperature(&RomCode[1][0]);
menu_temp(); 
delay_ms(1500); 
lcd_clear();

}

else{ lcd_gotoxy(0,0); lcd_puts("\x48\x65\xBF \xBF\x65\xBC\xBE\xE3\x61\xBF\xC0\xB8\xBA\x6F\xB3"); delay_ms(1500);}

#asm("sei")       
TCNT1=0; 
sek=0;

lcd_puts("s_lit \x40  ukr.net");
delay_ms(500);
if(PINA.0==0)
{ 
lcd_clear();
delay_ms(700);

default_set();
i=0;

f=f+temp_f;
temp_f=f-temp_f;
f=f-temp_f;

lcd_clear(); lcd_puts("\xA4\x61\xB3\x65\xE3\xB8     \xB2\x61\xB9\xBA"); delay_ms(3000);

sek=0;

while(oboroty<800)
{
if(sek==1)
{
sek=0;
oboroty=ob_min*60;
ob_min=0;
}
} 

lcd_clear(); lcd_puts("\x48\x61\xB2\x65\x70\xB8  1000\x6F\xB2\x2F\xBC"); delay_ms(3000);
lcd_clear();
sek=0;
ob_min=0;

while(i<14)  
{         

if(sek==1)
{    
sek=0;
oboroty=ob_min*60;
ob_min=0; 

if((oboroty>940)&&(oboroty<1060)) {temp_ugly[i]=ob_y; i++;}
else i=0;

lcd_gotoxy(0,0);
sprintf(buffer,"     :%d   ",15-i);  
lcd_puts(buffer);
lcd_gotoxy(0,1);
sprintf(buffer,"%d      ",oboroty);  
lcd_puts(buffer);
delay_ms(100);
}

} 

lcd_clear(); 

for(i=0;i<14;i++)
temp_buf=temp_buf+temp_ugly[i];

temp_buf=temp_buf/15;

sprintf(buffer,"AVR:%d",temp_buf);  
lcd_puts(buffer); 

delay_ms(3000);

f=f+temp_f;
temp_f=f-temp_f;
f=f-temp_f;
} 

while (1)
{ 

if(PINA.0==0)             
{  
delay_ms(50);

lcd_clear();     

while(PINA.0==0)
{ 
if((sek>4)&&(oboroty<1100)) 
{
f=f+temp_f;
temp_f=f-temp_f;
f=f-temp_f;

if(f<4)

lcd_puts("\xAA\xA9\x4F\xA4         \x42\xBA\xBB"); 
else

lcd_puts("\xAA\xA9\x4F\xA4        \x42\xC3\xBA\xBB");
delay_ms(700);
lcd_clear();} 
}  

if((sek<3)&&(oboroty<1400)) menu_temp(); 

ob_min=0;
sek=0;
} 

if(PINA.1==0)             
{  
delay_ms(100);
if(oboroty==0)
{ 
#asm("cli");
lcd_clear();

lcd_puts("\xA8\x70\x6F\xB4\x70\x65\xB3 \x63\xB3\x65\xC0\x65\xB9..");
for(i=0;i<50;i++)
{
PORTD.3=1;         
delay_ms(25);
PORTD.3=0;         
delay_ms(7);   
} 
lcd_clear();

lcd_puts(" \xA1\x6F\xBF\x6F\xB3\x6F"); 
delay_ms(250);
#asm("sei");
}

else
{ 
lcd_clear();

lcd_puts("\x43\xBD\x61\xC0\x61\xBB\x61  \xB7\x61\xB4\xBB\x79\xC1\xB8");  
delay_ms(300);
}
sek=0;
ob_min=0;  
}  

if(PINA.2==0)             
{  
delay_ms(100);     
while(sek<5)
{  
delay_ms(50);
if(PINA.0==0) {delay_ms(50);sek=5;} 
if(PINA.2==0) {delay_ms(100);sek=0;if(uoz_i==7) uoz_i=0;else uoz_i++;menu1();
while(PINA.2==0)
{ 
if((sek>5) &&(oboroty<1100)) 
{default_set();
lcd_clear();

lcd_puts("\xA9\xB4\xBB\xC3 \xBE\x6F \x79\xBC\x6F\xBB\xC0\x61\xBD.");
delay_ms(500);sek=5;
lcd_clear();} 
}  

} 
if(PINA.1==0) {delay_ms(100);sek=0;if(uoz_i==0) uoz_i=7;else uoz_i--;menu1();}
if(PINA.3==0) {delay_ms(80);sek=0;menu2();sek=0;

while(sek<4)
{
delay_ms(50);
if((PINA.2==0)&&(percent[f][7-uoz_i]<100)) {sek=0; percent[f][7-uoz_i]++;menu2();} 
if((PINA.1==0)&&(percent[f][7-uoz_i]>0))   {sek=0; percent[f][7-uoz_i]--;menu2();}        
}              
}
}                     

ob_min=0; 
sek=0;}

if(PINA.3==0)             
{ 
delay_ms(100); 

while(PINA.3==0)
{ 
if(sek>4) 
{
lcd_clear();
lcd_puts("s_lit \x40  ukr.net");
delay_ms(2000);
lcd_clear();

} 
}  
if(sek<2) 
if((oboroty<1100))
{       
if(f<3) f++;
else f=0; 
}
else {
sek=0; 
lcd_clear();

lcd_puts("\x43\xB2\x70\x6F\x63\xC4  \x6F\xB2\x6F\x70\x6F\xBF\xC3");
delay_ms(400);
}

ob_min=0;
sek=0;
}      

if (sek>1)
{ 
sek=0;    
oboroty=ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min;
ob_min=0;

temp_buf=ds18b20_temperature(&RomCode[0][0]);
if(temp_buf>0) temp1=temp_buf;  

temp_buf=ds18b20_temperature(&RomCode[1][0]);
if(temp_buf>0) temp2=temp_buf; 

lcd_gotoxy(0,0); 
if(uoz_i>0) uoz_i--;

if(f<4)
{

sprintf(buffer,"     \xCE\x3D%d",f+1);  
lcd_puts(buffer); 
sprintf(buffer," %d",kk);  
lcd_puts(buffer);
lcd_gotoxy(0,1);      
sprintf(buffer,"%d      ",oboroty);  
lcd_puts(buffer);
lcd_gotoxy(5,1); 
sprintf(buffer,"%d",percent[f][kk]);  
lcd_puts(buffer);
lcd_puts("\x25  ");   

}
else {   
lcd_clear();     
sprintf(buffer,"    \xB3\xC3\xBA\xBB%d",oboroty);  
lcd_puts(buffer);  
}

} 

};  

}
