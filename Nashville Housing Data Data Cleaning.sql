
--- Skills used: Converting Data Types, Altering Tables, Joins, Substrings, Select/Update/Delete Statements, CTE, Windows Functions

----------------------------------------------------------------------
-- Part 1: Standardize Date Format
----------------------------------------------------------------------

ALTER TABLE Nashville_Housing_Data
ADD SaleDateConverted Date

UPDATE Nashville_Housing_Data
SET SaleDateConverted = CONVERT(Date, SaleDate)

----------------------------------------------------------------------
-- Part 2: Populate Property Address Data
----------------------------------------------------------------------

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) AS UpdatedPropAddress
FROM Nashville_Housing_Data a
JOIN Nashville_Housing_Data b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM Nashville_Housing_Data a
JOIN Nashville_Housing_Data b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null

----------------------------------------------------------------------
-- Part 3: Breaking Address into Individual Columns
----------------------------------------------------------------------

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Street_Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM Nashville_Housing_Data

ALTER TABLE Nashville_Housing_Data
ADD Street_Address nvarchar(255)

UPDATE Nashville_Housing_Data
SET Street_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE Nashville_Housing_Data
ADD City nvarchar(255)

UPDATE Nashville_Housing_Data
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Owner_Street_Address,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS Owner_City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS Owner_State
FROM Nashville_Housing_Data

ALTER TABLE Nashville_Housing_Data
ADD Owner_Street_Address nvarchar(255)

UPDATE Nashville_Housing_Data
SET Owner_Street_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE Nashville_Housing_Data
ADD Owner_City nvarchar(255)

UPDATE Nashville_Housing_Data
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE Nashville_Housing_Data
ADD Owner_State nvarchar(255)

UPDATE Nashville_Housing_Data
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

----------------------------------------------------------------------
-- Part 4: Change Y to N to "Yes" and "No" in SoldAsVacant Column
----------------------------------------------------------------------

SELECT SoldASVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM Nashville_Housing_Data

UPDATE Nashville_Housing_Data
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

----------------------------------------------------------------------
-- Part 5: Remove Duplicates
----------------------------------------------------------------------

WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress, 
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
				 ) AS row_num
From Nashville_Housing_Data
)
DELETE
From RowNumCTE
WHERE row_num > 1

----------------------------------------------------------------------
-- Part 6: Delete Unnecessary Columns
----------------------------------------------------------------------

ALTER TABLE Nashville_Housing_Data
DROP Column OwnerAddress, SaleDate, PropertyAddress