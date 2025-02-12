import requests

def check_health(url):
    try:
        response = requests.get(url)
        if response.status_code == 200:
            print("Health   passed.")
        else:
            print("Health   failed.")
    except Exception as e:
        print(f"Health   error: {e}")

if __name__ == "__main__":
    check_health("http://http://20.83.190.156/:3000/health")