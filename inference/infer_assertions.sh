#!/usr/bin bash

# gzip -cd `$HOME`/package/opencs.ttl.gz opencs.ttl
# cp opencs.ttl opencs2.ttl

# sed -i '/owl:imports <https:\/\/w3id.org\/ocs\/schema\//d' opencs2.ttl;

# java -jar robot.jar merge --input package/opencs_schema.ttl --input opencs2.ttl --output output_opencs.ttl;

# java -jar robot.jar remove --input output_opencs.ttl --axioms tbox --output output_opencs.ttl;

# java -jar robot.jar remove --input output_opencs.ttl --select "annotation-properties data-properties anonymous classes" --output output_opencs.ttl;

# java -jar robot.jar reason --reasoner HermiT --axiom-generators "PropertyAssertion" --input output_opencs.ttl --output output_opencs.ttl;

# mv output_opencs.ttl output_files/inferred_opencs.ttl

# # java -jar robot.jar diff --left output_opencs5.ttl --right output_opencs.ttl | grep '\+' | awk '{print substr($0, 3)}' > inferred_assertions.ttl;

pwd;
cp package/opencs.ttl ./opencs2.ttl;
echo "copied opencs"

sed -i '/owl:imports <https:\/\/w3id.org\/ocs\/schema\/0.1.0>/a\    owl:imports <http://www.w3.org/2004/02/skos/core#> ;' ./opencs2.ttl
sed -i '/owl:imports <https:\/\/w3id.org\/ocs\/schema\//d' ./opencs2.ttl;
echo "deleted schema import, added skos import";

java -jar robot.jar merge --input `${{ github.repository }}`/package/opencs_schema.ttl --input ./opencs2.ttl --output ./output_opencs.ttl;
echo "merged with schema";

java -jar robot.jar remove --input ./output_opencs.ttl --axioms tbox --output ./output_opencs.ttl;
java -jar robot.jar remove --input ./output_opencs.ttl --select "annotation-properties data-properties anonymous" --output ./output_opencs.ttl;
java -jar robot.jar remove --input openCS_dir/output_opencs.ttl --select "<http://dbpedia.org/resource/*>" --output openCS_dir/output_opencs.ttl;
java -jar robot.jar unmerge --input ./output_opencs.ttl --input openCS/skos_patch.ttl --output ./output_opencs.ttl;
echo "removed unneccesary axioms ";

java -jar robot.jar reason --reasoner HermiT --axiom-generators "PropertyAssertion" --input ./output_opencs.ttl --output ./output_opencs2.ttl;
echo "reasoned";

java -jar robot.jar diff --left ./output_opencs.ttl --right output_opencs2.ttl | grep '\+' | awk '{print substr($0, 3)}' > inferred_assertions.ofn;
echo "inferred assertions";

