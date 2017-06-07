.stack 64h
 include 'emu8086.inc'
.data 
   
  cadena1 db 50 dup(' '),'$'; llena las cadenas con espacio
  
  msj1 db 'El numero de palabras es:$'
  msj2 db 'Ingrese una cadena:$'  
  msj3 db 'La cantidad de numeros es:$'    
  msj4 db 'La cantidad de letras es:$'
  
  palabra db ?
  contNum db ?
  contLetra db ?, ?, ? 
  
 
  
.code   
       
.startup    

main proc
    call vector
    aqui:
    menu
    ret
main endp

menu macro
     regre:
     printn "";estetica para imprimir
     printn "1) Calcule el numero de palabras"
     printn "2) Calcule la cantidad de numeros"
     printn "3) Calcule la cantidad de letras que aparecen"
     printn "9) Salir"
     print "Opcion: "
     call scan_num  
     printn ""
     cmp cx, 1
     je call case1

     cmp cx, 2
     je call case2 
     
     cmp cx,3
     je call case3
     
     cmp cx, 9
     je call fin
     ret            
endm    

vector proc
   call inicio
   call llenado 

   ret
vector endp 

inicio proc
     mov ah,06h         ; peticion de recorrido de la pantalla
     mov al,00h         ; indica la pantalla completa
     mov bh,17h         ; attributos de color y fondo 7 blanco 0 negro    
     mov cx,0000h       ; esquina superior izquierda renglon columna
     mov dx,184fh       ; esquina inferior derecha renglon columna
     int 10h            ; llamada a la interrupcion de video BIOS
    
     mov ah,02
     mov dx,0402h
     mov bh,00
     int 10h
    
     mov ah,09 ;    Escribir cadena
     mov dx,offset msj2
     int 21h
    
     mov bx,0000h
     lea SI,cadena1 ; llena a SI con la direccion del primer caracter de  la cadena1
     mov cx,50      ; inicio el registro del contador en 10 
     
     ret 
inicio endp
                                                                                                                                        
llenado proc   
    regresa:
        mov ah,07h ; Recoje por teclado un carater y lo coloca en AL sin eco
        int 21h    ; ejecuta la funcion del DOS    
        cmp al,13  ; Compara al con enter
        je aqui ; salta solo si la tecla oprimida es enter
        mov [SI],al; copia el contenido de AL en el registro cuya direccion es igual al contenido de SI
        inc SI     ; Incrementa en 1 el contenido de SI
        inc bx     ;contador de palabra 
        
        call palabras
        sigue:     
        
        call numeros
        sigue1:
        
        call letrasMa
        sigue2:    
        
        call letrasMi
        sigue3:
        
        mov bl, palabra[0] 
       
        mov dl,al  ; compia el contenido de dl en al 
        mov ah,02h ; Funcion de mostrar por pantalla el contenido de dl 
        int 21h    ; ejecuta la funcion del DOS   
        add dh, contLetra[0] 
        add dh, contLetra[1] 
        mov contLetra[2], dh
        mov dh, 0       
        
        loop regresa ; En contenido de CX disminuye en 1 y salta a regresa  
    
    ret
llenado endp
   
fin proc
     printn ""
     printn ""
     printn "Presionar teclar para salir"
     mov ah, 0h
     int 16h
     mov ax, 4c00h
     int 21h
     ret 
         
fin endp

palabras proc ;separa las palabras para contarlas
    cmp al, 32 
    jne sigue     
    add palabra[0], 1
    ret
palabras endp

numeros proc
    cmp al, 48 
    jb sigue1  
    cmp al, 57
    ja sigue1    
    add contNum[0], 1
    ret
numeros endp

letrasMa proc
    cmp al, 65
    jb sigue2
    cmp al, 90
    ja sigue2       
    add contLetra[0],1
    ret
letrasMa endp

letrasMi proc
    cmp al, 97
    jb sigue3
    cmp al, 122
    ja sigue3       
    add contLetra[1],1
    ret
letrasMi endp

limpiar proc
    MOV AX,0600H ; Peticion para limpiar pantalla  
    mov bh,17h 
    ;MOV BH,89H ; Color de letra ==9 "Azul Claro"
    ; Fondo ==8 "Gris"
    MOV CX,0000H ; Se posiciona el cursor en Ren=0 Col=0
    MOV DX,184FH ; Cursor al final de la pantalla Ren=24(18) 
    ; Col=79(4F)
    INT 10H ; INTERRUPCION AL BIOS
    ;------------------------------------------------------------------------------
    MOV AH,02H ; Peticion para colocar el cursor
    MOV BH,00 ; Nunmero de pagina a imprimir
    MOV DH,05 ; Cursor en el renglon 05
    MOV DL,05 ; Cursor en la columna 05
    INT 10H ; Interrupcion al bios
    ;-----------------------------      
    ret
limpiar endp 

;contador de numeros

case1 proc    
    
     call limpiar      
     mov bl, palabra[0]
     add bl,1
     
     mov al,bl
     and ax,000fh
     and bx,00f0h
     shr bx,01
     mov ah,bl
     cmp al,0ah
     jb dejar
     daa
     inc ah
     
     dejar:
     mov bl,al
     mov al,ah
     cmp al,0ah
     jb decena
     daa
     mov dx,31h
     
     decena:
     mov bh,al
     and bx,0f0fh
     or bx,3030h
     mov cx,bx
            
     mov ah,02
     mov dx,0702h
     mov bh,00
     int 10h
    
     mov ah,09 ;    Escribir cadena
     mov dx,offset msj1
     int 21h
     
     mov ah,02
     mov dx,071eh
     mov bh,00
     int 10h
     
     mov dl,ch
     mov dh,cl
     
     mov ah,02
     mov cx,01
     int 21h
     mov ch,dh
     mov dl,ch
     int 21h 
     
     jmp regre
     ret
case1 endp   

case2 proc 
    call limpiar   
     
    mov bl, contNum[0]
    
     mov al,bl
     and ax,000fh
     and bx,00f0h
     shr bx,01
     mov ah,bl
     cmp al,0ah
     jb dejar1
     daa
     inc ah
     
     dejar1:
     mov bl,al
     mov al,ah
     cmp al,0ah
     jb decena1
     daa
     mov dx,31h
     
     decena1:
     mov bh,al
     and bx,0f0fh
     or bx,3030h
     mov cx,bx
            
     mov ah,02
     mov dx,0702h
     mov bh,00
     int 10h
    
     mov ah,09 ;    Escribir cadena
     mov dx,offset msj3
     int 21h
     
     mov ah,02
     mov dx,071eh
     mov bh,00
     int 10h
     
     mov dl,ch
     mov dh,cl
     
     mov ah,02
     mov cx,01
     int 21h
     mov ch,dh
     mov dl,ch
     int 21h 
     
    jmp regre
    ret
case2 endp    

case3 proc  
     call limpiar   
     
     mov bl, contLetra[2]
    
     mov al,bl
     and ax,000fh
     and bx,00f0h
     shr bx,01
     mov ah,bl
     cmp al,0ah
     jb dejar1
     daa
     inc ah
     
     dejar3:
     mov bl,al
     mov al,ah
     cmp al,0ah
     jb decena3
     daa
     mov dx,31h
     
     decena3:
     mov bh,al
     and bx,0f0fh
     or bx,3030h
     mov cx,bx
            
     mov ah,02
     mov dx,0702h
     mov bh,00
     int 10h
    
     mov ah,09 ;    Escribir cadena
     mov dx,offset msj4 ;cantidad de letras
     int 21h
     
     mov ah,02
     mov dx,071eh
     mov bh,00
     int 10h
     
     mov dl,ch
     mov dh,cl
     
     mov ah,02
     mov cx,01
     int 21h
     mov ch,dh
     mov dl,ch
     int 21h 
     
    jmp regre
    
    ret
case3 endp                
        
DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS  ; required for print_num.
DEFINE_PTHIS      
end
