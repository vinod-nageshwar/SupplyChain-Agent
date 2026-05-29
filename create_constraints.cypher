//Creating Constraints
CREATE CONSTRAINT supplier_id IF NOT EXISTS FOR (n:Supplier) REQUIRE n.supplierId IS UNIQUE;
CREATE CONSTRAINT product_name IF NOT EXISTS FOR (n:Product) REQUIRE n.name IS UNIQUE;
CREATE CONSTRAINT city_name IF NOT EXISTS FOR (n:City) REQUIRE n.name IS UNIQUE;

// Create an index for spatial searches
CREATE POINT INDEX city_location FOR (n:City) ON (n.location);


//Cypher for Loading the data
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/vinod-nageshwar/SupplyChain-Agent/refs/heads/main/supply_chain_dataset.csv' 
AS row
CALL(row) {
   MERGE (sup:Supplier {supplierId: trim(row.Supplier_ID)}) SET sup.name=row.Supplier_Name
   MERGE (prd:Product {name: trim(row.Product)}) SET prd.description=row.Description,prd.price=toFloat(row.Price)
   MERGE (cy:City {name: trim(row.City)}) SET cy.location = point({latitude: toFloat(row.Latitude), longitude: toFloat(row.Longitude)})
   MERGE (sup)-[:SUPPLIES]->(prd)
   MERGE (sup)-[:LOCATED_IN]->(cy)
} IN TRANSACTIONS OF 1000 ROWS