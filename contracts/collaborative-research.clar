;; Collaborative Research Contract

(define-map research-projects uint {
    title: (string-ascii 100),
    description: (string-utf8 500),
    lead-researcher: principal,
    participants: (list 10 principal),
    status: (string-ascii 20),
    created-at: uint
})

(define-data-var project-counter uint u0)

(define-public (create-research-project (title (string-ascii 100)) (description (string-utf8 500)))
    (let
        ((new-id (+ (var-get project-counter) u1)))
        (map-set research-projects new-id {
            title: title,
            description: description,
            lead-researcher: tx-sender,
            participants: (list tx-sender),
            status: "active",
            created-at: block-height
        })
        (var-set project-counter new-id)
        (ok new-id)
    )
)

(define-public (join-research-project (project-id uint))
    (let
        ((project (unwrap! (map-get? research-projects project-id) (err u404))))
        (ok (map-set research-projects project-id
            (merge project { participants: (unwrap! (as-max-len? (append (get participants project) tx-sender) u10) (err u400)) })))
    )
)

(define-read-only (get-research-project (project-id uint))
    (map-get? research-projects project-id)
)

(define-read-only (get-project-count)
    (var-get project-counter)
)

