# Minimalista: HTTP server con la librería estándar (no Flask).
# Expone /healthz y lista de rutas básicas para DAST.
from http.server import HTTPServer, BaseHTTPRequestHandler
import json, os

class Handler(BaseHTTPRequestHandler):
    def _send(self, code, payload, ctype="application/json"):
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.end_headers()
        if isinstance(payload, (dict, list)):
            self.wfile.write(json.dumps(payload).encode())
        else:
            self.wfile.write(payload.encode())

    def do_GET(self):
        if self.path == "/healthz":
            self._send(200, {"status": "ok", "service": "ci-lab"})
        elif self.path == "/":
            self._send(200, "ci-lab: stdlib http.server demo")
        else:
            self._send(404, {"error": "not found", "path": self.path})

if __name__ == "__main__":
    port = int(os.getenv("PORT", "8080"))
    httpd = HTTPServer(("0.0.0.0", port), Handler)
    print(f"Serving on :{port}")
    httpd.serve_forever()
