section .data
text_to_write db 'hello world !',10
len_text_to_write equ $-text_to_write
msg_done  dd 'operation done!',10
len_msg_done equ $-msg_done
file_name dd '/home/peyman/Desktop/test.txt',10
len_file_name equ $-file_name
input_0  dd  '/home/Downloads',10
len_input_0 equ  $-input_0
msg_0   dd  '1.create a file',10
len_msg_0  equ  $-msg_0
msg_1   dd  '2.read from file',10
len_msg_1 equ  $-msg_1
msg_2     dd  '3.write to file',10
len_msg_2  equ $-msg_2
msg_3  dd   '4.search in file',10
len_msg_3  equ  $-msg_3
msg_4   dd   '5.replace word in file',10
len_msg_4 equ  $-msg_4
msg_5  dd '6.giving information about file',10
len_msg_5  equ $-msg_5
msg_6    dd 'Please enter file path :',10
len_msg_6 equ  $-msg_6
msg_7    dd  'enter 0 to exit.',10
len_msg_7  equ  $-msg_7
msg_8     dd  'select one of this options:',10
len_msg_8  equ   $-msg_8


section .bss
fd resb 1
input resw  10
len_input  equ $-input
select resw 5
len_select equ $-select
file_name_1 resd 10
len_file_name_1 equ $-file_name_1
read_buffer resb   300000
len_read_buffer equ $-read_buffer
write_buffer  resb   300000





section .text
global _start

_start:
;show message for user
mov eax ,4
mov ebx ,1
mov ecx ,msg_8
mov edx ,len_msg_8
int 80h
;show msg_6 for user
;mov eax ,4
;mov ebx ,1
;mov ecx ,msg_6
;mov edx ,len_msg_6
;int 80h

;giving file path
;mov eax ,3
;mov ebx ,0
;mov ecx ,input
;mov edx ,len_input
;int 80h

;change directory
;mov eax,12
;mov ebx,input
;mov ecx,len_input
;int 80h


;------------------------------------------------------
;show msg 0
mov eax ,4
mov ebx ,1
mov ecx ,msg_0
mov edx ,len_msg_0
int 80h
;-------------------------------------------------------
;show msg 1
mov eax ,4
mov ebx ,1
mov ecx ,msg_1
mov edx ,len_msg_1
int 80h
;-------------------------------------------------------
;show msg 2
mov eax ,4
mov ebx ,1
mov ecx ,msg_2
mov edx ,len_msg_2
int 80h

;----------------------------------------------------------
;show msg 3
mov eax ,4
mov ebx ,1
mov ecx ,msg_3
mov edx ,len_msg_3
int 80h
;-----------------------------------------------------------
;show msg 4
mov eax ,4
mov ebx ,1
mov ecx ,msg_4
mov edx ,len_msg_4
int 80h
;-------------------------------------------------------------
;show msg 5
mov eax ,4
mov ebx ,1
mov ecx ,msg_5
mov edx ,len_msg_5
int 80h
;--------------------------------------------------------------
mov eax ,4
mov ebx ,1
mov ecx ,msg_7
mov edx ,len_msg_7
int 80h
;---------------------------------------------------------------
;giving user selection
give_select:
  mov eax ,3
  mov ebx ,0
  mov ecx ,select
  mov edx ,len_select
  int 80h

  cmp byte[select],'0'
  je exit
  cmp byte[select],'1'
  je create_file
  cmp byte[select],'2'
  je read_file
  cmp byte[select],'3'
  je write_file
  cmp byte[select],'4'
  je search_file
  cmp byte[select],'5'
  je replace_file
  cmp byte[select],'6'
  je file_information
  jmp give_select

;----------------------------------------------------------------
exit:
  mov eax ,1
  mov ebx ,0
  int 80h
;-----------------;---------------------------------------------------------------------
;-------------------------------------------------
create_file:
  ;creating and openning a sample file in current directory
  mov eax,8
  mov ebx,file_name
  mov ecx,0
  mov edx,777
  int 80h
  mov r10d,ecx
  call operation_done
  jmp give_select

;----------------------------------------------------------------
;openning file
open_file:
  ;call give_file_name
  mov eax,5
  mov ebx,file_name
  mov ecx,02
  int 80h
  mov [fd],eax
  ret

;-----------------------------------------------------------------
read_file:
  call open_file
  mov eax, 19
  mov ebx,[fd]
  mov ecx, 0           ;for read only access
  mov edx, 2            ;SEEK_SET
  int  80h
  mov r12d,eax

  mov eax,19
  mov ebx,[fd]
  mov ecx,0
  mov edx,0
  int 80h


  mov eax,3
  mov ebx,[fd]
  mov ecx,read_buffer
  mov edx,r12d
  int 80h

  mov eax ,4
  mov ebx ,1
  mov ecx ,read_buffer
  mov edx ,r12d
  int 80h



  call operation_done
  jmp give_select


;----------------------------------------------------------------
write_file:
  call open_file
  mov eax,4
  mov ebx,[fd]
  mov ecx,text_to_write
  mov edx,len_text_to_write
  int 80h
  call operation_done
  jmp give_select



;----------------------------------------------------------------
search_file:

;----------------------------------------------------------------
replace_file:


;----------------------------------------------------------------
file_information:


;------------------------------------------------------------------
operation_done:
  mov eax ,4
  mov ebx ,1
  mov ecx ,msg_done
  mov edx ,len_msg_done
  int 80h
  ret
;-------------------------------------------------------------------


;--------------------------------------------------------------------
;closing the file
close_file:
  mov eax,6
  mov ebx,[fd]
  int 80h
