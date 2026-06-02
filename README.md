# 🏥 MedAI Pro — Complete Project
### AI-Based Medical Inventory Management System
### Frontend (HTML/CSS/JS) + Backend (Python FastAPI) + Database (MySQL)

---

## 📁 Project Structure

```
MedAI_Pro_Complete/
│
├── frontend/                   ← Open in browser
│   ├── index.html              ← Main app (open this)
│   ├── style.css               ← All styles
│   ├── app.js                  ← UI logic
│   └── api-integration.js      ← Backend connector ← NEW
│
└── backend/                    ← Python FastAPI server
    ├── main.py                 ← Entry point → run this
    ├── requirements.txt        ← pip install -r this
    ├── database.sql            ← MySQL setup → run this first
    ├── .env.example            ← rename to .env
    ├── config/
    │   ├── database.py         ← MySQL connection pool
    │   └── auth.py             ← JWT helpers
    ├── models/
    │   └── schemas.py          ← Request/Response models
    └── routers/
        ├── auth.py             ← Login, OTP, Password reset
        ├── inventory.py        ← CRUD + AI Forecast
        ├── suppliers.py        ← Suppliers + Purchase Orders
        └── dashboard.py        ← Stats, Alerts, Audit logs
```

---

## ⚡ Setup — Step by Step

### STEP 1 — MySQL Database Setup
1. MySQL Workbench திறங்க
2. `File → Open SQL Script → backend/database.sql`
3. ⚡ Run பண்ணுங்க
4. Left side-ல `medai_pro` database தெரியணும்

---

### STEP 2 — Backend Setup

```bash
# Terminal 1 திறங்க, backend folder-க்கு போங்க
cd backend

# Virtual environment create பண்ணுங்க
python -m venv venv

# Activate பண்ணுங்க
venv\Scripts\activate        # Windows
source venv/bin/activate     # Mac / Linux

# Packages install பண்ணுங்க
pip install -r requirements.txt

# .env file create பண்ணுங்க
copy .env.example .env       # Windows
cp .env.example .env         # Mac / Linux
```

**.env file திறந்து MySQL password மாத்துங்க:**
```
DB_PASSWORD=உங்கள்_mysql_password
```

**Server start பண்ணுங்க:**
```bash
uvicorn main:app --reload --port 8000
```

✅ இது Console-ல தெரியணும்:
```
🏥 MedAI Pro — FastAPI Backend Started!
📡 http://localhost:8000
📋 Swagger Docs: http://localhost:8000/docs
```

---

### STEP 3 — Hash Passwords (ஒரே ஒரு தடவை மட்டும்!)

Browser-ல இதை open பண்ணுங்க:
```
http://localhost:8000/docs
```
`POST /api/auth/setup` → **Try it out** → **Execute**

---

### STEP 4 — Frontend Open பண்ணுங்க

VS Code-ல `frontend/index.html` → **Live Server** button click பண்ணுங்க

OR simply browser-ல:
```
frontend/index.html
```

Bottom-right corner-ல **🟢 Backend Online** தெரிஞ்சா எல்லாம் connected! ✅

---

## 👤 Login Credentials

| Role | Email | Password |
|------|-------|----------|
| 🏥 Admin | admin@hospital.com | medai2024 |
| 💊 Pharmacist | pharmacist@hospital.com | pharma123 |
| 🩺 Nurse | nurse@hospital.com | nurse2024 |
| 👁 Viewer | viewer@hospital.com | view2024 |

---

## 🔗 API Endpoints

| Method | URL | Description |
|--------|-----|-------------|
| POST | /api/auth/login | Login |
| POST | /api/auth/forgot-password | Send OTP |
| POST | /api/auth/verify-otp | Verify OTP |
| POST | /api/auth/reset-password | Reset password |
| GET  | /api/inventory | All inventory |
| POST | /api/inventory | Add item |
| PUT  | /api/inventory/{id} | Edit item |
| DELETE | /api/inventory/{id} | Delete item |
| POST | /api/inventory/{id}/stock | Stock in/out |
| GET  | /api/inventory/{id}/forecast | AI Forecast |
| GET  | /api/suppliers | All suppliers |
| GET  | /api/suppliers/orders | Purchase orders |
| POST | /api/suppliers/orders | Create PO |
| GET  | /api/dashboard/stats | Dashboard stats |
| GET  | /api/dashboard/alerts | Active alerts |
| GET  | /api/dashboard/reorder | Reorder list |
| GET  | /api/dashboard/audit | Audit logs |

---

## 🌟 Swagger UI

Backend running-ஆ இருக்கும் போது:
```
http://localhost:8000/docs
```
Interactive API testing — **Project review-ல demo பண்ண perfect!**

---

## ❓ Troubleshooting

**🔴 Backend Offline badge தெரிஞ்சா:**
- Terminal-ல `uvicorn main:app --reload --port 8000` running-ஆ இருக்காஆ?
- .env-ல DB_PASSWORD correct-ஆ இருக்காஆ?
- MySQL service running-ஆ இருக்காஆ?

**CORS Error console-ல தெரிஞ்சா:**
- frontend VS Code Live Server-ல port 5500-ல run ஆகுதா?
- backend .env-ல `FRONTEND_URL=http://localhost:5500` இருக்காஆ?

**Password wrong-ஆ சொன்னா:**
- `http://localhost:8000/docs` → `POST /api/auth/setup` run பண்ணுங்க
