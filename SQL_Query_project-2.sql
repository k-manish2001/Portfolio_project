-- Data cleaning --
SELECT *
FROM Portfolio_project..National_housing_data;

-- standarized date format --
SELECT sellDateconverted, CONVERT(date, SaleDate)
FROM Portfolio_project..National_housing_data;

UPDATE National_housing_data
 SET SaleDate = CONVERT(date, SaleDate); 

 -- if above query doesn't work then--
 ALTER TABLE Portfolio_project..National_housing_data
 ADD sellDateconverted DATE;


 UPDATE National_housing_data
 SET sellDateconverted = CONVERT(date, SaleDate);

 --Polpulate property address data--

 SELECT*, PropertyAddress
 FROM Portfolio_project..National_housing_data
 WHERE PropertyAddress IS NULL

--Checking weather the address is there with same parcelID--
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM  Portfolio_project..National_housing_data a
	JOIN  Portfolio_project..National_housing_data b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET a.PropertyAddress = b.PropertyAddress
FROM  Portfolio_project..National_housing_data a
	JOIN  Portfolio_project..National_housing_data b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

--Breaking down the address into individual coloumns (address, city, state)

SELECT PropertyAddress
FROM Portfolio_project..National_housing_data

SELECT propertyaddress, SUBSTRING(PropertyAddress, 1, CHARINDEX (',', PropertyAddress)-1) AS address_1
, SUBSTRING(PropertyAddress, CHARINDEX (',', PropertyAddress) +1, LEN(PropertyAddress)) AS address_2
FROM Portfolio_project..National_housing_data

--updating the info--
ALTER TABLE National_housing_data
ADD Property_split_address NVARCHAR(255)

UPDATE National_housing_data
SET Property_split_address = SUBSTRING(PropertyAddress, 1, CHARINDEX (',', PropertyAddress)-1)

ALTER TABLE National_housing_data
ADD Property_split_city NVARCHAR(255)


UPDATE National_housing_data
SET Property_split_city = SUBSTRING(PropertyAddress, CHARINDEX (',', PropertyAddress) +1, LEN(PropertyAddress))


--Seperating Owner_address--
SELECT *, OwnerAddress
FROM Portfolio_project..National_housing_data

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.' ), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.' ), 2), 
PARSENAME(REPLACE(OwnerAddress, ',', '.' ), 1)
FROM Portfolio_project..National_housing_data
WHERE OwnerAddress IS NOT NULL

ALTER TABLE National_housing_data
ADD owner_split_address NVARCHAR(255)

UPDATE National_housing_data
SET owner_split_address = PARSENAME(REPLACE(OwnerAddress, ',', '.' ), 3)

ALTER TABLE National_housing_data
ADD owner_split_city NVARCHAR(255)

UPDATE National_housing_data
SET owner_split_city = PARSENAME(REPLACE(OwnerAddress, ',', '.' ), 2)

ALTER TABLE National_housing_data
ADD owner_split_state NVARCHAR(255)

UPDATE National_housing_data
SET owner_split_state = PARSENAME(REPLACE(OwnerAddress, ',', '.' ), 1)


--Changing Y and N to YES and NO in sold as vacant coloumn--
SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM Portfolio_project..National_housing_data
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant, 
CASE WHEN SoldAsVacant = 'Y' THEN 'YES' 
	 WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
FROM Portfolio_project..National_housing_data
--WHERE SoldAsVacant = 'N'

UPDATE National_housing_data
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES' 
	 WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
FROM Portfolio_project..National_housing_data



--Deleting unused columns--

SELECT*
FROM Portfolio_project..National_housing_data


WITH Row_num_CTE AS(
SELECT*, 
ROW_NUMBER() 
	OVER (
	PARTITION BY parcelID, propertyaddress, saledate, saleprice, legalreference 
	ORDER BY parcelID) AS row_num
FROM Portfolio_project..National_housing_data
--ORDER BY ParcelID;
)

SELECT* --deleted the duplicates
FROM Row_num_CTE
WHERE row_num > 1


-- Delete unused columns--

SELECT*
FROM Portfolio_project..National_housing_data

ALTER TABLE National_housing_data
DROP COLUMN owneraddress, taxdistrict, propertyaddress, saledate


ALTER TABLE National_housing_data
DROP COLUMN parcelID_1


--Queries completed here--