;; Anomaly Reporting Contract

(define-data-var anomaly-counter uint u0)

(define-map anomalies uint {
    reporter: principal,
    coordinates: (string-ascii 50),
    description: (string-utf8 500),
    timestamp: uint,
    status: (string-ascii 20)
})

(define-public (report-anomaly (coordinates (string-ascii 50)) (description (string-utf8 500)))
    (let
        ((new-id (+ (var-get anomaly-counter) u1)))
        (map-set anomalies new-id {
            reporter: tx-sender,
            coordinates: coordinates,
            description: description,
            timestamp: block-height,
            status: "reported"
        })
        (var-set anomaly-counter new-id)
        (ok new-id)
    )
)

(define-read-only (get-anomaly (anomaly-id uint))
    (map-get? anomalies anomaly-id)
)

(define-read-only (get-anomaly-count)
    (var-get anomaly-counter)
)
