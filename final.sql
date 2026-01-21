CREATE DATABASE final;
USE final;

/*
PHẦN 1: THIẾT KẾ CSDL & CHÈN DỮ LIỆU (25 ĐIỂM)
1. Thiết kế bảng (15 điểm): Viết câu lệnh DDL tạo CSDL gồm 5 bảng với đầy đủ ràng buộc.
*/

CREATE TABLE Shippers (
    driver_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    license_type VARCHAR(10) NOT NULL,
    rating DECIMAL(3, 1) DEFAULT 5.0 CHECK (rating >= 0 AND rating <= 5)
);

CREATE TABLE Vehicle_Details (
    vehicle_id INT PRIMARY KEY,
    driver_id INT,
    plate_number VARCHAR(20) UNIQUE,
    vehicle_type VARCHAR(50),
    max_payload DECIMAL(10, 2) CHECK (max_payload > 0),
    FOREIGN KEY (driver_id) REFERENCES Shippers(driver_id)
);


CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY,
    item_name VARCHAR(255),
    actual_weight DECIMAL(10, 2) CHECK (actual_weight > 0),
    value DECIMAL(15, 2),
    status VARCHAR(50)
);


CREATE TABLE Delivery_Orders (
    order_id INT PRIMARY KEY,
    shipment_id INT,
    driver_id INT,
    dispatch_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    shipping_fee DECIMAL(15, 2),
    status VARCHAR(50),
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id),
    FOREIGN KEY (driver_id) REFERENCES Shippers(driver_id)
);

CREATE TABLE Delivery_Log (
    log_id INT PRIMARY KEY,
    order_id INT,
    current_location VARCHAR(255),
    timestamp DATETIME,
    note TEXT,
    FOREIGN KEY (order_id) REFERENCES Delivery_Orders(order_id)
);

/*
2. DML (10 điểm): Viết câu lệnh insert dữ liệu mẫu.
*/

INSERT INTO Shippers (driver_id, full_name, phone, license_type, rating) VALUES
(1, 'Nguyen Van An', '0901234567', 'C', 4.8),
(2, 'Tran Thi Binh', '0912345678', 'A2', 5.0),
(3, 'Le Hoang Nam', '0983456789', 'FC', 4.2),
(4, 'Pham Minh Duc', '0354567890', 'B2', 4.9),
(5, 'Hoang Quoc Viet', '0775678901', 'C', 4.7);


INSERT INTO Vehicle_Details (vehicle_id, driver_id, plate_number, vehicle_type, max_payload) VALUES
(101, 1, '29C-123.45', 'Tải', 3500),
(102, 2, '59A-888.88', 'Xe máy', 500),
(103, 3, '15R-999.99', 'Container', 32000),
(104, 4, '30F-111.22', 'Tải', 1500),
(105, 5, '43C-444.55', 'Tải', 5000);


INSERT INTO Shipments (shipment_id, item_name, actual_weight, value, status) VALUES
(5001, 'Smart TV Samsung 55 inch', 25.5, 15000000, 'In Transit'),
(5002, 'Laptop Dell XPS', 2.0, 35000000, 'Delivered'),
(5003, 'Máy nén khí công nghiệp', 450.0, 120000000, 'In Transit'),
(5004, 'Thùng trái cây nhập khẩu', 15.0, 2500000, 'Returned'),
(5005, 'Máy giặt LG Inverter', 70.0, 9500000, 'In Transit');


INSERT INTO Delivery_Orders (order_id, shipment_id, driver_id, dispatch_time, shipping_fee, status) VALUES
(9001, 5001, 1, '2024-05-20 08:00:00', 2000000, 'Processing'),
(9002, 5002, 2, '2024-05-20 09:30:00', 3500000, 'Finished'),
(9003, 5003, 3, '2024-05-20 10:15:00', 2500000, 'Processing'),
(9004, 5004, 5, '2024-05-21 07:00:00', 1500000, 'Finished'),
(9005, 5005, 4, '2024-05-21 08:45:00', 2500000, 'Pending');


INSERT INTO Delivery_Log (log_id, order_id, current_location, timestamp, note) VALUES
(1, 9001, 'Kho tổng (Hà Nội)', '2021-05-15 08:15:00', 'Rời kho'),
(2, 9001, 'Trạm thu phí Phủ Lý', '2021-05-17 10:00:00', 'Đang giao'),
(3, 9002, 'Quận 1, TP.HCM', '2024-05-19 10:30:00', 'Đã đến điểm đích'),
(4, 9003, 'Cảng Hải Phòng', '2024-05-20 11:00:00', 'Rời kho'),
(5, 9004, 'Kho hoàn hàng (Đà Nẵng)', '2024-05-21 14:00:00', 'Đã nhập kho trả hàng');


-- a. Viết câu lệnh tăng phí vận chuyển thêm 10% cho tất cả các phiếu điều phối có trạng thái 'Finished' và có trọng lượng hàng hóa lớn hơn 100kg.


UPDATE Delivery_Orders d
JOIN Shipments s ON d.shipment_id = s.shipment_id
SET d.shipping_fee = d.shipping_fee * 1.10
WHERE d.status = 'Finished' AND s.actual_weight > 100;


--  Viết câu lệnh xóa các bản ghi trong nhật ký di chuyển (Delivery_Log) có thời điểm ghi nhận trước ngày 17/05/2024.


DELETE FROM Delivery_Log 
WHERE timestamp < '2024-05-17 00:00:00';

/*
PHẦN 2: TRUY VẤN DỮ LIỆU CƠ BẢN (15 ĐIỂM)
Câu 1 (5đ): Liệt kê danh sách các phương tiện Biển số xe, Loại xe, Trọng tải tối đa có trọng tải trên 5.000kg hoặc thuộc loại xe 'Container' nhưng có trọng tải dưới 2.000kg.
*/

SELECT plate_number, vehicle_type, max_payload
FROM Vehicle_Details
WHERE max_payload > 5000 OR (vehicle_type = 'Container' AND max_payload < 2000);


-- Câu 2 (5đ): Lấy Họ tên, Số điện thoại của tài xế có Điểm đánh giá từ 4.5 đến 5.0 và Số điện thoại bắt đầu bằng '090'.


SELECT full_name, phone
FROM Shippers
WHERE (rating BETWEEN 4.5 AND 5.0) AND phone LIKE '090%';


-- Câu 3 (5đ): Viết truy vấn để hiển thị danh sách các vận đơn ở trang thứ 2 (giả sử mỗi trang có 2 đơn), với điều kiện danh sách gốc được sắp xếp giảm dần theo Giá trị hàng hóa.


SELECT * FROM Shipments
ORDER BY value DESC
LIMIT 2 OFFSET 2;

/*
PHẦN 3: TRUY VẤN DỮ LIỆU NÂNG CAO (20 ĐIỂM)
Câu 1 (6đ): Viết lệnh hiển thị thông tin đơn hàng gồm: Họ tên tài xế, Mã vận đơn, Tên hàng hóa, Phí vận chuyển và Ngày điều phối.
*/

SELECT s.full_name, sp.shipment_id, sp.item_name, d.shipping_fee, d.dispatch_time
FROM Delivery_Orders d
JOIN Shippers s ON d.driver_id = s.driver_id
JOIN Shipments sp ON d.shipment_id = sp.shipment_id;


-- Câu 2 (7đ): Tính tổng Phí vận chuyển của mỗi tài xế. Chỉ lấy các tài xế có tổng Phí vận chuyển lớn hơn 3.000.000 VNĐ


SELECT driver_id, SUM(shipping_fee) AS total_fee
FROM Delivery_Orders
GROUP BY driver_id
HAVING SUM(shipping_fee) > 3000000;


-- Câu 3 (7đ): Tìm thông tin những tài xế có trung bình Điểm đánh giá cao nhất.


SELECT *
FROM Shippers
WHERE rating = (SELECT MAX(rating) FROM Shippers);

/*
PHẦN 4: INDEX VÀ VIEW (10 ĐIỂM)
Câu 1 (5đ): Tạo một Composite Index tên idx_shipment_status_value trên bảng Shipments gồm hai cột: Trạng thái và Giá trị hàng hóa.
*/

CREATE INDEX idx_shipment_status_value ON Shipments(status, value);


-- Câu 2 (5đ): Tạo một View tên vw_driver_performance hiển thị: Họ tên tài xế, Tổng số chuyến hàng đã nhận và Tổng doanh thu phí vận chuyển (không tính các đơn bị 'Cancelled').


CREATE VIEW vw_driver_performance AS
SELECT s.full_name, COUNT(d.order_id) AS total_trips, SUM(d.shipping_fee) AS total_revenue
FROM Shippers s
JOIN Delivery_Orders d ON s.driver_id = d.driver_id
WHERE d.status <> 'Cancelled'
GROUP BY s.driver_id, s.full_name;

/*
PHẦN 5: TRIGGER (10 ĐIỂM)
Câu 1 (5đ): Viết Trigger trg_after_delivery_finish. Khi Trạng thái phiếu được cập nhật sang 'Finished', tự động ghi một dòng vào Delivery_Log với ghi chú: 'Delivery Completed Successfully', Vị trí hiện tại: ghi là 'Tại điểm đích' và Thời điểm ghi nhận: Thời gian hiện tại.
*/

DELIMITER //
CREATE TRIGGER trg_after_delivery_finish
AFTER UPDATE ON Delivery_Orders
FOR EACH ROW
BEGIN
    IF NEW.status = 'Finished' AND OLD.status <> 'Finished' THEN
        INSERT INTO Delivery_Log (order_id, current_location, timestamp, note)
        VALUES (NEW.order_id, 'Tại điểm đích', NOW(), 'Delivery Completed Successfully');
    END IF;
END //
DELIMITER ;


-- Câu 2 (5đ): Viết Trigger trg_update_driver_rating. Mỗi khi một phiếu điều phối mới được thêm vào với trạng thái 'Finished', tự động cộng 0.1 điểm vào rating của tài xế đó (tối đa không quá 5.0).


DELIMITER //
CREATE TRIGGER trg_update_driver_rating
AFTER INSERT ON Delivery_Orders
FOR EACH ROW
BEGIN
    IF NEW.status = 'Finished' THEN
        UPDATE Shippers
        SET rating = LEAST(5.0, rating + 0.1)
        WHERE driver_id = NEW.driver_id;
    END IF;
END //
DELIMITER ;

/*
PHẦN 6: STORED PROCEDURE (20 ĐIỂM)
Câu 1 (10đ): Viết Procedure sp_check_payload_status nhận vào Mã phương tiện. Trả về tham số OUT message:
'Quá tải' nếu trọng tải thực tế của vận đơn > trọng tải tối đa của xe.
'Đầy tải' nếu trọng tải thực tế = trọng tải tối đa.
'An toàn' nếu trọng tải thực tế < trọng tải tối đa.
*/

DELIMITER //
CREATE PROCEDURE sp_check_payload_status(IN p_vehicle_id INT, OUT message VARCHAR(50))
BEGIN
    DECLARE v_max_payload DECIMAL(10,2);
    DECLARE v_actual_weight DECIMAL(10,2);
    
    SELECT max_payload INTO v_max_payload FROM Vehicle_Details WHERE vehicle_id = p_vehicle_id;
    
    SELECT s.actual_weight INTO v_actual_weight
    FROM Delivery_Orders d
    JOIN Shipments s ON d.shipment_id = s.shipment_id
    WHERE d.driver_id = (SELECT driver_id FROM Vehicle_Details WHERE vehicle_id = p_vehicle_id)
    ORDER BY d.dispatch_time DESC LIMIT 1;

    IF v_actual_weight > v_max_payload THEN
        SET message = 'Quá tải';
    ELSEIF v_actual_weight = v_max_payload THEN
        SET message = 'Đầy tải';
    ELSE
        SET message = 'An toàn';
    END IF;
END //
DELIMITER ;

/*
Câu 2 (10đ): Viết Procedure sp_reassign_driver để đổi tài xế cho một đơn hàng:
B1: Bắt đầu giao dịch.
B2: Cập nhật mã tài xế mới trong bảng Delivery_Orders.
B3: Ghi nhật ký vào Delivery_Log lý do 'Driver Reassigned'.
B4: COMMIT nếu thành công, ROLLBACK nếu lỗi.
*/

DELIMITER //
CREATE PROCEDURE sp_reassign_driver(IN p_order_id INT, IN p_new_driver_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
        UPDATE Delivery_Orders
        SET driver_id = p_new_driver_id
        WHERE order_id = p_order_id;
        
        INSERT INTO Delivery_Log (order_id, current_location, timestamp, note)
        VALUES (p_order_id, 'System Update', NOW(), 'Driver Reassigned');
    COMMIT;
END //
DELIMITER ;
