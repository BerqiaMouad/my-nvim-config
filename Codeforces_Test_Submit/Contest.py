import requests
import werkzeug
werkzeug.cached_property = werkzeug.utils.cached_property
from robobrowser import RoboBrowser
from bs4 import BeautifulSoup
from termcolor import colored
from requests import Session
from requests.exceptions import ConnectionError
import pickle

class Contest:
    contest_number = 0
    contest_url = "https://www.codeforces.com/contest/"
    session = Session()
    browser = None

    # Constructor
    def __init__(self, contest_number):
        self.contest_number = contest_number
        # use browser to submit a code to the problem
        self.browser = RoboBrowser(parser='html.parser', session=self.session)

        # login 
        self.browser.open('https://codeforces.com/enter?back=%2F')

        # get the login form
        loginForm = self.browser.get_form(id='enterForm')

        # fill the login form
        loginForm['handleOrEmail'].value = 'Your Handle Here'
        loginForm['password'].value = 'Your Password Here'

        # submit the login form
        self.browser.submit_form(loginForm)

        # check if the login was successful
        if self.browser.url != 'https://codeforces.com/':
            print(colored('Login failed', 'red'))
            exit(0)

        else:
            print(colored('Login successful ✓', 'green'))


    # function to get the contest url
    def get_contest_url(self):
        return self.contest_url + str(self.contest_number)

    # function to get the contest page
    def get_page(self, URL):


        self.browser.open(URL)
        
        result = BeautifulSoup(self.browser.response.content, 'html.parser')

        return result

    # function to get all problems names in the contest
    def get_problems_names(self):
        contest_id = self.contest_number
        api_url = f"https://codeforces.com/api/contest.standings?contestId={contest_id}&showUnofficial=false"

        try:
            # Send a GET request to the API
            response = requests.get(api_url)
            data = response.json()

            # Check if the request was successful
            if data['status'] == 'OK':
                # Extract problem names from the response
                problems = data['result']['problems']
                problem_names = [problem['index'] for problem in problems]
                return problem_names
            else:
                print(f"Codeforces API request failed with message: {data['comment']}")

        except requests.exceptions.RequestException as e:
            print(f"An error occurred while making the API request: {e}")

        return []
    
    # function to get all testsets for a given problem
    def get_testsets(self, problem_name):
        testsets_input = []
        testsets_output = []
        url_problem = f"https://codeforces.com/contest/{self.contest_number}/problem/{problem_name}"
        problem_page = self.get_page(url_problem)
        problem_soup = problem_page

        #print(problem_soup)

        # get the testsets
        testsets_table = problem_soup.find('div', class_='sample-test')

        for testset in testsets_table.find_all('div', class_='input'):
            test = testset.find('pre').text
            temp = testset.find('pre').find_all('div', class_='test-example-line')
            test_text = ""
            start = False
            if(len(temp) == 0):
                test = test.split('\n')
                for line in test:
                    if line != '':
                        test_text += line + "\n"
                testsets_input.append(test_text)

            else:
                for line in temp:
                    if line != '':
                        test_text += line.text + "\n"
                testsets_input.append(test_text)

        for testset in testsets_table.find_all('div', class_='output'):
            test = testset.find('pre').text.split('\n')
            test_text = ""
            for line in test:
                if line != '':
                    test_text += line + "\n"
            testsets_output.append(test_text)

        return testsets_input, testsets_output

    def save_session(self):
        with open('session.pickle', 'wb') as f:
            pickle.dump(self.session, f)

