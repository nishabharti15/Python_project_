select * from Nashville_Housing
select SaleDate, CONVERT(Date, SaleDate) from Nashville_Housing
UPDATE Nashville_Housing

SET SaleDate = CONVERT (Date, SaleDate)

-- Use UPDATE to change SaleDate to Date Format. 


-- Add a new column with the standardized date. Use ALTER TABLE, then UPDATE.

ALTER TABLE Nashville_Housing

Add SaleDateConverted Date;


UPDATE Nashville_Housing

SET SaleDateConverted = CONVERT(Date, SaleDate)


-- Check to see if new column SaleDateConverted is correct.

SELECT SaleDateConverted, CONVERT(Date, SaleDate) 

FROM Nashville_Housing

SELECT PropertyAddress

FROM Nashville_Housing

WHERE PropertyAddress is null

SELECT *

FROM Nashville_Housing

ORDER BY ParcelID

-- I notice the same ParcelID and PropertyAddress are listed for different UniqueIDs. 



-----

/* I want to it to find a ParcelID with a null PropertyAddress. Then populate the PropertyAddress from a different UniqueID with a matching ParcelID. */

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress

FROM Nashville_Housing a

JOIN Nashville_Housing b

	ON a.ParcelID = b.parcelID
    
	AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress is null
	-- Join where the ParcelIDs are the same but the UniqueIDs are different, and look where the PropertyAddress is null.

-- Use ISNULL to create new column that reflects where a.Property was null and have it input b.PropertyAddress

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)

FROM Nashville_Housing a

JOIN Nashville_Housing b

	ON a.ParcelID = b.parcelID
    
	AND a.[UniqueID ] <> b.[UniqueID ]
    
WHERE a.PropertyAddress is null


-- Update PropertyAddress column using alias a.

UPDATE a

SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)

FROM Nashville_Housing a

JOIN Nashville_Housing b
ON a.ParcelID = b.parcelID
    
	AND a.[UniqueID ] <> b.[UniqueID ]
    
WHERE a.PropertyAddress is null


-- Then rerun with WHERE clause to check it worked and there should be no nulls.

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)

FROM Nashville_Housing a

JOIN Nashville_Housing b

	ON a.ParcelID = b.parcelID
    
	AND a.[UniqueID ] <> b.[UniqueID ]
    
WHERE a.PropertyAddress is null



-----

/* Let's look at the Property Address */

Select PropertyAddress

FROM Nashville_Housing
/* Split PropertyAddress into separate columns for address and city Using SUBSTRING and CHARINDEX */

SELECT

SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address

, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City

FROM Nashville_Housing

-- Take the PropertyAddress at position 1 until the comma ','. Then to remove the comma, -1. Name the column 'Address'

-- Take the PropertyAddress until the comma's position. Then to remove the comma, -1. Name the column 'City'

-- Run query to check accuracy


ALTER TABLE Nashville_Housing

ADD SplitPropertyAddress Nvarchar(255);

-- Add a column for the split address.

Update Nashville_Housing

SET SplitPropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

-- Input the data for the split address column.
ALTER TABLE Nashville_Housing

ADD SplitPropertyCity Nvarchar(255);

-- Add a column for the split city.

UPDATE Nashville_Housing

SET SplitPropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

-- Input the data for the split city column.


SELECT *

FROM Nashville_Housing

-- Let's see the updated table.


-----

/* Let's look at the OwnerAddress */

SELECT OwnerAddress

FROM Nashville_Housing
/* Split OwnerAddress into separate columns for address, city, and state. */

SELECT 

PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

FROM Nashville_Housing

-- PARSENAME(OwnerAddress, 1)

-- PARSENAME only looks for periods, so we need to REPLACE the commas with a period. 

-- PARSENAME goes backwards, so we need 321 instead of 123.


ALTER TABLE Nashville_Housing

ADD SplitOwnerAddress Nvarchar(255);

-- Add a column for SplitOwnerAddress.

Update Nashville_Housing

SET SplitOwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

-- Input the data for SplitOwnerAddress column.

ALTER TABLE Nashville_Housing

ADD SplitOwnerCity Nvarchar(255);

-- Add a column for SplitOwnerCity.

Update Nashville_Housing

SET SplitOwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

-- Input the data for SplitOwnerCity column.


ALTER TABLE Nashville_Housing

ADD SplitOwnerState Nvarchar(255);

-- Add a column for SplitOwnerState.

Update Nashville_Housing

SET SplitOwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

-- Input the data for SplitOwnerState column.


SELECT *

FROM Nashville_Housing


-----/* Let's look at the SoldAsVacant column. */

SELECT DISTINCT(SoldAsVacant), COUNT (SoldAsVacant)

FROM Nashville_Housing

GROUP BY SoldAsVacant

ORDER BY 2


-- Rerun our SoldAsVacant column to check completion.

SELECT DISTINCT(SoldAsVacant), COUNT (SoldAsVacant)

FROM Nashville_Housing

GROUP BY SoldAsVacant

ORDER BY 2

/* Check for duplicates. */

SELECT *,

	ROW_NUMBER() OVER (
    
	PARTITION BY ParcelID,
    
				PropertyAddress,
                
				SalePrice,
                
				SaleDate,
                
				LegalReference
                
				ORDER BY UniqueID
                
				) AS row_num
                
FROM Nashville_Housing

ORDER BY ParcelID

-- In the column row_num, I can identify the 2's. Upon investigation, I see the 2 rows have all the same data but different UniqueId's. 



/* USE CTE to view all the duplicates (row_num 2's) */

WITH RowNumCTE AS (
SELECT *,

	ROW_NUMBER() OVER (
    
	PARTITION BY ParcelID,
    
				PropertyAddress,
                
				SalePrice,
                
				SaleDate,
                
				LegalReference
                
				ORDER BY UniqueID
                
				) AS row_num
                
FROM Nashville_Housing

)

