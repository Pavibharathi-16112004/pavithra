# main.py — MedAI Pro FastAPI Entry Point
# Run: uvicorn main:app --reload --port 8000

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os

load_dotenv()

from routers import auth, inventory, suppliers, dashboard

app = FastAPI(
    title       = "MedAI Pro API",
    description = "AI-Based Medical Inventory Management — Backend API",
    version     = "1.0.0",
    docs_url    = "/docs",    # Swagger UI → http://localhost:8000/docs
    redoc_url   = "/redoc"
)

# ── CORS — Frontend access allow பண்றது ──────────────────────
app.add_middleware(
    CORSMiddleware,
    allow_origins     = ["http://localhost:5500", "http://127.0.0.1:5500",
                         "http://localhost:3000",  "null"],
    allow_credentials = True,
    allow_methods     = ["*"],
    allow_headers     = ["*"],
)

# ── Routers ───────────────────────────────────────────────────
app.include_router(auth.router)
app.include_router(inventory.router)
app.include_router(suppliers.router)
app.include_router(dashboard.router)

# ── Health Check ──────────────────────────────────────────────
@app.get("/api/health", tags=["Health"])
def health():
    return {
        "status":  "✅ MedAI Pro API Running",
        "version": "1.0.0",
        "docs":    "http://localhost:8000/docs"
    }

# ── Startup message ───────────────────────────────────────────
@app.on_event("startup")
async def startup():
    print("\n" + "="*45)
    print("  🏥 MedAI Pro — FastAPI Backend Started!")
    print("  📡 http://localhost:8000")
    print("  📋 Swagger Docs: http://localhost:8000/docs")
    print("="*45 + "\n")
