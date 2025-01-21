;; Anomaly NFT Contract

(define-non-fungible-token anomaly uint)

(define-data-var last-token-id uint u0)

(define-map token-metadata uint {
  name: (string-ascii 100),
  description: (string-utf8 500),
  coordinates: (string-ascii 100),
  classification: (string-ascii 50),
  discovery-date: uint,
  rarity-score: uint
})

(define-public (mint-anomaly (name (string-ascii 100)) (description (string-utf8 500)) (coordinates (string-ascii 100)) (classification (string-ascii 50)) (rarity-score uint))
  (let
    ((token-id (+ (var-get last-token-id) u1)))
    (try! (nft-mint? anomaly token-id tx-sender))
    (map-set token-metadata token-id {
      name: name,
      description: description,
      coordinates: coordinates,
      classification: classification,
      discovery-date: block-height,
      rarity-score: rarity-score
    })
    (var-set last-token-id token-id)
    (ok token-id)
  )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (nft-transfer? anomaly token-id sender recipient)
)

(define-read-only (get-token-metadata (token-id uint))
  (map-get? token-metadata token-id)
)

(define-read-only (get-last-token-id)
  (var-get last-token-id)
)
