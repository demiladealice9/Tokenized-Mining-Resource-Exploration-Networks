;; Investment Coordination Contract
;; Manages exploration investment funding and coordination

(define-constant err-insufficient-funds (err u400))
(define-constant err-investment-not-found (err u401))
(define-constant err-not-investor (err u402))
(define-constant err-funding-complete (err u403))

;; Investment opportunity structure
(define-map investment-opportunities
  { opportunity-id: uint }
  {
    company-id: uint,
    target-amount: uint,
    raised-amount: uint,
    min-investment: uint,
    deadline: uint,
    active: bool,
    description: (string-ascii 200)
  }
)

;; Individual investments
(define-map investments
  { opportunity-id: uint, investor: principal }
  { amount: uint, investment-date: uint }
)

;; Investor balances
(define-map investor-balances
  { investor: principal }
  { balance: uint }
)

(define-data-var next-opportunity-id uint u1)

;; Create investment opportunity
(define-public (create-investment-opportunity
  (company-id uint)
  (target-amount uint)
  (min-investment uint)
  (deadline uint)
  (description (string-ascii 200))
)
  (let
    (
      (opportunity-id (var-get next-opportunity-id))
    )
    (map-set investment-opportunities
      { opportunity-id: opportunity-id }
      {
        company-id: company-id,
        target-amount: target-amount,
        raised-amount: u0,
        min-investment: min-investment,
        deadline: deadline,
        active: true,
        description: description
      }
    )

    (var-set next-opportunity-id (+ opportunity-id u1))
    (ok opportunity-id)
  )
)

;; Invest in opportunity
(define-public (invest (opportunity-id uint) (amount uint))
  (let
    (
      (caller tx-sender)
      (current-balance (default-to u0 (get balance (map-get? investor-balances { investor: caller }))))
    )
    (asserts! (>= current-balance amount) err-insufficient-funds)

    (match (map-get? investment-opportunities { opportunity-id: opportunity-id })
      opportunity-data
      (let
        (
          (new-raised (+ (get raised-amount opportunity-data) amount))
          (existing-investment (default-to u0 (get amount (map-get? investments { opportunity-id: opportunity-id, investor: caller }))))
        )
        (asserts! (get active opportunity-data) err-funding-complete)
        (asserts! (>= amount (get min-investment opportunity-data)) err-insufficient-funds)

        ;; Update opportunity
        (map-set investment-opportunities
          { opportunity-id: opportunity-id }
          (merge opportunity-data { raised-amount: new-raised })
        )

        ;; Update investment
        (map-set investments
          { opportunity-id: opportunity-id, investor: caller }
          { amount: (+ existing-investment amount), investment-date: block-height }
        )

        ;; Update investor balance
        (map-set investor-balances
          { investor: caller }
          { balance: (- current-balance amount) }
        )

        (ok true)
      )
      err-investment-not-found
    )
  )
)

;; Deposit funds for investment
(define-public (deposit-funds (amount uint))
  (let
    (
      (caller tx-sender)
      (current-balance (default-to u0 (get balance (map-get? investor-balances { investor: caller }))))
    )
    (map-set investor-balances
      { investor: caller }
      { balance: (+ current-balance amount) }
    )
    (ok true)
  )
)

;; Get investment opportunity
(define-read-only (get-investment-opportunity (opportunity-id uint))
  (map-get? investment-opportunities { opportunity-id: opportunity-id })
)

;; Get investor balance
(define-read-only (get-investor-balance (investor principal))
  (default-to u0 (get balance (map-get? investor-balances { investor: investor })))
)

;; Get investment amount
(define-read-only (get-investment (opportunity-id uint) (investor principal))
  (map-get? investments { opportunity-id: opportunity-id, investor: investor })
)
