CREATE DATABASE e_commerce;

USE e_commerce;

-- Brand table (companies that make products)
CREATE TABLE brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    brand_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product categories (hierarchical)
CREATE TABLE product_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT NULL,
    FOREIGN KEY (parent_category_id) REFERENCES product_category(category_id)
);

-- Size categories (groups like clothing, shoes)
CREATE TABLE size_category (
    size_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

-- Size options (specific sizes)
CREATE TABLE size_option (
    size_id INT AUTO_INCREMENT PRIMARY KEY,
    size_category_id INT NOT NULL,
    size_value VARCHAR(20) NOT NULL,
    FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id)
);

-- Color options
CREATE TABLE color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR(50) NOT NULL,
    hex_code VARCHAR(7)
);

-- Main product table
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    brand_id INT,
    category_id INT,
    base_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id),
    FOREIGN KEY (category_id) REFERENCES product_category(category_id)
);

-- Product variations (color/size combinations)
CREATE TABLE product_variation (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    color_id INT,
    size_id INT,
    sku VARCHAR(50) UNIQUE,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (color_id) REFERENCES color(color_id),
    FOREIGN KEY (size_id) REFERENCES size_option(size_id)
);

-- Product items (inventory)
CREATE TABLE product_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    variation_id INT NOT NULL,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    price_adjustment DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (variation_id) REFERENCES product_variation(variation_id)
);

-- Product images
CREATE TABLE product_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- Attribute classification
CREATE TABLE attribute_category (
    attr_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- Attribute types
CREATE TABLE attribute_type (
    attr_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL, -- 'text', 'number', 'boolean'
    data_type VARCHAR(20) NOT NULL -- VARCHAR, INT, BOOLEAN
);

-- Product attributes
CREATE TABLE product_attribute (
    attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    attr_category_id INT,
    attr_type_id INT,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_value TEXT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (attr_category_id) REFERENCES attribute_category(attr_category_id),
    FOREIGN KEY (attr_type_id) REFERENCES attribute_type(attr_type_id)
);



-- 1. Insert data into brand table
INSERT INTO brand (brand_id, brand_name, brand_description) VALUES
(1, 'Nike', 'American athletic footwear and apparel'),
(2, 'Apple', 'Consumer electronics and software'),
(3, 'Levi''s', 'Denim jeans and casual wear'),
(4, 'Samsung', 'Korean electronics and smartphones'),
(5, 'Adidas', 'German sportswear manufacturer'),
(6, 'Sony', 'Japanese electronics and entertainment'),
(7, 'Canon', 'Cameras, printers, and imaging equipment'),
(8, 'KitchenAid', 'Premium kitchen appliances'),
(9, 'The North Face', 'Outdoor clothing and equipment');

SELECT * FROM brand;

-- 2. Insert data into product_category table
INSERT INTO product_category (category_id, category_name, parent_category_id) VALUES
(1, 'Electronics', NULL),
(2, 'Clothing', NULL),
(3, 'Footwear', NULL),
(4, 'Smartphones', 1),
(5, 'Laptops', 1),
(6, 'T-Shirts', 2),
(7, 'Jeans', 2),
(8, 'Running Shoes', 3),
(9, 'Kitchen Appliances', NULL);

SELECT * FROM product_category;


-- 3. Insert data into size_category table
INSERT INTO size_category (size_category_id, category_name) VALUES
(1, 'Clothing'),
(2, 'Footwear'),
(3, 'Screens'),
(4, 'Cups'),
(5, 'Memory'),
(6, 'Shoe Width'),
(7, 'Bra Sizes'),
(8, 'Kids Clothing'),
(9, 'Wheel Sizes');

SELECT * FROM size_category;


-- 4. Insert data into size_option table
INSERT INTO size_option (size_id, size_category_id, size_value) VALUES
(1, 1, 'S'),
(2, 1, 'M'),
(3, 1, 'L'),
(4, 2, '9'),
(5, 2, '10'),
(6, 2, '11'),
(7, 3, '24"'),
(8, 3, '27"'),
(9, 3, '32"');

SELECT * FROM size_option;


-- 5. Insert data into color table
INSERT INTO color (color_id, color_name, hex_code) VALUES
(1, 'Red', '#FF0000'),
(2, 'Navy Blue', '#000080'),
(3, 'Black', '#000000'),
(4, 'White', '#FFFFFF'),
(5, 'Gray', '#808080'),
(6, 'Pink', '#FFC0CB'),
(7, 'Olive Green', '#808000'),
(8, 'Royal Blue', '#4169E1'),
(9, 'Gold', '#FFD700');

SELECT * FROM color;


-- 6. Insert data into product table
INSERT INTO product (product_id, product_name, brand_id, category_id, base_price) VALUES
(1, 'Air Force 1', 1, 3, 110.00),
(2, 'iPhone 15 Pro', 2, 4, 999.00),
(3, '501 Original Fit Jeans', 3, 7, 79.50),
(4, 'Galaxy S23 Ultra', 4, 4, 1199.99),
(5, 'Ultraboost 22', 5, 8, 180.00),
(6, 'WH-1000XM5 Headphones', 6, 1, 399.99),
(7, 'EOS R5 Camera', 7, 1, 3899.00),
(8, 'Stand Mixer', 8, 9, 429.99),
(9, 'Denali Jacket', 9, 2, 249.00);

SELECT * FROM product;


-- 7. Insert data into product_variation table
INSERT INTO product_variation (variation_id, product_id, color_id, size_id, sku) VALUES
(1, 1, 3, 4, 'NIKE-AF1-BLK-9'),
(2, 1, 4, 5, 'NIKE-AF1-WHT-10'),
(3, 2, 3, NULL, 'APPLE-IP15P-BLK'),
(4, 3, 2, 2, 'LEVIS-501-NAVY-M'),
(5, 4, 8, NULL, 'SAMSUNG-S23U-BLUE'),
(6, 5, 1, 4, 'ADIDAS-UB22-RED-9'),
(7, 6, 3, NULL, 'SONY-WH1000XM5-BLK'),
(8, 7, 4, NULL, 'CANON-EOSR5-WHT'),
(9, 8, 5, NULL, 'KTAID-MIXER-GRY');

SELECT * FROM product_variation;


-- 8. Insert data into product_item table
INSERT INTO product_item (item_id, variation_id, quantity_in_stock, price_adjustment) VALUES
(1, 1, 45, 0.00),
(2, 2, 32, 0.00),
(3, 3, 18, 0.00),
(4, 4, 27, -5.00),
(5, 5, 12, 0.00),
(6, 6, 8, 0.00),
(7, 7, 23, 0.00),
(8, 8, 5, 0.00),
(9, 9, 15, 0.00);

-- 9. Insert data into product_image table
INSERT INTO product_image (image_id, product_id, image_url, is_primary) VALUES
(1, 1, 'https://example.com/nike-af1-black.jpg', 1),
(2, 1, 'https://example.com/nike-af1-side.jpg', 0),
(3, 2, 'https://example.com/iphone15-front.jpg', 1),
(4, 2, 'https://example.com/iphone15-back.jpg', 0),
(5, 3, 'https://example.com/levis-501-navy.jpg', 1),
(6, 4, 'https://example.com/s23ultra-blue.jpg', 1),
(7, 5, 'https://example.com/ultraboost-red.jpg', 1),
(8, 6, 'https://example.com/sony-headphones.jpg', 1),
(9, 7, 'https://example.com/canon-r5-white.jpg', 1);

SELECT * FROM product_image;


-- 10. Insert data into attribute_category table
INSERT INTO attribute_category (attr_category_id, category_name) VALUES
(1, 'Technical Specs'),
(2, 'Materials'),
(3, 'Dimensions'),
(4, 'Features'),
(5, 'Compatibility'),
(6, 'Care'),
(7, 'Power'),
(8, 'Connectivity'),
(9, 'Warranty');

SELECT * FROM attribute_category;


-- 11. Insert data into attribute_type table
INSERT INTO attribute_type (attr_type_id, type_name, data_type) VALUES
(1, 'Text', 'VARCHAR'),
(2, 'Number', 'INT'),
(3, 'Decimal', 'DECIMAL'),
(4, 'Boolean', 'TINYINT'),
(5, 'Date', 'DATE'),
(6, 'Color', 'VARCHAR'),
(7, 'Weight', 'DECIMAL'),
(8, 'Volume', 'DECIMAL'),
(9, 'Memory', 'VARCHAR');

SELECT * FROM attribute_type;


-- 12. Insert data into product_attribute table
INSERT INTO product_attribute (attribute_id, product_id, attr_category_id, attr_type_id, attribute_name, attribute_value) VALUES
(1, 2, 1, 2, 'RAM', '8'),
(2, 2, 1, 9, 'Storage', '256GB'),
(3, 3, 2, 1, 'Fabric', '98% Cotton, 2% Elastane'),
(4, 4, 1, 2, 'Battery Capacity', '5000'),
(5, 5, 3, 7, 'Weight', '0.65'),
(6, 6, 8, 1, 'Bluetooth Version', '5.2'),
(7, 7, 1, 2, 'Megapixels', '45'),
(8, 8, 7, 3, 'Wattage', '300.00'),
(9, 9, 2, 1, 'Shell Fabric', '100% Nylon');

