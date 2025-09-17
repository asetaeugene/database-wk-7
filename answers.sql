-- Question one
WITH RECURSIVE NormalizedProducts AS (
    -- 1. Anchor Member: This is the starting point of the recursion.
    -- It selects the first product from each list and the rest of the string.
    SELECT
        OrderID,
        CustomerName,
        -- Extracts the first product before the first comma. If no comma, it takes the whole string.
        CASE
            WHEN INSTR(Products, ',') > 0 THEN SUBSTR(Products, 1, INSTR(Products, ',') - 1)
            ELSE Products
        END AS Product,
        -- Keeps the rest of the string for the next recursive step. Returns NULL if no comma.
        CASE
            WHEN INSTR(Products, ',') > 0 THEN SUBSTR(Products, INSTR(Products, ',') + 2) -- Skips the ', '
            ELSE NULL
        END AS RemainingProducts
    FROM
        ProductDetail

    UNION ALL

    -- 2. Recursive Member: This part repeatedly executes on the output of the previous step.
    -- It takes the 'RemainingProducts' string and performs the same split logic.
    SELECT
        OrderID,
        CustomerName,
        -- Extracts the next product from the remaining string.
        CASE
            WHEN INSTR(RemainingProducts, ',') > 0 THEN SUBSTR(RemainingProducts, 1, INSTR(RemainingProducts, ',') - 1)
            ELSE RemainingProducts
        END AS Product,
        -- Updates the remaining string for the next iteration.
        CASE
            WHEN INSTR(RemainingProducts, ',') > 0 THEN SUBSTR(RemainingProducts, INSTR(RemainingProducts, ',') + 2)
            ELSE NULL
        END AS RemainingProducts
    FROM
        NormalizedProducts -- It refers to itself, which makes it recursive.
    WHERE
        RemainingProducts IS NOT NULL -- The recursion stops when there are no more products left to split.
)

SELECT
    OrderID,
    CustomerName,

  -- Question two
  
  -- This query extracts the order-specific information into a new logical table.
-- DISTINCT is crucial to remove the redundant customer name entries for each order.
SELECT DISTINCT
    OrderID,
    CustomerName
FROM
    OrderDetails
ORDER BY
    OrderID;

    Product
FROM
    NormalizedProducts
ORDER BY
    OrderID, Product;

-- This query extracts the information that depends on both the order and the product.
SELECT
    OrderID,
    Product,
    Quantity
FROM
    OrderDetails
ORDER BY
    OrderID, Product;
