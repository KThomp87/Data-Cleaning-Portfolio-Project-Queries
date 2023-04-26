SELECT *
FROM nashvillehousing

-- Standardize Date Format

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM nashvillehousing

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE nashvillehousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Populate Proprty Address Data

SELECT *
FROM nashvillehousing
--Where PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM nashvillehousing a
JOIN nashvillehousing b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 Where a.PropertyAddress is null

 UPDATE a
 SET PropertyAddress=ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM nashvillehousing a
JOIN nashvillehousing b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 Where a.PropertyAddress is null


--Breaking Out address Into Individual Columns (address, city, state)

Select PropertyAddress
FROM nashvillehousing
--Where PropertyAddress is NULL
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM nashvillehousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE nashvillehousing
SET PropertySplitAddress =SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE nashvillehousing
SET PropertysplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select*
FROM nashvillehousing



Select OwnerAddress
FROM nashvillehousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM nashvillehousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE nashvillehousing
SET OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress,',','.'),1)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE nashvillehousing
SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE nashvillehousing
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Select *
From nashvillehousing



--Change Y to N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM nashvillehousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
	CASE When SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM nashvillehousing

UPDATE nashvillehousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END


--Remove Duplicates


WITH RowNumCTE AS(
Select *,
	row_number() OVER (
	Partition BY ParcelID, 
				PropertyAddress, 
				SalePrice, 
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID) row_num
FROM nashvillehousing)
--Order BY ParcelID
DELETE  
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress


--Delete Unused Columns

SELECT *
FROM nashvillehousing

ALTER TABLE nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE nashvillehousing
DROP COLUMN SaleDate
