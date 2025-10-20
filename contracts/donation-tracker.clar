;; ----------------------------------------------------------------------------------
;; Contract: donation-tracker.clar
;; Author: Your Name
;; Description: Tracks donations and total donated per principal.
;; ----------------------------------------------------------------------------------

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INSUFFICIENT_FUNDS (err u101))

;; Data vars
(define-data-var contract-owner principal tx-sender)
(define-data-var total-donations uint u0)

;; Map of principal => total donated
(define-map donations
  principal
  uint
)

;; ---------------------------------------------------------
;; Allow users to donate STX to contract
;; ---------------------------------------------------------
(define-public (donate (amount uint))
  (begin
    ;; Transfer STX from donor to contract
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))

    ;; Update donor's total donated
    (let (
          (prev (default-to u0 (map-get? donations tx-sender)))
          (new-total (+ prev amount))
         )
      (map-set donations tx-sender new-total)
    )

    ;; Update overall total donations
    (var-set total-donations (+ (var-get total-donations) amount))

    (print { action: "donate", donor: tx-sender, amount: amount })
    (ok true)
  )
)

;; ---------------------------------------------------------
;; Owner can withdraw STX from contract
;; ---------------------------------------------------------
(define-public (withdraw (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)

    (let ((contract-balance (stx-get-balance (as-contract tx-sender))))
      (asserts! (>= contract-balance amount) ERR-INSUFFICIENT_FUNDS)

      (try! (stx-transfer? amount (as-contract tx-sender) recipient))

      (print { action: "withdraw", to: recipient, amount: amount })
      (ok true)
    )
  )
)

;; ---------------------------------------------------------
;; Get total donated by a principal
;; ---------------------------------------------------------
(define-read-only (get-total-donated (donor principal))
  (ok (default-to u0 (map-get? donations donor)))
)

;; ---------------------------------------------------------
;; Get total donations collected by contract
;; ---------------------------------------------------------
(define-read-only (get-total-donations)
  (ok (var-get total-donations))
)
