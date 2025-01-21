;; Anomaly NFT Contract

(define-non-fungible-token anomaly-nft uint)

(define-data-var last-token-id uint u0)

(define-map token-metadata uint {
    name: (string-ascii 100),
    description: (string-utf8 500),
    image-url: (optional (string-ascii 256)),
    discoverer: principal,
    coordinates: (string-ascii 50),
    discovery-date: uint
})

(define-public (mint-anomaly-nft (name (string-ascii 100)) (description (string-utf8 500)) (image-url (optional (string-ascii 256))) (coordinates (string-ascii 50)))
    (let
        ((token-id (+ (var-get last-token-id) u1)))
        (try! (nft-mint? anomaly-nft token-id tx-sender))
        (map-set token-metadata token-id {
            name: name,
            description: description,
            image-url: image-url,
            discoverer: tx-sender,
            coordinates: coordinates,
            discovery-date: block-height
        })
        (var-set last-token-id token-id)
        (ok token-id)
    )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (nft-transfer? anomaly-nft token-id sender recipient)
)

(define-read-only (get-token-metadata (token-id uint))
    (map-get? token-metadata token-id)
)

(define-read-only (get-last-token-id)
    (var-get last-token-id)
)
