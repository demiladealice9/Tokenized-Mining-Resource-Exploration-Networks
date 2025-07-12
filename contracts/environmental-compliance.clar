;; Environmental Compliance Contract
;; Ensures exploration environmental compliance and monitoring

(define-constant err-not-authorized (err u500))
(define-constant err-compliance-not-found (err u501))
(define-constant err-invalid-status (err u502))

;; Compliance record structure
(define-map compliance-records
  { record-id: uint }
  {
    company-id: uint,
    data-id: uint,
    compliance-type: (string-ascii 50),
    status: (string-ascii 20),
    assessment-date: uint,
    expiry-date: uint,
    assessor: principal,
    notes: (string-ascii 300)
  }
)

;; Environmental assessors
(define-map environmental-assessors
  { assessor: principal }
  { certified: bool, specialization: (string-ascii 100) }
)

;; Compliance requirements
(define-map compliance-requirements
  { requirement-id: uint }
  {
    name: (string-ascii 100),
    description: (string-ascii 300),
    mandatory: bool,
    validity-period: uint
  }
)

(define-data-var next-record-id uint u1)
(define-data-var next-requirement-id uint u1)

;; Certify environmental assessor
(define-public (certify-environmental-assessor (assessor principal) (specialization (string-ascii 100)))
  (begin
    (map-set environmental-assessors
      { assessor: assessor }
      { certified: true, specialization: specialization }
    )
    (ok true)
  )
)

;; Add compliance requirement
(define-public (add-compliance-requirement
  (name (string-ascii 100))
  (description (string-ascii 300))
  (mandatory bool)
  (validity-period uint)
)
  (let
    (
      (requirement-id (var-get next-requirement-id))
    )
    (map-set compliance-requirements
      { requirement-id: requirement-id }
      {
        name: name,
        description: description,
        mandatory: mandatory,
        validity-period: validity-period
      }
    )

    (var-set next-requirement-id (+ requirement-id u1))
    (ok requirement-id)
  )
)

;; Submit compliance record
(define-public (submit-compliance-record
  (company-id uint)
  (data-id uint)
  (compliance-type (string-ascii 50))
  (status (string-ascii 20))
  (expiry-date uint)
  (notes (string-ascii 300))
)
  (let
    (
      (record-id (var-get next-record-id))
      (caller tx-sender)
    )
    ;; Check if caller is certified environmental assessor
    (asserts! (default-to false (get certified (map-get? environmental-assessors { assessor: caller }))) err-not-authorized)

    (map-set compliance-records
      { record-id: record-id }
      {
        company-id: company-id,
        data-id: data-id,
        compliance-type: compliance-type,
        status: status,
        assessment-date: block-height,
        expiry-date: expiry-date,
        assessor: caller,
        notes: notes
      }
    )

    (var-set next-record-id (+ record-id u1))
    (ok record-id)
  )
)

;; Get compliance record
(define-read-only (get-compliance-record (record-id uint))
  (map-get? compliance-records { record-id: record-id })
)

;; Check if assessor is certified
(define-read-only (is-environmental-assessor-certified (assessor principal))
  (default-to false (get certified (map-get? environmental-assessors { assessor: assessor })))
)

;; Get compliance requirement
(define-read-only (get-compliance-requirement (requirement-id uint))
  (map-get? compliance-requirements { requirement-id: requirement-id })
)

;; Update compliance status
(define-public (update-compliance-status (record-id uint) (new-status (string-ascii 20)))
  (let
    (
      (caller tx-sender)
    )
    (asserts! (default-to false (get certified (map-get? environmental-assessors { assessor: caller }))) err-not-authorized)

    (match (map-get? compliance-records { record-id: record-id })
      record-data
      (begin
        (map-set compliance-records
          { record-id: record-id }
          (merge record-data { status: new-status, assessment-date: block-height })
        )
        (ok true)
      )
      err-compliance-not-found
    )
  )
)
