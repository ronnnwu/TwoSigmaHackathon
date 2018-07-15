from flask import Flask, session, render_template, jsonify, request
app = Flask(__name__)
app.secret_key = "super secret key"

playNum = '0'

@app.route('/')
def hello_world():
    return render_template('index.html')

@app.route('/get')
def getting():
    global playNum
    return jsonify({
            "id":  playNum
    })

@app.route('/submit')
def submit():
    global playNum
    playNum  = request.args.get("id")
    return jsonify({
            "id":  playNum
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
