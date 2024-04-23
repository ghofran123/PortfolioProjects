			/**

			Cleaning NashvilleHousing Data using SQL Queries

			**/


select * 
from ..NashvilleHousing

-------------------------------------------------------------------

-- Standarize Date Format

select SaledateConverted, CONVERT(date,SaleDate)
from ..NashvilleHousing

update NashvilleHousing
set SaleDate = CONVERT(date,SaleDate)

alter table NashvilleHousing
add SaledateConverted date;

update NashvilleHousing
set SaledateConverted = CONVERT(date,SaleDate)

-------------------------------------------------------------------

-- Populate PropertyAdress Data

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from ..NashvilleHousing a
JOIN ..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from ..NashvilleHousing a
JOIN ..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]

-------------------------------------------------------------------

-- Breaking out Adresss into Individual Columns (Adress, City, State)

select PropertyAddress
from ..NashvilleHousing

select 
SUBSTRING(PropertyAddress,1,charindex(',' , PropertyAddress)-1) as Adress
, SUBSTRING(PropertyAddress,charindex(',' , PropertyAddress)+1,LEN(PropertyAddress)) as City
from ..NashvilleHousing


alter table NashvilleHousing
add PropertySplitAdress nvarchar(255),
	PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitAdress = SUBSTRING(PropertyAddress,1,charindex(',' , PropertyAddress)-1)
,	PropertySplitCity = SUBSTRING(PropertyAddress,charindex(',' , PropertyAddress)+1,LEN(PropertyAddress))


select 
PARSENAME(replace(OwnerAddress,',','.'),3)
, PARSENAME(replace(OwnerAddress,',','.'),2)
, PARSENAME(replace(OwnerAddress,',','.'),1)
from ..NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAdress nvarchar(255)
,	OwnerSplitCity nvarchar(255)
,	OwnerSplitState nvarchar(255);


update NashvilleHousing
set OwnerSplitAdress = PARSENAME(replace(OwnerAddress,',','.'),3) 
,	OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2)
,	OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1)

-------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" Field

select distinct(SoldAsVacant), Count(SoldAsVacant)
from ..NashvilleHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant
,case when SoldAsVacant= 'Y' Then 'Yes'
	  when SoldAsVacant= 'N' Then 'No'
	  Else SoldAsVacant
	  End
from ..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant= 'Y' Then 'Yes'
	  when SoldAsVacant= 'N' Then 'No'
	  Else SoldAsVacant
	  End


-------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE As(
select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
from ..NashvilleHousing
)

DELETE 
From RowNumCTE
where row_num > 1


-------------------------------------------------------------------

-- Delete Unused Columns


ALTER TABLE NashvilleHousing
DROP COLUMN ownerAddress, TAXDistrict, PropertyAddress, SaleDate
