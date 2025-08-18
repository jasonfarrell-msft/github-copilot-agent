from fastapi import FastAPI
import uvicorn

# Create FastAPI application instance
app = FastAPI()

@app.get("/healthz")
def health_check():
    """Health check endpoint"""
    return {"message": "I am healthy"}

if __name__ == "__main__":
    # Start the server when the application runs
    uvicorn.run(app, host="0.0.0.0", port=8000)