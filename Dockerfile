FROM dockerfile/ubuntu
MAINTAINER Brad Daily <brad@bradleyboy.com>

# Requirements for s3cmd
RUN apt-get install -y python-setuptools python-dateutil python-magic

# Get latest from sourceforge, apt versions are way old
RUN \
	wget http://sourceforge.net/projects/s3tools/files/s3cmd/1.5.0-rc1/s3cmd-1.5.0-rc1.tar.gz && \
	tar xvfz s3cmd-1.5.0-rc1.tar.gz && \
	cd s3cmd-1.5.0-rc1 && \
	python setup.py install

# Add backup script
ADD backup.sh /backup.sh
RUN chmod +x /backup.sh
CMD ["/backup.sh"]

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*