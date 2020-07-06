
STACKS SEGMENT STACK
    DB 256 DUP(?)
STACKS	ENDS

CODE	SEGMENT
	ASSUME CS:CODE,SS:STACKS
START:
      mov dx,0206h	;8255A控制字寄存器地址 0000 0010 0000 0110B=0206H
      mov ax,80h	;8255A控制字 1000 0000B =80H ,A口输出, A口方式0
      out dx,ax		;将控制字写入8255A的控制端口

      mov dx,0200h	;A口地址 0000 0010 = 0200h
      mov ax,0ffh	;0ffH = 1111 1111
      out dx,ax		;初始化
	 
	;东西通行，南北禁行
  s1: mov ax,0beh	;10111110，东西方向绿灯，南北方向红灯
      out dx,ax		;将数据输出到A口
      call delay	;保持10s
	
	;东西黄灯闪烁
      mov cx,3
  lp: mov ax,0bdh	; 10111101，东西方向黄灯灯，南北方向红灯
      out dx,ax
      call delay0	;等待大致0.5s
      mov ax,0bfh	;10111111，东西全关，南北方向红灯
      out dx,ax
      call delay0	;等待大致0.5s
      loop lp
	;南北通行，东西禁行
      mov ax,0ebh	;11101011，南北方向是绿灯，东西方向红灯
      out dx,ax
      call delay
	  
	;南北黄灯闪烁
      mov cx,3
  lp1:mov ax,0dbh	;11011011 南北方向黄灯，东西方向红灯
      out dx,ax
      call delay0
      mov ax,0fbh	;11111011	南北方向全关，东西方向红灯
      out dx,ax
      call delay0
      loop lp1

      jmp s1 ;循环
;路灯持续时间 大致为 10s
  delay proc near
      push cx
      mov bx,500
    dy1:mov cx,5882	;循环大致 20 ms ,500*20=10000ms=10s
    dy2:loop dy2
      dec bx
      jnz dy1
      pop cx
      ret
  delay endp  

  delay0 proc near
      push cx
      mov bx,25
    dy3:mov cx,5882
    dy4:loop dy4
      dec bx
      jnz dy3
      pop cx
      ret
  delay0 endp  
 
CODE ENDS 
END

     
