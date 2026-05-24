# build
FROM --platform=$BUILDPLATFORM golang:1.26-trixie AS build

WORKDIR /src
ARG TARGETOS
ARG TARGETARCH
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=bind,source=. \
    GOOS=$TARGETOS GOARCH=$TARGETARCH OUTDIR=/out ./hack/binary.sh

# binary
FROM scratch AS binary
COPY --from=build /out/* /

# runtime
FROM gcr.io/distroless/static-debian13:nonroot AS runtime
COPY --from=build /out/CHANGEME /usr/bin/CHANGEME
ENTRYPOINT ["/usr/bin/CHANGEME"]
