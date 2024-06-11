/* Es 01 Verificare che i campi definiti come PK siano univoci.
Premetto che non ha comunque senso fare tutto ciò dato che le PK
non possono ripetersi già in fase di riempimento delle tabelle, o comunque
si può utilizzare "unique" come constraint.*/
-- Metodo 1
-- Conteggio numero righe
SELECT COUNT(ProductID) FROM DimProducts;
SELECT COUNT(RegionID) FROM DimRegions;
SELECT COUNT(SaleID) FROM FactSales;
-- Cerco i non univoci
SELECT COUNT(DISTINCT(ProductID)) FROM DimProducts;
SELECT COUNT(DISTINCT(RegionID)) FROM DimRegions;
SELECT COUNT(DISTINCT(SaleID)) FROM FactSales;
-- Se i conteggi precedenti non coincidono a questi significa che qualche PK è ripetuta.
-- Metodo 2 (esempio per 1 sola tabella ma direi che ci siamo capiti)
SELECT ProductID FROM DimProducts
GROUP BY ProductID HAVING COUNT(*) >1;
-- Se il risultato è 0 non ci sono valori ripetuti

-- Es. 02 Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno
SELECT
	YEAR(OrderDate) AS Anno, ProductID, Name, SUM(Price * OrderQuantity) AS FatturatoPerAnno
FROM DimProducts
INNER JOIN FactSales USING(ProductID)
GROUP BY YEAR(OrderDate), ProductID;

-- Es. 03 Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente.
SELECT
	YEAR(OrderDate) AS Anno, Country, SUM(Price * OrderQuantity) AS FatturatoPerAnno
FROM DimRegions
INNER JOIN FactSales USING(RegionID)
INNER JOIN DimProducts USING(ProductID)
GROUP BY YEAR(OrderDate), Country
ORDER BY YEAR(OrderDate) DESC, FatturatoPerAnno DESC;

-- Es.04 Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato? 
SELECT ProductID, Name, COUNT(ProductID) AS NProdottiVenduti FROM DimProducts
INNER JOIN FactSales USING(ProductID)
GROUP BY ProductID, Name
ORDER BY NProdottiVenduti DESC
LIMIT 1;

-- Es.05 Rispondere alla seguente domanda: quali sono, se ci sono, i prodotti invenduti? Proponi due approcci risolutivi differenti. 
SELECT ProductID, Name, SaleID FROM DimProducts
LEFT JOIN FactSales USING(ProductID)
WHERE SaleID IS NULL;

SELECT ProductID, Name FROM DimProducts
WHERE ProductID NOT IN (SELECT ProductID FROM FactSales);

-- Es. 06 Esporre l’elenco dei prodotti con la rispettiva ultima data di vendita (la data di vendita più recente).
SELECT dp.ProductID, dp.Name, MAX(fs.OrderDate) AS UltimoOrdine FROM DimProducts AS dp
LEFT JOIN FactSales AS fs ON dp.ProductID = fs.ProductID
GROUP BY dp.ProductID
ORDER BY UltimoOrdine DESC;




