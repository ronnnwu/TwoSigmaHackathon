from flask import Flask, session, render_template, jsonify
app = Flask(__name__)
app.secret_key = "super secret key"

if session:
    session['playNum'] = '0'

@app.route('/')
def hello_world():
    return render_template('index.html')

@app.route('/get')
def getting():
    return jsonify({
            "id":  session.get('playNum', '0')
    })

@app.route('/submit')
def submit():
    session['playNum']  = request.args.get("id")
    return jsonify({
            "id":  session['playNum']
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
