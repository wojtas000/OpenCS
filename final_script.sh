mkdir openCS_dir;
cp opencs.ttl skos_patch.ttl opencs_schema.ttl openCS_dir;

sed -i '/owl:imports <https:\/\/w3id.org\/ocs\/schema\//d' openCS_dir/opencs.ttl;
echo "1st step finished! (remove schema import)";
java -jar robot.jar merge --input openCS_dir/opencs_schema.ttl --input openCS_dir/opencs.ttl --output openCS_dir/output_opencs.ttl;
echo "2nd step finished! (merge with schema)";
java -jar robot.jar remove --input openCS_dir/output_opencs.ttl --axioms tbox --output openCS_dir/output_opencs2.ttl;
echo "3rd step finished! (remove tbox)";
# java -jar robot.jar remove --input openCS_dir/output_opencs2.ttl --select "<http://dbpedia.org/resource/*>" --output openCS_dir/output_opencs3.ttl;
# echo "4th step finished! (remove unneccesary axioms)";
java -jar robot.jar remove --input openCS_dir/output_opencs3.ttl --select "annotation-properties data-properties anonymous classes" --output openCS_dir/output_opencs4.ttl;
echo "5th step finished! (remove unnecessary properties and classes)";
# java -jar robot.jar unmerge --input openCS_dir/output_opencs4.ttl --input openCS_dir/skos_patch.ttl --output openCS_dir/output_opencs5.ttl;
# echo "6th step finished! (unmerge skos_patch.ttl file - optional for faster computation)" ;
java -jar robot.jar reason --reasoner HermiT --axiom-generators "PropertyAssertion" --input openCS_dir/output_opencs5.ttl --output openCS_dir/output_opencs6.ttl;
echo "7th step finished! (reasoning)";
java -jar robot.jar diff --left openCS_dir/output_opencs5.ttl --right openCS_dir/output_opencs6.ttl | grep '\+' | awk '{print substr($0, 3)}' > openCS_dir/inferred_assertions.ttl;
echo "All steps finished! (inferring assertions)";
