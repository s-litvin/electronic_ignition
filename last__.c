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
#include <delay.h>
// 1 Wire Bus functions
#asm
   .equ __w1_port=0x1B ;PORTA
   .equ __w1_bit=2
#endasm
#include <1wire.h>
#include <ds18b20.h>
#define DIG_BASE  10 /* ��������� ������� ���������� ��� �������� */
#define MAX_SIZE 3 /* ������������ ����� ��������� �������� */
#define SPACE_CHAR  ' ' /* ������ "�������" ����� */
#define NEG_CHAR '-' /* ������ "�����" */

int x=0,uoz_set=0,y=0,delitel=63,k1=0,stop=0,sek=0,int_count1=0,int_count2=0,k=0,b1=0,b2=0,p=0,ob_min=0,minuten=0,t=0,int_flag=0,temp,temp_buf,i,m,sign=0;
int timer_count=0;
unsigned char SYMBOLS[DIG_BASE] = {'0','1','2','3','4','5','6','7','8','9'};
unsigned char out[MAX_SIZE]; // �������� ������ �������� (�������� �������)
unsigned char out_buf[MAX_SIZE]; // �������� ������ �������� (�������� �������)
unsigned char Dig[13];
float UOZ_proc[10]={87,121,88,73,61,53,45,41,37,33},UOZ[] = {8.3,23.0,25.0,27.0,29.0,30.0,30.0,31.0,31.0,31.0};
unsigned char devices;
char diplay_port[] = {0x40,0x02,0x01};


// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
if((TCNT1>150)&&(TCNT1<3000))      // ���� ������� ���������� �� ������
     {
 /*if(int_flag==0)     // ������ ������ �������
    {
     int_count1=TCNT1;
      //OCR1A=OCR1A+y;
     int_flag=1;
    }
 else*/                // ������ ������ �������
    {
     int_count2=TCNT1; // �������� ������� ������ �������
    timer_count=0;    // ������� ������������ �������
    TCNT1=0;          // ������ �������
    // int_flag=0;       // ��������� �������
     ob_min++;         // �������� ������ ������

  ///////// ���������� ���������� ����

   if(int_count2>2750)
   y=UOZ_proc[0];
   else      //int_count2-
   if((int_count2<=2750)&&(int_count2>1890))
   y=(((int_count2-1890)*(UOZ_proc[0]-UOZ_proc[1]))/(2750-1890)+UOZ_proc[0]);
   else
   if((int_count2<=1890)&&(int_count2>945))
   y=(((int_count2-945)*(UOZ_proc[1]-UOZ_proc[2]))/(945-1890)+UOZ_proc[1]);
   else
   if((int_count2<=945)&&(int_count2>630))
   y=(((int_count2-630)*(UOZ_proc[2]-UOZ_proc[3]))/(945-630)+UOZ_proc[2]);
   else
   if((int_count2<=630)&&(int_count2>472))
   y=(((int_count2-472)*(UOZ_proc[3]-UOZ_proc[4]))/(630-472)+UOZ_proc[3]);
   else
   if((int_count2<=472)&&(int_count2>378))
   y=(((int_count2-378)*(UOZ_proc[4]-UOZ_proc[5]))/(472-378)+UOZ_proc[4]);
   else
   if((int_count2<=378)&&(int_count2>315))
   y=(((int_count2-315)*(UOZ_proc[5]-UOZ_proc[6]))/(378-315)+UOZ_proc[5]);
   else
   if((int_count2<=315)&&(int_count2>270))
   y=(((int_count2-270)*(UOZ_proc[6]-UOZ_proc[7]))/(315-270)+UOZ_proc[6]);
   else
   if((int_count2<=270)&&(int_count2>236))
   y=(((int_count2-236)*(UOZ_proc[7]-UOZ_proc[8]))/(270-236)+UOZ_proc[7]);
   else
   if(int_count2<=236)
   y=UOZ_proc[8];

   OCR1A=int_count2-y;   // ���������� ��� ������ ����� ����� �������� �������� ����
   stop=0;
     }
      }
      else
      if(timer_count>0){stop=1; OCR1A=0x00;}     // ����� ��������, ��������� �����

 }

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

///////////////// ������� //////////////////////////

PORTC=0x00;
PORTB=0x00;

if(k1<2) k1++;                                    //
 else k1=0;                                       //
                                                  //
PORTB=out[k1];                                    //
PORTC=diplay_port[k1];  // ������ (������ ������) //
                                                  //
////////////////////////////////////////////////////
if(p==57720)
         {sek++; p=0;}
else p++;

}

// Timer 1 overflow interrupt service routine
// 65536 - 62500 = 3036; 31250=
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Reinitialize Timer 1 value
timer_count++;
//TCNT1=3035; //3035
}

// Timer 1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
// Place your code here

// ���������� ��� ������ �����
     /*
///////////////// ������� //////////////////////////

PORTC=0x00;
PORTB=0x00;

if(k1<2) k1++;                                    //
 else k1=0;                                       //
                                                  //
PORTB=out[k1];                                    //
PORTC=diplay_port[k1];  // ������ (������ ������) //
                                                  //
//////////////////////////////////////////////////// */
if(stop==1)      // �� �������� �����
 {};
}

// Timer 1 output compare B interrupt service routine
interrupt [TIM1_COMPB] void timer1_compb_isr(void)
{
// Place your code here
}

// Timer 2 overflow interrupt service routine 15625
interrupt [TIM2_COMP] void timer2_comp_isr(void)
{
// Place your code here
}


 /*
 ����    ���   ��/���  ����/��  ����/����������
 87	8,30	1000	3780      1890
 121	23,10	2000	1890      945
 88	25,10	3000	1260      630
 73	27,80	4000	945       472
 61	29,10	5000	756       378
 53	30,00	6000	630       315
 45	30,00	7000	540       270
 41	31,40	8000	472       236
 37	31,60	9000	420       210
 33	31,80	10000	378       189
   */

void Dig_init()
{
    Dig[0]=0b10101111;  //'0'
    Dig[1]=0b10100000;  //'1'
    Dig[2]=0b11001101;  //'2'
    Dig[3]=0b11101001;  //'3'
    Dig[4]=0b11100010;  //'4'
    Dig[5]=0b01101011;  //'5'
    Dig[6]=0b01101111;  //'6'
    Dig[7]=0b10100001;  //'7'
    Dig[8]=0b11101111;  //'8'
    Dig[9]=0b11101011;  //'9'
    Dig[10]=0b00000000; //' '
    Dig[11]=0b00010000;  //'.'
    Dig[12]=0b01000000;  //'-'
}

 // �������, ������� ��������� �������� ������ ���������� �������������� �����
			// ��� ���� �� ������� ���������� ����� ����, �.�. ����� 1 ��������� ��� '     1'
	void trim_convert(int NUM){

	   if(NUM <0)  // ���� ����� �������������
	     {
              sign = 1; // ��������� ������� ������� �����
              NUM *= -1; // � ���� ����� ������� �� ������
             }

             // ������� ��� ������������� �����

	    for(i=MAX_SIZE-1; i>=0; i--)   // ���� ���������� ��������� ������� ������ ������
	    {
	       m = NUM % DIG_BASE; // ������� ������� �� ������� ����� �� ���������
	       if((NUM==0)&&(i!=(MAX_SIZE-1))) // ���� ���� ����� - ���� � ����� �� � ������ �������
	         if (sign==1) {out_buf[i]= '-';sign=0;}
		    else  out_buf[i] = SPACE_CHAR; // �� ������� "������" ����� - ��������� ���������� ����
	       else
		 out_buf[i] = SYMBOLS[m]; // ����� ������� ������ ������ �����
	         NUM /= DIG_BASE;  // ��������� ����� � DIG_BASE ���
	      }

	       // if (i < 0){} // ����� �� ������� - �����
               //  (sign==1) out[0] = '-'; // ������� ����, ���� �����


         for(i=0; i<MAX_SIZE;i++)  // ����� ��������� ��� ���������� ����� � ��� ��� ������ �� ����

		 if(out_buf[i]=='0') out_buf[i] = Dig[0];
                else   if(out_buf[i]=='1') out_buf[i] = Dig[1];
                else   if(out_buf[i]=='2') out_buf[i] = Dig[2];
                else   if(out_buf[i]=='3') out_buf[i] = Dig[3];
                else   if(out_buf[i]=='4') out_buf[i] = Dig[4];
                else   if(out_buf[i]=='5') out_buf[i] = Dig[5];
                else   if(out_buf[i]=='6') out_buf[i] = Dig[6];
                else   if(out_buf[i]=='7') out_buf[i] = Dig[7];
                else   if(out_buf[i]=='8') out_buf[i] = Dig[8];
                else   if(out_buf[i]=='9') out_buf[i] = Dig[9];
                else   if(out_buf[i]==' ') out_buf[i] = Dig[10];
                else   if(out_buf[i]=='.') out_buf[i] = Dig[11];
                else   if(out_buf[i]=='-') out_buf[i] = Dig[12];

          for(i=0;i<MAX_SIZE;i++)
            out[i]=out_buf[i];     // �������� ���������� ����� �� ��������� ������� � ������ ��� ������ �� �������

        }


void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
PORTC=0x00;
DDRC=0xFF;

// Port D initialization
// Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=1 State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTD=0xff;
DDRD=0x80;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 16000,000 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x01;
TCNT0=0x05;
OCR0=0x70;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 62,500 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: On

TCCR1A=0x00;
TCCR1B=0x04;

TCNT1=0;

ICR1H=0x00;
ICR1L=0x00;

OCR1A=0x41;

OCR1BH=0x00;
OCR1BL=0x00;
// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
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
GICR|=0x40;         /* ������� General Interrupt Control Register ��������� ������� ����������
                                      10 000000 - �� ������ int1;
                                      01 000000 - �� ������ into;
                                      11 000000 - �� ����� ������� */

MCUCR=0x03;          /* ������� Micro Controller Unit Control Registr ����������� ���������� �� ������������:
                                           0000 10 00 - �� ���������� ������ ������� �� ������ int1;
                                           0000 11 00 - �� ������������ ������ ������� �� ������ int1;
                                           0000 00 00 - �� ������� ������ �� ������ int1;
                                           0000 01 00 - �� ������ ��������� ������ �� ������ int1 */

MCUCSR=0x00;
GIFR=0x40;
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x1D;
// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;
// 1 Wire Bus initialization
devices=w1_init();   //temp_buf=ds18b20_temperature(0); //�������� �����������


Dig_init();            // ������������� ������� ��������

for(i=0;i<10;i++)
UOZ_proc[i]=((UOZ[i]*(60000/((i+1)*1000)))/360)*delitel; // ������������� ������� ����� (������� ���� � % �� �������)

#asm("sei")       // Global enable interrupts
TCNT1=0;
//trim_convert(temp_buf);
//delay_ms(2000);

while (1)
      {
       if(minuten>999) minuten=0;
       if(minuten<-99) minuten=-99;

 //��������� ������ menu

      /////////////////////// Button 1
     /* if (PINA.0 == 1)      //��������� �������
      {
        delay_ms(65);       //���������� "�������� ������"
        b1 = 1;             //������������� ���� "������ ������"

        if (PINA.0 == 1)    //��������� �������
        {
            t=p;             // ��������� ����� ������� �� ������ (� ��������).
            minuten+=1;
            while(PINA.0==1)             // ���� ������ ������ � ������������ 3 �������
            {
             //PORTB.0=1;    // �������� ���������� ����

             trim_convert(minuten);

             if(p==t+6)
                 {
                 TCNT1=3400;
                 minuten=0;
                 p=0;
                 t=p;
                 }
             }

            delay_ms(65);
            b1=0;
         }

      }   */

  /////////////////////////  Button 2
           /*
      if (PINA.1 == 1)      //��������� �������
      {
        delay_ms(65);        //���������� "�������� ������"

        b2=1;               //������������� ���� "������ ������"
        if (PINA.1 == 1)    //��������� �������
        {
         t=p;          // ��������� ����� ������� �� ������ (� ��������).
         minuten--;
         while(PINA.1==1)             // ���� ������ ������ � ������������ 3 �������
            {
            // PORTB.0=1;    // �������� ���������� ����

             if(p==t+3)
                 {
                 temp=ds18b20_temperature(0);

                 if (temp>1000)         //���� ������ ������ ������ 1000
                 temp=(-1)*(4096-temp);     //������� �� ������ 4096 � ������ ���� "�����"

                  if((temp<500)&&(temp>-500)) {trim_convert(temp); temp_buf=temp;}
                  else  trim_convert(temp_buf);
                  t=p;
                 }
             }
            trim_convert(minuten);
            delay_ms(65);
            b2=0;
         }

      }
         */

        if(PINA.1==1)             // ���� ������ ������
            {
               delay_ms(100);
                  if(uoz_set<10)
                 uoz_set++;
                 else uoz_set=0;
                 trim_convert(UOZ[uoz_set]);

                delay_ms(500);

                 }

         if(PINA.0==1)             // ���� ������ ������
            {
               delay_ms(100);
              UOZ[uoz_set]+=1.0;
              trim_convert(UOZ[uoz_set]);

                delay_ms(500);
UOZ_proc[uoz_set]=(((UOZ[uoz_set]*(60000/((uoz_set+1)*1000)))/360)*delitel); // ������������� ������� ����� (������� ���� � % �� �������)
              trim_convert(UOZ_proc[uoz_set]);
              delay_ms(500);
                 }


   //  �������� �� �������� ������� ������� ����������
  /* if(timer_count > 1421)     // ���� ������� ����������� ���������� �����, �� ��������� �����
        {
         timer_count=0;
         mod_count=0;
         }
    */
    /*
  if (PINA.3 == 1)             // ��������� ����������, ���� �� ������ �������� ����
           {
           if(mod==0)
           {
           //PORTB.0=1;               // ��������� ���������� ��� ���� ����
           ob_min++;
           mod=1;
           }
           }

  else                         // �����

       if(mod==1)                 // ���� ��������� ������ �����
           {
          // PORTB.0=0;               // �������� ��������
           mod=0;                   // �������� ���� "��������� �����"
           }

      */

          ///////////////////////////////////
  /*     if(sek==1)
          {
        sek=0;
        trim_convert(64000/mod_count);//1MHz, 8000/mod_count  ���� ������� 3 �����. 80 000 - ���� ������� �������������� �����  (��������� 120 ��������)

          }                            //1MHz, 4000/mod_count  ��� ���������� 60 ��������, 40 000 - �������������� �����
           */                          //16MHz,128 000/mod_count  ��� ���������� 60 ��������, 1 280 000 - �������������� �����
                                       //16MHz,64 000/mod_count ���� ������� 3 �����.640 000 - ���� ������� �������������� �����  (��������� 60 ��������)




    // ��������� �� �������
if((b1==0)&&(b2==0))
if (sek==1)
         {
        trim_convert(y); //trim_convert(y*360/int_count2);
         }
 else
      if(sek==2)
      {
      //trim_convert(ob_min*1.5);            // �������, ������������ �� 1 ���.
       ob_min=0;
       sek=0;
       //trim_convert(1000/(int_count2/delitel)*3); // ������� ������� �� ����������� �� �������� �������
         trim_convert((1000/((int_count2)/delitel))*3);
       }


   /////////////////////////////////////////////////////


        if(b2==1)
         if(p==t+4)
          {
            if(k==0)
              {
             // PORTB.0=1;
              trim_convert(minuten);
              k=1; // ���� ������������������
              }
            else
              {
              trim_convert(temp_buf);   // ������� � ���������� ��������
              temp=ds18b20_temperature(0); //�������� �����������
              if (temp>1000)         //���� ������ ������ ������ 1000
                 temp=(-1)*(4096-temp);     //������� �� ������ 4096 � ������ ���� "�����"
              if((temp<500)&&(temp>-500)) {trim_convert(temp); temp_buf=temp;}  // ���� ����������� �������� ���������, �� ������� � �� �������
              k=0; // ���� ������������������
              }

              if(p<114)
              t=p;
              else t=0;
           }
      };
}
