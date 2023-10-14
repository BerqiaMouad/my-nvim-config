from termcolor import colored
from Contest import Contest
import requests
from bs4 import BeautifulSoup
import sys
import os
import datetime


if __name__ == "__main__":
    # clear the terminal
    os.system("cls")

    print()
    # print a message while the program is running
    print(colored("Fetching the contest data...", "yellow"))

    # get the first argument passed in the command line
    contest_id = sys.argv[1]
    
    # create a contest object
    contest = Contest(contest_id)

    
    # problems names
    problems_names = contest.get_problems_names()

    # create a directory for the contest
    os.mkdir(contest_id)

    # copy test.py to the contest directory and do not display any output
    os.system("copy test.py %s > nul" % contest_id)
    os.system("copy submit.py %s > nul" % contest_id)

    # change the current directory to the contest directory
    os.chdir(contest_id)

    # create a c++ file for each problem and write in it a template
    for problem_name in problems_names:
        file = open(problem_name + ".cpp", "w")
        file.write('''
/*

Problem: %s
Date: %s

*/

// put your template c++ code here

''' % (problem_name, datetime.datetime.now().strftime("%d/%m/%Y")))
        file.close()
    

    # create a directory for the testsets for each problem
    for problem_name in problems_names:
        os.mkdir(problem_name)

    
    # create a text file for each problem, if the problem has multiple testsets then create a text file for each testset
    
    for problem_name in problems_names:
        print(colored("Getting Testsets for problem %s..." % problem_name, "yellow"))
        os.chdir(problem_name)
        # get the testsets of the problem
        inputs, outputs = contest.get_testsets(problem_name)

        # create a text file for each testset
        for i in range(1, len(inputs) + 1):
            file = open("in" + str(i) + ".txt", "w")
            file.write(inputs[i - 1])
            file.close()

        # create a text file for each testset
        for i in range(1, len(outputs) + 1):
            file = open("out" + str(i) + ".txt", "w")
            file.write(outputs[i - 1])
            file.close()

        os.chdir("..")

    contest.save_session()
    
    print(colored("Done ✓", "green"))
    print()

    print(colored("Contest number: ", "blue") + colored(contest_id, "yellow"))
    print()

    
