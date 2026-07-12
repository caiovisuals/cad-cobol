       IDENTIFICATION DIVISION.
       PROGRAM-ID. REGISTER.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NAME.
           05 WS-NAME-TXT   PIC X(30).
       01 WS-AGE            PIC 99.

       01 WS-EMAIL.
           05 WS-EMAIL-TXT  PIC X(50).

       01 WS-CPF            PIC X(11).

       PROCEDURE DIVISION.
       MAIN.
           DISPLAY "=== CADASTRO ===".
           DISPLAY "Digite o nome: ".
           ACCEPT WS-NAME-TXT.

           DISPLAY "Digite a idade: ".
           ACCEPT WS-AGE.

           DISPLAY "Digite seu e-mail: ".
           ACCEPT WS-EMAIL-TXT.

           DISPLAY "Digite seu CPF: ".
           ACCEPT WS-CPF.

           DISPLAY " ".
           DISPLAY "=== DADOS INFORMADOS ===".
           DISPLAY "Nome: " WS-NAME-TXT.
           DISPLAY "Idade: " WS-AGE.
           DISPLAY "E-MAIL: " WS-EMAIL-TXT.
           DISPLAY "CPF: " WS-CPF-TXT.

           DISPLAY " ".
           DISPLAY "CADASTRO FINALIZADO.".
           STOP RUN.
