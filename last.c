
//
//Warning: E:\�����������\NEW_FUOZ\����� �����\last.c(31): the 'double' data type will be supported only in the 'Professional' version, defaulting to 'float'
//
//
//
//    ����������������� � ������ ������
//
//
//
//




/*****************************************************
Date                : 16.03.2012                            
Chip type           : ATmega16
Program type        : Application
Clock frequency     : 16,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega16.h>
#include <delay.h>
#include <stdio.h>


// 1 Wire Bus functions
//#asm
//   .equ __w1_port=0x1B ;PORTA
//   .equ __w1_bit=2
//#endasm
//#include <1wire.h>
#include <ds18b20.h>
#include <alcd.h>

unsigned char devices;
unsigned char RomCode[2][9];


char buffer[16];
int oper=0,yes=0,oboroty=0,ob_y=0,uoz_i=0,zn1=0,zn2=0,sek=2,ob_min=0,temp1,temp2,temp_buf,i=0,kk=7;
int temp_ugly[15]={480,480,480,480,480,480,480,480,480,480,480,480,480,480,480};
 

                                                        
eeprom int temp_f,f,percent[4][8],prer_ugly[8]; 
           

        
    
// �������� ����� 16 000 000, ������ ������� 256, �.�. � ������� �� ������������ ����� 62500 ���
// ����� ���-�� ������������ ���� ������ (64 ����/��), �������� ������ ������� �� 250, ������ ���������� �� ������ � 5 (0x05)
// ������������ �������� ������� ���������� 2.22 �� ��� 9000 ��/���. (120 ��������)
// ������ ���������� ��������� 2.2*64=140.8 ��� 
// � ������������ ����� ������� ��� 900 ��/��� �������� 22.2�� = 1420.8 ���

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{

// Reinitialize Timer 0 value
TCNT0=0x05;   
////////////////////////////////////////////////////
//���������� ������ 64 ���� � 1 ��

zn1=zn2;             // ��������� ���������� ��������
zn2=PINA.6;          // ��������� �����              //PIND.2 !!!

//if(f==4)             // f=4 ���� ��������
//   {  
//          PORTD.3=PINA.6;        //PORTD.6 = PIND.2 !!!
//           if((zn1==0) && (zn2==1)) ob_min++;
//   }
//
//else 
//{ 
   if(zn1==zn2)
      
      if(zn2==1) 
         if(yes<(prer_ugly[7]+prer_ugly[7])) yes++;
         else PORTD.3=0;                                 //PORTD.6 !!!
      else 
         if(yes>0) yes--;
         else PORTD.3=0;        //PORTD.6 !!!
    
    else
      
      if(yes==0) {PORTD.3=1; ob_min++;}   //PORTD.6 !!!
      else
       {   
        
        if(yes>prer_ugly[3])                   // ������ ������ ��������
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
//}
}

// Timer 1 overflow interrupt service routine
// 65536 - 62500 = 3036; 31250=
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
TCNT1=34000;   //34000
sek++;   
}

// Timer 1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{                 
}

// Timer 1 output compare B interrupt service routine
interrupt [TIM1_COMPB] void timer1_compb_isr(void)
{
}  


void menu1(void)
{
        lcd_clear(); 
        sprintf(buffer,"  %dx",uoz_i); //
        lcd_puts(buffer);
        sprintf(buffer,"%d",percent[f][7-uoz_i]);
        lcd_puts(buffer);
        lcd_puts("\x25");   // symbol %  
        lcd_gotoxy(0,1);        
        lcd_puts("<2 3> 4\x7E");  
        
         
        ////  sprintf(buffer,"%.0f\x27",UOZ_proc[8-uoz_i]); // ����� ������������� ����� �� �����   
}

void menu2(void)
{       lcd_gotoxy(0,0);
          //New:
        sprintf(buffer,"\xA5\xB7\xBC. %d",percent[f][7-uoz_i]);
        lcd_puts(buffer);
        lcd_puts("\x25 ");   // symbol %  
        lcd_gotoxy(0,1);        
        lcd_puts("< 2  3 >");   
        delay_ms(20);
  
}

void menu_temp(void)
{
      
        lcd_puts("   \xF7    ");
  
        if (temp1>1000)                   //���� ������ 1 ������ ������ 1000 
          temp1=(-1)*(4096-temp1);        //������� �� ������ 4096 � ������ ���� "�����"                 
          
        
        sprintf(buffer,"%d\x27",temp1);  
        lcd_puts(buffer);
       
         
        
        if (temp2>1000)                   //���� ������ 2 ������ ������ 1000 
          temp2=(-1)*(4096-temp2);        //������� �� ������ 4096 � ������ ���� "�����"                 
      

        lcd_gotoxy(5,1);
        sprintf(buffer,"%d\x27",temp2);  
        lcd_puts(buffer);
                         
        delay_ms(1000);
        
}

void default_set (void)
{

 //������� ������� ������� ������ � �����������
 
 prer_ugly[0]=60;
 prer_ugly[1]=69;
 prer_ugly[2]=80;
 prer_ugly[3]=96;
 prer_ugly[4]=120;
 prer_ugly[5]=160;
 prer_ugly[6]=240;
 prer_ugly[7]=480;
 
 
 // ������� ��������� ���������� 
 percent[0][0]=98;  percent[1][0]=62;  percent[2][0]=58;   percent[3][0]=68;   // �� 7000 �� 8000 ��/���
 percent[0][1]=98;  percent[1][1]=60;  percent[2][1]=57;   percent[3][1]=68;   // �� 6000 �� 7000 ��/���
 percent[0][2]=98;  percent[1][2]=59;  percent[2][2]=54;   percent[3][2]=65;   // �� 5000 �� 6000 ��/���
 percent[0][3]=98;  percent[1][3]=55;  percent[2][3]=52;   percent[3][3]=54;   // �� 4000 �� 5000 ��/���
 percent[0][4]=98;  percent[1][4]=50;  percent[2][4]=49;   percent[3][4]=49;   // �� 3000 �� 4000 ��/���
 percent[0][5]=98;  percent[1][5]=19;  percent[2][5]=48;   percent[3][5]=48;   // �� 2000 �� 3000 ��/���
 percent[0][6]=98;  percent[1][6]=5;   percent[2][6]=18;   percent[3][6]=18;   // �� 1000 �� 2000 ��/���
 percent[0][7]=0;   percent[1][7]=0;   percent[2][7]=0;    percent[3][7]=0;    // �� 0 �� 1000 ��/���
                                                                               // ���������� ������� ������������ ��� ������ "��� ����"

 f=0;
 temp_f=4;                                    
}


void main(void)
{
// Declare your local variables here


PORTA=0xff;
DDRA=0x00;             // � �����, PORTA.6 - ��� ���� ������������� �������

PORTB=0x00;
DDRB=0xFF;             

PORTC=0x00;
DDRC=0xFF;

PORTD=0b10110111;
 DDRD=0b11001000;  //   ������ :DDRD=0b11000000; !!!  � �����, PORTD.3 - ��� ����� �� ���������.

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 16000,000 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x01;
TCNT0=0x05;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 62,500 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
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


// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;
  
  
// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Rising Edge
// INT1: Off
// INT2: Off
//GICR|=0x40;         /* ������� General Interrupt Control Register ��������� ������� ���������� 
//                                      10 000000 - �� ������ int1;
//                                      01 000000 - �� ������ into;
//                                      11 000000 - �� ����� ������� */
//
//MCUCR=0x03;          /* ������� Micro Controller Unit Control Registr ����������� ���������� �� ������������:
//                                           0000 10 00 - �� ���������� ������ ������� �� ������ int1; 
//                                           0000 11 00 - �� ������������ ������ ������� �� ������ int1;
//                                           0000 00 00 - �� ������� ������ �� ������ int1;
//                                           0000 01 00 - �� ������ ��������� ������ �� ������ int1 */

MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x1D;
// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;



lcd_init(8);             // ������������� ������� 
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


/////////////////////// SOUND TA-TA....
//for(i=0;i<20;i++)
//{
//PORTD.6=1;
//delay_ms(1);
//PORTD.6=0;
//delay_ms(1);
//}
//delay_ms(60);
//
// for(i=0;i<20;i++)
//{
//PORTD.6=1;
//delay_ms(1);
//PORTD.6=0;
//delay_ms(1);
//}

  devices=w1_search(DS18B20_SEARCH_ROM_CMD, RomCode); //����� �������� �� ����� 1-wire
   
  if(devices)
  {   
///////////////////////// ���������� ��������� ���������� 1-wire
    lcd_gotoxy(0,0);
    sprintf(buffer,"device=%u", devices); //������� ���������� � ���-�� ��������
    lcd_puts(buffer);
    lcd_gotoxy( 0,1 ); 
    lcd_puts("reading");
    delay_ms(300);
    
    ds18b20_init(&RomCode[0][0], 50, 140, DS18B20_9BIT_RES); //������������� ������� �������
    ds18b20_init(&RomCode[1][0], 50, 140, DS18B20_9BIT_RES); //������������� ������� �������
    lcd_clear();  
    temp1=ds18b20_temperature(&RomCode[0][0]);//������ ����������� 1 �������
    temp2=ds18b20_temperature(&RomCode[1][0]);//������ ����������� 1 �������
     menu_temp(); 
     delay_ms(1500); 
     lcd_clear();
        
     }
 // else{ lcd_gotoxy(0,0); lcd_puts("NO TEMP.DEVICES"); delay_ms(1500);}
                                  // ��� ����. ����.                                  
    else{ lcd_gotoxy(0,0); lcd_puts("\x48\x65\xBF \xBF\x65\xBC\xBE\xE3\x61\xBF\xC0\xB8\xBA\x6F\xB3"); delay_ms(1500);}




#asm("sei")       // Global enable interrupts 
TCNT1=0; 
sek=0;
             //���������� ����������
             
lcd_puts("s_lit \x40  ukr.net");
delay_ms(500);
if(PINA.0==0)
      { 
       lcd_clear();
        delay_ms(700);
        // reset all settings
        default_set();
         i=0;
         
        // ����� ��� ����        
        f=f+temp_f;
        temp_f=f-temp_f;
        f=f-temp_f;
        
                               //������ ����
        lcd_clear(); lcd_puts("\xA4\x61\xB3\x65\xE3\xB8     \xB2\x61\xB9\xBA"); delay_ms(3000);
     
       
      
      // ����, ���� ������� 
       sek=0;
      
       while(oboroty<800)
         {
         if(sek==1)
            {
             sek=0;
             oboroty=ob_min*60;
             ob_min=0;
             }
         } // �������

                               //������ 1000 ��/���
        lcd_clear(); lcd_puts("\x48\x61\xB2\x65\x70\xB8  1000\x6F\xB2\x2F\xBC"); delay_ms(3000);
        lcd_clear();
            sek=0;
            ob_min=0;
            
            // ���� ���� ������� 1000 (+- 60) � ��������� 2 ���.
        
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
              sprintf(buffer,"     :%d   ",15-i);  //wait 
              lcd_puts(buffer);
              lcd_gotoxy(0,1);
              sprintf(buffer,"%d      ",oboroty);  //���������� ������� (��� � ���) 
              lcd_puts(buffer);
              delay_ms(100);
              }
                   
         } //��������� 2 ���
        
          //Done
        lcd_clear(); 
       
        for(i=0;i<14;i++)
        temp_buf=temp_buf+temp_ugly[i];
        
        temp_buf=temp_buf/15;
        
        sprintf(buffer,"AVR:%d",temp_buf);  //���������� ������ ������ � ����������� 
        lcd_puts(buffer); 
        
        delay_ms(3000);
        
        f=f+temp_f;
        temp_f=f-temp_f;
        f=f-temp_f;
        } // ����� ���������
        
      
while (1)
      { 
  
           // �����������     
        if(PINA.0==0)             // ���� ������ ������ �1. �����������
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
                  //lcd_puts("FUOZ ON");
                  lcd_puts("\xAA\xA9\x4F\xA4         \x42\xBA\xBB"); 
                  else
                  // lcd_puts("FUOZ OFF");
                  lcd_puts("\xAA\xA9\x4F\xA4        \x42\xC3\xBA\xBB");
                  delay_ms(700);
                  lcd_clear();} 
                  }  
                 
                if((sek<3)&&(oboroty<1400)) menu_temp(); 
                   
                 ob_min=0;
                 sek=0;
              } 
         
                          
             // ������� ������    
         if(PINA.1==0)             // ���� ������ ������
            {  
            delay_ms(100);
            if(oboroty==0)
            { 
            #asm("cli");
            lcd_clear();
            //lcd_puts("Heating spark...");                     
            lcd_puts("\xA8\x70\x6F\xB4\x70\x65\xB3 \x63\xB3\x65\xC0\x65\xB9..");
            for(i=0;i<50;i++)
              {
               PORTD.3=1;         //PORTD.6 !!!
               delay_ms(25);
               PORTD.3=0;         //PORTD.6 !!!
               delay_ms(7);   
               } 
            lcd_clear();
            //lcd_puts("Finished");   
            lcd_puts(" \xA1\x6F\xBF\x6F\xB3\x6F"); 
            delay_ms(250);
            #asm("sei");
            }

            else
            { 
             lcd_clear();
             //lcd_puts("First      off");
             lcd_puts("\x43\xBD\x61\xC0\x61\xBB\x61  \xB7\x61\xB4\xBB\x79\xC1\xB8");  
             delay_ms(300);
             }
            sek=0;
            ob_min=0;  
            }  
            
             // �������� ������� ��������
        if(PINA.2==0)             // ���� ������ ������
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
                  //lcd_puts("DEFAULT  SETTING");                 
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
                                    if((PINA.2==0)&&(percent[f][7-uoz_i]<100)) {sek=0; percent[f][7-uoz_i]++;menu2();} //����������� ��������
                                    if((PINA.1==0)&&(percent[f][7-uoz_i]>0))   {sek=0; percent[f][7-uoz_i]--;menu2();}        
                                    }              
                            }
                   }                     
            
            ob_min=0; 
            sek=0;}
            
           // ����� ������
  if(PINA.3==0)             // ���� ������ ������
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
            //////////������ �������
            lcd_puts("\x43\xB2\x70\x6F\x63\xC4  \x6F\xB2\x6F\x70\x6F\xBF\xC3");
            delay_ms(400);
            }
            
            ob_min=0;
            sek=0;
            }      
            
         
/////////////////////// ��������� �� �������

if (sek>1)
         { 
        sek=0;    // ob_min*30
        oboroty=ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min;
        ob_min=0;
         
       
        temp_buf=ds18b20_temperature(&RomCode[0][0]);//������ ����������� 1 �������
        if(temp_buf>0) temp1=temp_buf;  
       
                                                                                 
        temp_buf=ds18b20_temperature(&RomCode[1][0]);//������ ����������� 2 �������
        if(temp_buf>0) temp2=temp_buf; 
        
        
        lcd_gotoxy(0,0); 
        if(uoz_i>0) uoz_i--;
//        lcd_puts("O\xB2.  \xA9\xB4.");
        if(f<4)
        {
        
        /// ����������
      
//        sprintf(buffer,"%d ",oboroty);  //���������� ������� (��� � ���) 
//        lcd_puts(buffer);
//        sprintf(buffer,"%d ",ob_y);  //���������� ������ ������ � ����������� 
//        lcd_puts(buffer);
//        sprintf(buffer,"%d ",oper);  //���������� ���� ���������� � �����������
//        lcd_puts(buffer);
//        sprintf(buffer,"%d",percent[f][kk]);  //���������� ���� ���������� � %
//        lcd_puts(buffer);  
//        lcd_puts("\x25   ");   // symbol % 
        
        ////////////
        
     
     /////// standard screen
      sprintf(buffer,"     \xCE\x3D%d",f+1);  //������ ������ (�� - ���������� ������� � �������� ��������� ����������)
      lcd_puts(buffer); 
      sprintf(buffer," %d",kk);  //������ ������ (�� - ���������� ������� � �������� ��������� ����������) 
      lcd_puts(buffer);
      lcd_gotoxy(0,1);      
      sprintf(buffer,"%d      ",oboroty);  //���������� ������� (��� � ���) 
      lcd_puts(buffer);
      lcd_gotoxy(5,1); 
      sprintf(buffer,"%d",percent[f][kk]);  //���������� ���� ���������� � %  
      lcd_puts(buffer);
      lcd_puts("\x25  ");   // symbol % 
      ///////////////////////
 
 
 
      //  sprintf(buffer,"%d ",ob_y);  //���������� ������ ������ � ����������� 
      //sprintf(buffer,"%d      ",ob_min*30);  //���������� ������� (��� � ���)    
      //sprintf(buffer,"%d      ",ob_y);  //���������� ������ ������ � ����������� 
      // sprintf(buffer,"%d\x27",60*OC/ob_y);  //  ���������� ���� ����������  (� ��������) 
      // sprintf(buffer,"%d      ",OC);  //���������� ���� ���������� � �����������
      // sprintf(buffer,"%d",45*percent[kk][f]/100);  //���������� ���� ���������� � ��������
       
      // lcd_puts("\x27");   // symbol '  
      // lcd_puts("\xDF");   // symbol `
           }
        else {   //�������� ����, ������� ��������� �� �����
         lcd_clear();     
         sprintf(buffer,"    \xB3\xC3\xBA\xBB%d",oboroty);  //���������� ������� (��� � ���
         lcd_puts(buffer);  
              }
       
         } 
     
      };  

    }