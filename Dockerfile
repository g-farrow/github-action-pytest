FROM python:3-alpine

LABEL name="github-action-pytest"
LABEL repository="https://github.com/g-farrow/github-action-pytest"
LABEL homepage="https://github.com/g-farrow/github-action-pytest"

LABEL "com.github.actions.name"="github-action-pytest"
LABEL "com.github.actions.description"="Run PyTest tests"
LABEL "com.github.actions.icon"="check-circle"
LABEL "com.github.actions.color"="green"

RUN apk add --no-cache bash

RUN pip install -U pytest
RUN pytest --version

COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
