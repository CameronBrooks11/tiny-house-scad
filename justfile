# Build the house at four sizes and check the framing
test:
    python3 tests/test_tiny.py

# Everything CI runs, bar the tests
check: fmt-check

# Format the .scad sources with topiary (.topiary/languages.ncl)
fmt:
    git ls-files -z '*.scad' | xargs -0 -r topiary format

# Check the .scad sources are formatted, without changing them
fmt-check:
    git ls-files -z '*.scad' | xargs -0 -r -n1 topiary format --check

# Print the cut list, e.g. just cutlist -D length=192 -D width=90
cutlist *ARGS:
    openscad --export-format echo -o - {{ARGS}} src/house.scad

# Render the README pictures into docs/img/, trimmed to the model (needs ImageMagick)
images:
    mkdir -p docs/img
    openscad --imgsize 2400,1600 --viewall --autocenter --colorscheme Tomorrow --camera 0,0,0,62,0,325,0 -o docs/img/house.png src/house.scad
    openscad --imgsize 2400,1600 --viewall --autocenter --colorscheme Tomorrow --camera 0,0,0,62,0,325,0 -D show_roof_sheathing=false -o docs/img/frame.png src/house.scad
    openscad --imgsize 2400,1600 --viewall --autocenter --colorscheme Tomorrow --camera 0,0,0,90,0,90,0 --projection=ortho -o docs/img/end.png src/house.scad
    openscad --imgsize 2400,1600 --viewall --autocenter --colorscheme Tomorrow --camera 0,0,0,40,0,325,0 -D show_walls=false -D show_roof=false -D show_roof_sheathing=false -D show_subfloor=false -o docs/img/floor.png src/house.scad
    for f in docs/img/house.png docs/img/frame.png docs/img/end.png docs/img/floor.png; do magick "$f" -trim +repage -bordercolor '#f8f8f8' -border 48 "$f"; done
