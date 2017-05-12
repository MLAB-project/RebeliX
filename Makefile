STL_DIR=STL
IMG_DIR=images
SRC_DIR=src
PLATE_DIMMENSIONS=120
SIMARRANGE=/usr/local/bin/simarrange
STLSORT=stlsort
OPENSCAD_APP=openscad

SOURCES=$(wildcard $(SRC_DIR)/*.scad) $(wildcard $(SRC_DIR)/Source_cover/*.scad) $(wildcard $(SRC_DIR)/Extruder_filament_1.75mm/*.scad)
TARGETS=$(patsubst $(SRC_DIR)/%.scad, $(STL_DIR)/%.stl, $(SOURCES))
IMAGES=$(patsubst $(SRC_DIR)/%.scad, $(IMG_DIR)/%.png, $(SOURCES))

all: default images

calibration:
	openscad -m make -o calibration.stl calibration.scad

default: $(TARGETS)

$(STL_DIR)/%.stl: $(SRC_DIR)/%.scad
	$(OPENSCAD_APP) -m make -o $@ $<
	$(STLSORT) $@ || :
	
images: $(IMAGES)

$(IMG_DIR)/%.png: $(SRC_DIR)/%.scad
	$(OPENSCAD_APP) -m make --render -o $@ $<

arrange: default
	 $(SIMARRANGE) -x $(PLATE_DIMMENSIONS) -y $(PLATE_DIMMENSIONS) $(ARRANGE_TARGETS)
	 
clean:
	rm -f calibration.stl
	rm -f $(STL_DIR)/*.stl
	rm -f $(IMG_DIR)/*.png
