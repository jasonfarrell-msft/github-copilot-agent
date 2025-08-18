from fastapi import FastAPI
import uvicorn
from datetime import datetime

# Create FastAPI application instance
app = FastAPI()

@app.get("/healthz")
def health_check():
    """Health check endpoint"""
    return {"message": "I am healthy"}

@app.get("/date")
def get_utc_time():
    """Get current UTC time"""
    utc_now = datetime.utcnow()
    formatted_time = utc_now.strftime("%Y-%m-%d %H:%M")
    return formatted_time

if __name__ == "__main__":
    # Start the server when the application runs
    uvicorn.run(app, host="0.0.0.0", port=8000)