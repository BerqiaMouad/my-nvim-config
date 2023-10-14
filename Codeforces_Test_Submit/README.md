
# Codeforces Contest Setup Tool

This tool simplifies the process of setting up a Codeforces contest environment in your local directory. It can be used to create contest folders, copy template code, fetch test cases, and submit solutions to problems. Below, you'll find instructions on how to install and use this tool.

## Prerequisites

- Python 3.x installed on your system.
- The necessary Python packages (specified in `requirements.txt`) must be installed. You can install them using pip:

```bash
pip install -r requirements.txt
```

## Usage

#### 1. Clone this repository to your local machine

```bash
git clone <repository_url>
cd codeforces-contest-setup
```

#### 2. Set your Codeforces credentials in `Contest.py` and `submit.py`
```python
# fill the login form
loginForm['handleOrEmail'].value = 'Your Handle Here'
loginForm['password'].value = 'Your Password Here'
```
This step is done only once!

#### 3. Create a new contest

```bash
python cf.py <contest_id>
```

This will create a folder with the contest's ID, it contains input and output for each problem and C++ files with boiler plate for each problem as well.

#### 4. Run your code on sample test cases:

To test your code on the provided test cases, navigate to the contest folder and run the following:
```bash
python test.py <problem_name>
```

#### 5. To submit 
To submit your solution to a Codeforces problem, navigate to the contest folder and run:
```bash
python submit.py <problem_name>
```

## Important Notest!

+ The tool assumes you have Python, C++ compiler (g++), and the required Python packages installed.
+ Make sure to update your Codeforces handle and password in the `Contest.py` and `submit.py` files.
+ You can modify the C++ template code in each problem file as per your needs.
+ Ensure that your contest ID is correct when creating a contest folder.
+ Test your solutions thoroughly before submitting to Codeforces.

## Happy coding!
