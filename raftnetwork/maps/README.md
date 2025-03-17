# mapping

* CM's mapping system is finicky, So **maps are put inside the normal map directory**
    * If we wanted to add `sneed.dmm` the path would be `maps/map_files/sneed/sneed.dmm`

## making maps

* CM has a guide which can be found [here](https://cm-ss13.com/wiki/CM13_Mapping_Crash_Course)
* As for actually loading the map, you need to make a config json, and edit `map_config/maps.txt`. 
    * for examples: see `maps/lv522_chances_claim.json` and the corresponding [map pr](https://github.com/cmss13-devs/cmss13/pull/797)

## loading runtime or tr walkway

1. To only load runtime or the treadmill map, create or modify `data\next_map.json`
2. copy and paste the appropriate json below:

#### tr_walkway

```json
{
    "map_name": "tr walkway",
    "map_path": "map_files/TR_walkway",
    "map_file": "tr_walkway.dmm",
"survivor_types": [
        "/datum/equipment_preset/survivor/scientist/lv"
    ],
    "traits": [{"Marine Main Ship": true}],
"disable_ship_map": true
}
```
#### USS Runtime
```json
{
    "map_name": "USS Runtime",
    "map_path": "map_files/USS_Runtime",
    "map_file": "USS_Runtime.dmm",
"survivor_types": [
        "/datum/equipment_preset/survivor/scientist/lv"
    ],
    "traits": [{"Marine Main Ship": true}],
"disable_ship_map": true
}
```
