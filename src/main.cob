       IDENTIFICATION DIVISION.
       PROGRAM-ID. REGISTER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT REG-FILE ASSIGN TO "data/records.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FS.

       DATA DIVISION.
       FILE SECTION.
       FD  REG-FILE.
       01  FILE-RECORD.
           05  FILE-NAME     PIC X(30).
           05  FILE-AGE      PIC 9(3).
           05  FILE-EMAIL    PIC X(50).
           05  FILE-CPF      PIC X(11).

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
           IF WS-COUNT >= WS-MAX-REG
               DISPLAY ">> Limite de registros atingido."
               PERFORM PAUSE
               EXIT PARAGRAPH
           END-IF

           PERFORM READ-NAME
           IF WS-NAME (WS-COUNT + 1) = SPACES
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
           IF WS-CPF (WS-COUNT + 1) = SPACES
               DISPLAY ">> CPF invalido. Cadastro cancelado."
               PERFORM PAUSE
               EXIT PARAGRAPH
           END-IF

           ADD 1 TO WS-COUNT
           MOVE WS-AGE-NUM TO WS-AGE (WS-COUNT)
           PERFORM SAVE-FILE
           DISPLAY " "
           DISPLAY ">> Cadastro realizado com sucesso!"
           PERFORM PAUSE.
       LIST-REG.
           DISPLAY " "
           DISPLAY "=== LISTA DE CADASTROS ==="
           IF WS-COUNT = 0
               DISPLAY ">> Nenhum registro cadastrado."
           ELSE
               PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-COUNT
                   DISPLAY " "
                   DISPLAY "Registro #" WS-I
                   DISPLAY "  Nome : " WS-REC-NAME  (WS-I)
                   DISPLAY "  Idade: " WS-REC-AGE   (WS-I)
                   DISPLAY "  Email: " WS-REC-EMAIL (WS-I)
                   DISPLAY "  CPF  : " WS-REC-CPF   (WS-I)
               END-PERFORM
           END-IF
           PERFORM PAUSE.
       SEARCH-REG.
           DISPLAY " "
           DISPLAY "=== BUSCAR POR CPF ==="
           DISPLAY "CPF: " WITH NO ADVANCING
           ACCEPT WS-SEARCH-CPF
           SET NOT-FOUND TO TRUE
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-COUNT
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
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-COUNT
               IF WS-CPF (WS-I) = WS-SEARCH-CPF
                   SET FOUND TO TRUE
                   DISPLAY " "
                   DISPLAY ">> Encontrado: " WS-NAME (WS-I)
                   DISPLAY "Confirma exclusao? (S/N): "
                       WITH NO ADVANCING
                   ACCEPT WS-CONFIRM
                   IF WS-CONFIRM = "S" OR WS-CONFIRM = "s"
                       PERFORM VARYING WS-J FROM WS-I BY 1
                               UNTIL WS-J >= WS-COUNT
                           MOVE WS-REG (WS-J + 1) TO WS-REG (WS-J)
                       END-PERFORM
                       SUBTRACT 1 FROM WS-COUNT
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
       READ-NAME.
           DISPLAY "Digite o nome: " WITH NO ADVANCING
           ACCEPT WS-INPUT-NAME.

       READ-AGE.
           DISPLAY "Digite a idade: " WITH NO ADVANCING
           ACCEPT WS-INPUT-AGE-TXT
           IF WS-INPUT-AGE-TXT IS NUMERIC
               MOVE WS-INPUT-AGE-TXT TO WS-INPUT-AGE
           ELSE
               MOVE 0 TO WS-INPUT-AGE
           END-IF.

       READ-EMAIL.
           DISPLAY "Digite o e-mail: " WITH NO ADVANCING
           ACCEPT WS-INPUT-EMAIL
           MOVE 0 TO WS-AT-POS
           INSPECT WS-INPUT-EMAIL
               TALLYING WS-AT-POS FOR ALL "@".

       READ-CPF.
           DISPLAY "Digite o CPF (11 digitos): " WITH NO ADVANCING
           ACCEPT WS-INPUT-CPF.
       LOAD-FILE.
           MOVE 0 TO WS-COUNT
           OPEN INPUT REG-FILE
           IF FS-OK
               PERFORM UNTIL FS-EOF
                   READ REG-FILE
                       AT END
                           CONTINUE
                       NOT AT END
                           ADD 1 TO WS-COUNT
                           MOVE FILE-NAME  TO WS-REC-NAME  (WS-COUNT)
                           MOVE FILE-AGE   TO WS-REC-AGE   (WS-COUNT)
                           MOVE FILE-EMAIL TO WS-REC-EMAIL (WS-COUNT)
                           MOVE FILE-CPF   TO WS-REC-CPF   (WS-COUNT)
                   END-READ
               END-PERFORM
               CLOSE REG-FILE
           END-IF.
       SAVE-FILE.
           OPEN OUTPUT REG-FILE
           IF FS-OK
               PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-COUNT
                   WRITE FILE-RECORD
               END-PERFORM
               CLOSE REG-FILE
           ELSE
               DISPLAY ">> Erro ao salvar arquivo (status " WS-FS ")."
           END-IF.
       PAUSE.
           DISPLAY " "
           DISPLAY "Pressione ENTER para continuar..."
               WITH NO ADVANCING
           ACCEPT WS-CONTINUE.
