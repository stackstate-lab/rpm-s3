pypi-build:
	rm -rf ./dist
	python setup.py sdist

pypi-publish:
	twine upload -r pypi dist/*

