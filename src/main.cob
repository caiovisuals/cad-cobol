       IDENTIFICATION DIVISION.
       PROGRAM-ID. REGISTER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ARQ-REG ASSIGN TO "data/records.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FS.

       DATA DIVISION.
       FILE SECTION.
       FD  ARQ-REG.
       01  REG-CAD.

       WORKING-STORAGE SECTION.
       01 WS-NAME.
           05 WS-NAME-TXT   PIC X(30).
       01 WS-AGE            PIC 99.

       01 WS-EMAIL.
           05 WS-EMAIL-TXT  PIC X(50).

       01 WS-CPF            PIC X(11).

       PROCEDURE DIVISION.
       PRINCIPAL.
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
       CREATE-REG.
           DISPLAY " "
           DISPLAY "=== CADASTRAR PESSOA ==="
           IF WS-QTD >= WS-MAX-REG
               DISPLAY ">> Limite de registros atingido."
               PERFORM PAUSE
               EXIT PARAGRAPH
           END-IF

           PERFORM READ-NAME
           IF WS-NAME (WS-QTD + 1) = SPACES
               DISPLAY ">> Nome invalido. Cadastro cancelado."
               PERFORM PAUSE
               EXIT PARAGRAPH
           END-IF

           PERFORM READ-AGE
           IF WS-AGE-NUM = 0
               DISPLAY ">> Idade invalida. Cadastro cancelado."
               PERFORM PAUSE
               EXIT PARAGRAPH
           END-IF

           PERFORM READ-EMAIL
           IF WS-AT-POS = 0
               DISPLAY ">> E-mail invalido (sem '@'). Cancelado."
               PERFORM PAUSE
               EXIT PARAGRAPH
           END-IF

           PERFORM READ-CPF
           IF WS-CPF (WS-QTD + 1) = SPACES
               DISPLAY ">> CPF invalido. Cadastro cancelado."
               PERFORM PAUSE
               EXIT PARAGRAPH
           END-IF

           ADD 1 TO WS-QTD
           MOVE WS-AGE-NUM TO WS-AGE (WS-QTD)
           PERFORM SAVE-FILE
           DISPLAY " "
           DISPLAY ">> Cadastro realizado com sucesso!"
           PERFORM PAUSE.
       SEARCH-REG.
           DISPLAY " "
           DISPLAY "=== BUSCAR POR CPF ==="
           DISPLAY "CPF: " WITH NO ADVANCING
           ACCEPT WS-SEARCH-CPF
           SET NOT-FOUND TO TRUE
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-QTD
               IF WS-CPF (WS-I) = WS-SEARCH-CPF
                   SET FOUND TO TRUE
                   DISPLAY " "
                   DISPLAY ">> Registro encontrado:"
                   DISPLAY "  Nome : " WS-NAME (WS-I)
                   DISPLAY "  Idade: " WS-AGE (WS-I)
                   DISPLAY "  Email: " WS-EMAIL (WS-I)
                   DISPLAY "  CPF  : " WS-CPF (WS-I)
               END-IF
           END-PERFORM
           IF NOT-FOUND
               DISPLAY ">> Nenhum registro com esse CPF encontrado."
           END-IF
           PERFORM PAUSE.
       DELETE-REG.
           DISPLAY " "
           DISPLAY "=== EXCLUIR POR CPF ==="
           DISPLAY "CPF: " WITH NO ADVANCING
           ACCEPT WS-SEARCH-CPF
           SET NOT-FOUND TO TRUE
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-QTD
               IF WS-CPF (WS-I) = WS-SEARCH-CPF
                   SET FOUND TO TRUE
                   DISPLAY " "
                   DISPLAY ">> Encontrado: " WS-NAME (WS-I)
                   DISPLAY "Confirma exclusao? (S/N): "
                       WITH NO ADVANCING
                   ACCEPT WS-CONFIRM
                   IF WS-CONFIRM = "S" OR WS-CONFIRM = "s"
                       PERFORM VARYING WS-J FROM WS-I BY 1
                               UNTIL WS-J >= WS-QTD
                           MOVE WS-REG (WS-J + 1) TO WS-REG (WS-J)
                       END-PERFORM
                       SUBTRACT 1 FROM WS-QTD
                       PERFORM SAVE-FILE
                       DISPLAY ">> Registro excluido com sucesso!"
                   ELSE
                       DISPLAY ">> Exclusao cancelada."
                   END-IF
                   EXIT PERFORM
               END-IF
           END-PERFORM
           IF NOT-FOUND
               DISPLAY ">> Nenhum registro com esse CPF."
           END-IF
           PERFORM PAUSE.
       LOAD-FILE.
           MOVE 0 TO WS-QTD
           OPEN INPUT ARQ-REG
           IF FS-OK
               PERFORM UNTIL FS-EOF
                   READ ARQ-REG
                   END-READ
               END-PERFORM
               CLOSE ARQ-REG
           END-IF.
       SAVE-FILE.
           OPEN OUTPUT ARQ-REG
           IF FS-OK
               PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-QTD
                   WRITE REG-CAD
               END-PERFORM
               CLOSE ARQ-REG
           ELSE
               DISPLAY ">> Erro ao salvar arquivo (status " WS-FS ")."
           END-IF.
       PAUSE.
           DISPLAY " "
           DISPLAY "Pressione ENTER para continuar..."
               WITH NO ADVANCING
           ACCEPT WS-CONTINUE.
