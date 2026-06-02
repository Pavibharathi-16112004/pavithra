-- ============================================================
--  MedAI Pro — MySQL Schema
--  MySQL Workbench / phpMyAdmin-ல இதை run பண்ணுங்க
-- ============================================================

CREATE DATABASE IF NOT EXISTS medai_pro CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE medai_pro;

-- ── USERS ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  username   VARCHAR(50)  UNIQUE NOT NULL,
  name       VARCHAR(100) NOT NULL,
  role       ENUM('admin','pharmacist','nurse','viewer') NOT NULL,
  email      VARCHAR(150) UNIQUE NOT NULL,
  password   VARCHAR(255) NOT NULL,
  initials   VARCHAR(5),
  active     TINYINT(1) DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── INVENTORY ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS inventory (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  item_id    VARCHAR(20)  UNIQUE NOT NULL,
  name       VARCHAR(200) NOT NULL,
  category   ENUM('drug','critical','supply','equipment') DEFAULT 'drug',
  stock      INT          DEFAULT 0,
  max_stock  INT          DEFAULT 500,
  reorder_pt INT          DEFAULT 100,
  daily_use  INT          DEFAULT 10,
  location   VARCHAR(100),
  expiry     DATE,
  barcode    VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ── SUPPLIERS ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS suppliers (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  supplier_id VARCHAR(20)  UNIQUE NOT NULL,
  name        VARCHAR(200) NOT NULL,
  contact     VARCHAR(100),
  phone       VARCHAR(20),
  email       VARCHAR(150),
  location    VARCHAR(200),
  category    VARCHAR(100),
  rating      DECIMAL(3,1) DEFAULT 0.0,
  pay_terms   VARCHAR(50),
  gst         VARCHAR(20),
  status      ENUM('active','inactive') DEFAULT 'active',
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── PURCHASE ORDERS ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS purchase_orders (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  po_id        VARCHAR(20) UNIQUE NOT NULL,
  supplier_id  INT,
  item_id      INT,
  quantity     INT         NOT NULL,
  unit_price   DECIMAL(10,2),
  total        DECIMAL(12,2),
  status       ENUM('pending','approved','delivered','cancelled') DEFAULT 'pending',
  ordered_by   INT,
  ordered_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  delivered_at TIMESTAMP NULL,
  FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
  FOREIGN KEY (item_id)     REFERENCES inventory(id),
  FOREIGN KEY (ordered_by)  REFERENCES users(id)
);

-- ── STOCK TRANSACTIONS ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS stock_transactions (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  item_id    INT NOT NULL,
  action     ENUM('stock_in','stock_out','adjustment','expired') NOT NULL,
  quantity   INT NOT NULL,
  before_qty INT,
  after_qty  INT,
  reason     VARCHAR(255),
  done_by    INT,
  done_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (item_id)  REFERENCES inventory(id),
  FOREIGN KEY (done_by)  REFERENCES users(id)
);

-- ── AUDIT LOGS ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS audit_logs (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  user_id    INT,
  action     VARCHAR(100) NOT NULL,
  module     VARCHAR(50),
  details    TEXT,
  logged_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ── ALERTS ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS alerts (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  type       ENUM('low_stock','expiry','reorder','system') NOT NULL,
  item_id    INT,
  message    TEXT,
  severity   ENUM('info','warning','critical') DEFAULT 'warning',
  resolved   TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (item_id) REFERENCES inventory(id)
);

-- ============================================================
--  SEED DATA
-- ============================================================

-- Users (passwords are plain — will be hashed by /setup endpoint)
INSERT INTO users (username, name, role, email, password, initials) VALUES
('admin',      'Dr. Admin',    'admin',      'admin@hospital.com',      'medai2024', 'DA'),
('pharmacist', 'Mary Patel',   'pharmacist', 'pharmacist@hospital.com', 'pharma123', 'MP'),
('nurse',      'Nurse Kumar',  'nurse',      'nurse@hospital.com',      'nurse2024', 'NK'),
('viewer',     'Dr. Viewer',   'viewer',     'viewer@hospital.com',     'view2024',  'DV');

-- Inventory
INSERT INTO inventory (item_id, name, category, stock, max_stock, reorder_pt, daily_use, location, expiry) VALUES
('MED-0042', 'Paracetamol 500mg',    'drug',      48,  500, 100, 15, 'Pharmacy Main', '2025-08-15'),
('MED-0187', 'Saline 500ml IV',      'critical',  112, 800, 200, 28, 'ICU Store',     '2025-12-01'),
('MED-0334', 'Surgical Gloves (L)',  'supply',    240,1000, 300, 16, 'OT Store',      '2027-01-01'),
('MED-0219', 'Insulin Syringes 1ml', 'critical',  310, 600, 150, 22, 'Diabetes Ward', '2026-03-15'),
('MED-0098', 'BP Monitor Cuff',      'equipment',  18,  50,  10,  2, 'Cardiology',    '2028-06-01');

-- Suppliers
INSERT INTO suppliers (supplier_id, name, contact, phone, email, location, category, rating, pay_terms, gst) VALUES
('SUP-001', 'BioMed Supplies Pvt Ltd', 'Ramesh Krishnan', '+91 98400 11223', 'ramesh@biomed.in',   'Chennai, TN',    'Pharmaceuticals', 4.8, '30 days', '33AABCB1234F1Z5'),
('SUP-002', 'MediCare Distributors',   'Priya Nair',      '+91 94440 22334', 'priya@medicare.in',  'Coimbatore, TN', 'Medical Supplies', 4.5, '45 days', '33BBBCD5678G2Z6'),
('SUP-003', 'HealthPlus Equipment Co', 'Arjun Sharma',    '+91 90000 33445', 'arjun@healthplus.in','Mumbai, MH',     'Equipment',        4.2, '60 days', '27CCCDE9012H3Z7');
