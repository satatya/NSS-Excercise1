import http.server
import socketserver
import os

# Configuration
PORT = 80
DIRECTORY = "/srv/webfiles"

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

if __name__ == "__main__":
    # Ensure we are in the correct directory (optional safety check)
    if os.path.exists(DIRECTORY):
        os.chdir(DIRECTORY)
    
    print(f"Starting Web Server on Port {PORT} serving {DIRECTORY}...")
    
    # Create the server
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        print("Server is running. Press Ctrl+C to stop.")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nStopping server...")
            httpd.server_close()
