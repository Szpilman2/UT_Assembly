section .data
  picture dd '/home/peyman/Desktop/my_image.bmp'
  new_pic dd '/home/peyman/Desktop/my_new_image.bmp'


section .bss
read resb  300000
fd_in resb 1
new_fd resb 1
store_data resb 261000

section .text
  global _start
_start:

;open image
  mov eax , 5
  mov ebx, picture
  mov ecx,2
  int 80h

  mov [fd_in],eax  ;storing file descriptor in fd_in

;------------------

;change offset
 mov eax, 19
 mov ebx,[fd_in]
 mov ecx, 0           ;for read only access
 mov edx, 2            ;SEEK_SET
 int  80h

 mov r12d,eax
;-------------------------------------
mov eax,19
mov ebx,[fd_in]
mov ecx,0
mov edx,0
int 80h



 ;-------------------------------
 ;read file
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, read
   mov edx, r12d
   int 80h


  ;program logic
;  mov ecx,261000
;  mov esi,read
;  mov edi,store_data
;  add esi,1000
;  xor edx,edx
;  store:
;    mov al,byte[esi+edx]
    ;add eax,12h
;    mov byte[edi+edx],al
;    inc edx
;loop store
mov ecx ,1000
doo:
mov al,byte[read+ecx]
add al,12
mov byte[read+ecx],al
;inc ecx
add ecx,4
cmp ecx,r12d
jb doo

     ;print the info
    ;mov eax, 4
    ;mov ebx, 1
    ;mov ecx, store_data
    ;mov edx, 300000
    ;int 80h
;-------------------------------------------------------
;create and open new file for copying values
mov eax,8
mov ebx,new_pic
mov ecx,777
int 80h

mov [new_fd],eax

;-------------------------------------------------------
;writing to the new file
mov eax,4
mov ebx,[new_fd]
mov ecx,read
mov edx,r12d
int 80h


; close the file
  mov eax, 6
  mov ebx, [new_fd]
  int  80h



exit:
  mov eax, 1
  mov ebx, 0
  int 80h
