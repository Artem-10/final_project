import http.server
import socket
import os

class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        hostname = socket.gethostname()
        ip_address = socket.gethostbyname(hostname)

        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()

        html = f"""
        <html>
            <body style='background-color: #0f172a; color: #38bdf8; font-family: sans-serif; display: flex; flex-direction: column; justify-content: center; align-items: center; height: 100vh; margin: 0;'>
                <h1>DevOps final project - SUCCESS!</h1>
                <p><b>Pod IP:</b> {ip_address}</p>
                <p><b>Hostname:</b> {hostname}</p>
                <div style='margin-top: 20px; padding: 10px; border: 1px solid #38bdf8;'>
                    Status: 200 OK
                </div>
            </body>
        </html>
        """
        self.wfile.write(html.encode())
if __name__ == '__main__':
    port = 8080
    print(f'Listening on port {port}')
    server = http.server.HTTPServer(('0.0.0.0', port), MyHandler)
    server.serve_forever()