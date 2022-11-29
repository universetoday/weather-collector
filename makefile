# This file presents CLI shortcuts.
# Go there to find more details: https://makefiletutorial.com/#variables

migrations:
	docker-compose exec worker alembic upgrade head

initialization:
	docker-compose exec worker python manage.py fetch_cities

collecting:
	docker-compose exec worker python manage.py collect

app:
	docker-compose build
	docker-compose up -d
	make migrations
	make initialization
	make collecting




######################################################################
# development tools
######################################################################

.PHONY: venv	# to ignore such folder makefile get deal with
venv: ver := 3.10
venv: msg1 := "Vertual envirement already exist. Should be activated."
venv: msg2 := "Vertual envirement created. Activate it to use."
venv:
	@if [ -d "./venv/" ]; \
		then echo "$(msg1)"; \
		else \
			python$(ver) -m venv venv; \
			echo "$(msg2)"; \
	fi;


install:
	@echo "Is vertual envirement activated? (venv) "
	@echo "Enter to proceed. Ctr-C to abort."
	@read
	@pip3 install --upgrade pip;
	pip install black mypy autoflake isort
	pip install flake8 pep8-naming flake8-broken-line flake8-return flake8-isort

format:
	@autoflake --remove-all-unused-imports -vv --ignore-init-module-imports -r .
	@echo "make format is calling for autoflake, which  will remove all unused imports listed above. Are you sure?"
	@echo "Enter to proceed. Ctr-C to abort."
	@read
	autoflake --in-place --remove-all-unused-imports  --ignore-init-module-imports -r .
	black .
	isort .
	mypy .
	flake8 .


push:
	@git status
	@echo "All files listed above will be added to commit. Enter commit message to proceed. Ctr-C to abort."
	@read -p "Commit message: " COMMIT_MESSAGE; git add . ; git commit -m "$$COMMIT_MESSAGE"
	@git push

