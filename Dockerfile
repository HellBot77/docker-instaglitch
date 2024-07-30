FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/instaglitch/instaglitch.git && \
    cd instaglitch && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git && \
    sed -i 's/?.width/?.width || 0/' src/components/modals/Properties.tsx && \
    sed -i 's/?.height/?.height || 0/' src/components/modals/Properties.tsx && \
    sed -i 's/?.animated/?.animated || false/' src/components/modals/Properties.tsx

FROM node AS build

WORKDIR /instaglitch
COPY --from=base /git/instaglitch .
RUN yarn && \
    export NODE_ENV=production && \
    yarn build

FROM lipanski/docker-static-website

COPY --from=build /instaglitch/build .
