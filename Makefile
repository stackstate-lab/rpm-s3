pypi-build:
	rm -rf ./dist
	python setup.py sdist

pypi-publish:
	twine upload -r pypi dist/*

test-upload-with-localhost-minio:
	rpm-s3 -b pkgr-development-rpm -p "test" --s3_endpoint_url $MINIO_ENDPOINT --s3_signature_version s3v4 test/blank-noop-app-1.0.0-20141120070739.x86_64.rpm
printenv:
	printenv
