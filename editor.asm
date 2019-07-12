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
msg_9     dd   'enter word to search',10
len_msg_9 equ   $-msg_9
msg_nfound dd  'word not found',10
len_nfound equ $-msg_nfound
position dd  5
len_position equ $-position

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
word_number resd  1
len_word_number  equ $-word_number


;macro for change position of file pointer
%macro change_position 1
mov eax,19
mov ebx,[fd]
mov ecx,%1
mov edx,0
int 80h
%endmacro



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
;first reading file
;detect file size
  ;call open_file
  ;mov eax, 19
  ;mov ebx,[fd]
  ;mov ecx, 0           ;for read only access
  ;mov edx, 2            ;SEEK_SET
  ;int  80h
  ;mov r12d,eax

  ;mov eax,19
  ;mov ebx,[fd]
  ;mov ecx,0
  ;mov edx,0
  ;int 80h

  ;mov eax,3
  ;mov ebx,[fd]
  ;mov ecx,read_buffer
  ;mov edx,r12d
  ;int 80h


;show msg for enter word to search
  ;mov eax ,4
  ;mov ebx ,1
  ;mov ecx ,msg_9
  ;mov edx ,len_msg_9
  ;int 80h
;giving input
  ;mov eax ,3
  ;mov ebx ,0
  ;mov ecx ,input
  ;mov edx ,len_input
  ;int 80h
  ;mov r13d,eax
  ;dec r13d   ;size of input

  ;xor edx,edx
  ;xor ecx,ecx
  ;mov esi,read_buffer
;  mov ecx,r13d

;  lp:  ;find first char of input in file
;    mov dl,byte[esi]
;    cmp dl,byte[input]
;    je while
;    inc esi
;    cmp esi,r12d
;    jbe lp
;    call not_found
;    jmp give_select

;while:






;call operation_done
;jmp give_select

;----------------------------------------------------------------
replace_file:
call open_file
;give position from user
;give position from user require parsing string to integer!
;mov eax ,3
;mov ebx ,0
;mov ecx ,position
;mov edx ,len_position
;int 80h

change_position [position]
;write to file
mov eax,4
mov ebx,[fd]
mov ecx,text_to_write
mov edx,len_text_to_write
int 80h
jmp read_file
;call operation_done
;jmp give_select



;----------------------------------------------------------------
file_information:
  call open_file
  ;reading file
  mov eax, 19
  mov ebx,[fd]
  mov ecx, 0           ;for read only access
  mov edx, 2            ;SEEK_SET
  int  80h
  mov r12d,eax  ;size of file

  mov eax,19   ;return file descriptor to first of file
  mov ebx,[fd]
  mov ecx,0
  mov edx,0
  int 80h

  mov eax,3
  mov ebx,[fd]
  mov ecx,read_buffer
  mov edx,r12d
  int 80h
  ;jmp words
  jmp count_letters
  call operation_done
  call give_select

;------------------------------------------------------------------
operation_done:
  mov eax ,4
  mov ebx ,1
  mov ecx ,msg_done
  mov edx ,len_msg_done
  int 80h
  ret
;-------------------------------------------------------------------
not_found:
  mov eax ,4
  mov ebx ,1
  mov ecx ,msg_nfound
  mov edx ,len_nfound
  int 80h
  ret
;--------------------------------------------------------------------
words:
xor ecx,ecx
xor r9,r9
mov r9d,1
mov esi,read_buffer
count_words:
  inc ecx
  mov dl,32   ;sapce ascii code
  cmp dl,[esi]
  je space
  inc esi
  cmp ecx,r12d
  jbe count_words
  jmp exit
  ;ret

space:
  inc r9d
  inc esi
  ;inc ecx
  cmp ecx,r12d
  jbe count_words

;print:                  ;has bug
  ;mov [word_number],r9d
  ;mov ax,[word_number]
  ;mov eax ,4
  ;mov ebx ,1
  ;mov ecx ,word_number
  ;mov edx ,2
  ;int 80h

;--------------------------------------------------------------------
count_letters:
  xor r8,r8
  xor r15,r15
  mov esi,read_buffer
  xor ecx, ecx
count_capital_letters:
  inc ecx
  cmp ecx,r12d
  ja count
  mov dl,[esi]
  cmp dl,41h  ;41h ----> A
  jb next_2
  cmp dl,5Ah  ;5Ah----->Z
  ja next_2
  jmp plus_capital

count:
mov esi,read_buffer
xor ecx,ecx
count_samll_letters:
  inc ecx
  cmp ecx,r12d
  ja exit
  mov dl,[esi]
  cmp dl,61h   ;61h----->a
  jb next_1
  cmp dl,7Ah   ;7Ah----->z
  ja next_1
  jmp plus_small


plus_capital:
    inc esi
    inc r8
    jmp count_capital_letters

plus_small:
  inc esi
  inc r15
  jmp count_samll_letters

next_1:
inc esi
jmp count_samll_letters

next_2:
inc esi
jmp count_capital_letters
;---------------------------------------------------------------------
;closing the file
close_file:
  mov eax,6
  mov ebx,[fd]
  int 80h
