import sys
from datetime import datetime, timedelta

def main():
    branch_date_str = sys.argv[1]
    
    branch_date = datetime.strptime(branch_date_str, "%Y-%m-%d %H:%M:%S")
    
    current_date = datetime.now()
    
    delta = current_date - branch_date
    
    if delta > timedelta(days=90):
        sys.exit(1)
    else:
        sys.exit(0)


if __name__ == "__main__":
    main()