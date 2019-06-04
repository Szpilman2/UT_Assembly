section .data
  picture db "my_image.bmp"


section .bss
read resb  300000
fd_in resb 1
store_data resb 300000

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
 ;mov eax, 19
 ;mov ebx,r10d
 ;mov ecx, 0           ;for read only access
 ;mov edx, 2            ;SEEK_SET
 ;int  80h

 ;mov r12d,eax
 ;-------------------------------
 ;read file
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, read
   mov edx, 300000
   int 80h

   ; close the file
  ;  mov eax, 6
  ;  mov ebx, [fd_in]
  ;  int  80h
  ;program logic
  mov ecx,261000
  mov esi,read
  mov edi,store_data
  add esi,2
  xor edx,edx
  store:
    mov eax,[esi+edx]
    add eax,12h
    mov [edi+edx],eax
    inc edx
loop store

     ;print the info
    mov eax, 4
    mov ebx, 1
    mov ecx, store_data
    mov edx, 300000
    int 80h


exit:
  mov eax, 1
  mov ebx, 0
  int 80h
