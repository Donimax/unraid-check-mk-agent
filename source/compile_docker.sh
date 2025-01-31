# Set variables
DATA_DIR="/build/check_mk_agent"

# Download deb
cd ${DATA_DIR}
if [ -n "${CHECK_MK_URL}" ]; then
wget --no-check-certificate ${CHECK_MK_URL}
fi

# Define additional variables
DEB_NAME="$(ls -la ${DATA_DIR}/*.deb | cut -d '/' -f4)"
LAT_V="$(echo "$DEB_NAME" | cut -d '_' -f2 | cut -d '-' -f1)"
VERSION="$(echo "$DEB_NAME" | sed 's/[^0-9]*\([0-9]\+\)\.\([0-9]\+\).*/\1\2/')"

# Install needed Slackware packages
slackpkg -batch=on -default_answer=y install flex binutils

#Extract contents to temporary direction
cd ${DATA_DIR}
mkdir -p ${DATA_DIR}/deb ${DATA_DIR}/extracted
cd ${DATA_DIR}
mv ${DATA_DIR}/${DEB_NAME}  ${DATA_DIR}/deb/
cd ${DATA_DIR}/deb
ar x ${DEB_NAME}
tar -C ${DATA_DIR}/extracted -xvf ${DATA_DIR}/deb/data.tar.gz
rm -rf ${DATA_DIR}/extracted/etc/systemd ${DATA_DIR}/extracted/usr/lib/check_mk_agent/plugins ${DATA_DIR}/extracted/usr/share/doc/check-mk-agent/changelog.Debian.gz
cd ${DATA_DIR}/extracted
mkdir -p ${DATA_DIR}/$LAT_V

# Create Slackware package
makepkg -l y -c y ${DATA_DIR}/$LAT_V/check_mk_agent-"$(date +'%Y.%m.%d')".$VERSION.tgz
cd ${DATA_DIR}/$LAT_V
md5sum check_mk_agent-"$(date +'%Y.%m.%d')".$VERSION.tgz > check_mk_agent-"$(date +'%Y.%m.%d')".$VERSION.tgz.md5

# Move to packages folder and cleanup
mv check_mk_agent-"$(date +'%Y.%m.%d')".$VERSION.tgz check_mk_agent-"$(date +'%Y.%m.%d')".$VERSION.tgz.md5 /build/packages
rm -rf ${DATA_DIR:?}/*
