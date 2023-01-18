gzip -cd package/opencs.ttl.gz opencs.ttl
cp opencs.ttl opencs2.ttl

sed -i '/owl:imports <https:\/\/w3id.org\/ocs\/schema\//d' opencs2.ttl;

java -jar robot.jar merge --input package/opencs_schema.ttl --input opencs2.ttl --output output_opencs.ttl;

java -jar robot.jar remove --input output_opencs.ttl --axioms tbox --output output_opencs.ttl;

java -jar robot.jar remove --input output_opencs.ttl --select "annotation-properties data-properties anonymous classes" --output output_opencs.ttl;

java -jar robot.jar reason --reasoner HermiT --axiom-generators "PropertyAssertion" --input output_opencs.ttl --output output_opencs.ttl;

output_opencs.ttl > output_files/inferred_opencs.ttl

# java -jar robot.jar diff --left output_opencs5.ttl --right output_opencs.ttl | grep '\+' | awk '{print substr($0, 3)}' > inferred_assertions.ttl;
