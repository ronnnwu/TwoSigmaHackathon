using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Networking;
using System.IO;
using System.Net;

public class DisplayMultiples : MonoBehaviour {

	public Text myText;
	int i;
	string currentNo;
	int[] primes = new int[] {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61
		, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127};

	void Start () {
		i = 0;
		InvokeRepeating ("displayMultiples", 0f, 2.3f);
		myText = (Text)FindObjectOfType (typeof(Text));
		myText.text = "Eliminating multiples of " + currentNo.ToString();
	}

	void displayMultiples() {
		currentNo = getNumber();
		myText.text = "Eliminating multiples of " + currentNo.ToString ();
		i++;
		//currentNo = primes [i].ToString();
	}

	string getNumber() {
		var request = (HttpWebRequest)WebRequest.Create("http://localhost:8081/getNumber");
		request.Method = "GET";
		//request.UserAgent = "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36";
		//request.AutomaticDecompression = DecompressionMethods.Deflate | DecompressionMethods.GZip;
		var response = (HttpWebResponse)request.GetResponse();
		string content = string.Empty;
		using (var stream = response.GetResponseStream())
		{
			using (var sr = new StreamReader(stream))
			{
				content = sr.ReadToEnd();
			}
		}
		return content;
	}

}
