#!/usr/bin/env bash
open -a "Google Chrome" http://localhost:9989
sphinx-autobuild -p 9989 -H localhost . _build_html
