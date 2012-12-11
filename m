Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2LKF7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 00:59:53 -0500
Received: from mail.active-venture.com ([67.228.131.205]:57234 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2LKF7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 00:59:51 -0500
X-Originating-IP: 108.223.40.66
Date: Mon, 10 Dec 2012 21:59:54 -0800
From: Guenter Roeck <groeck-dsl@sbcglobal.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.8-rc1
Message-ID: <20121211055954.GA2621@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon updates for Linux 3.8-rc1 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 9489e9dcae718d5fde988e4a684a0f55b5f94d17:

  Linux 3.7-rc7 (2012-11-25 17:59:19 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 44f751cee1b4baef9e3b49c6bd954f8b12b097a6:

  hwmon: (da9055) Fix chan_mux[DA9055_ADC_ADCIN3] setting (2012-12-05 10:55:55 -0800)

----------------------------------------------------------------
New driver: DA9055
Added/improved support for new chips in existing drivers: Z650/670, N550/570,
ADS7830, AMD 16h family

----------------------------------------------------------------
Ashish Jangam (1):
      hwmon: DA9055 HWMON driver

Axel Lin (2):
      hwmon: da9052: Use da9052_reg_update for rmw operations
      hwmon: (da9055) Fix chan_mux[DA9055_ADC_ADCIN3] setting

Boris Ostrovsky (1):
      x86,AMD: Power driver support for AMD's family 16h processors

Guenter Roeck (4):
      hwmon: (coretemp) Drop dependency on PCI for TjMax detection on Atom CPUs
      hwmon: (coretemp) Use model table instead of if/else to identify CPU models
      hwmon: (coretemp) Drop N4xx, N5xx, D4xx, D5xx CPUs from tjmax table
      hwmon: (coretemp) List TjMax for Z650/670 and N550/570

Guillaume Roguez (1):
      hwmon: (ads7828) add support for ADS7830

Vivien Didelot (1):
      hwmon: (ads7828) driver cleanup

Wei Yongjun (1):
      hwmon: (ina2xx) use module_i2c_driver to simplify the code

 Documentation/hwmon/ads7828           |   46 +++--
 Documentation/hwmon/coretemp          |    2 +
 Documentation/hwmon/da9055            |   47 +++++
 drivers/hwmon/Kconfig                 |   19 +-
 drivers/hwmon/Makefile                |    1 +
 drivers/hwmon/ads7828.c               |  247 ++++++++++--------------
 drivers/hwmon/coretemp.c              |   60 +++---
 drivers/hwmon/da9052-hwmon.c          |   27 +--
 drivers/hwmon/da9055-hwmon.c          |  336 +++++++++++++++++++++++++++++++++
 drivers/hwmon/fam15h_power.c          |    4 +
 drivers/hwmon/ina2xx.c                |   13 +-
 include/linux/platform_data/ads7828.h |   29 +++
 12 files changed, 607 insertions(+), 224 deletions(-)
 create mode 100644 Documentation/hwmon/da9055
 create mode 100644 drivers/hwmon/da9055-hwmon.c
 create mode 100644 include/linux/platform_data/ads7828.h

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQxsvaAAoJEMsfJm/On5mBknIP/irp7q0KiK0kUczgTA2Lq5ga
9N5kbJ3S7T4JuRLgQyPqDzIMgf9qpDk/WXNVcF39vux6t2Ofc+tcTzNbXM7DFXXm
qUt41j2/6v2o17hpfIXtgEEi2zDJSPFBfnfxf357dvjXj+kq/abpDHY1g6nL5i0g
lk4M40H9LsQMeQ7/6IDfQvTpjm7dxcFiq9cqm40kiTabWbo+PK0G43I2mfHvyBC7
TGI5DwywKyVNWgBAZ1HiFexirmnORtFof8YmqOrdxOOuEc5MTiX7wZLiMs6Xx9ZH
z8MVWIykC6MDex1RIZagnoM1CW1+5STb25iSEfBFFm8/PBSlULnJuMuh4pNgd2KW
RRtflWvQQQPQ563f8ZMqjWHZ9dNdIsB0YROP6ffNXf4pqD5pMWhJ0mq+6MLGyHJ3
paN9s7JlYI1tuzIMAryv/vkI+yvnZiVeZhcE13SLgaOpgjSTZy+7MxHzpoLilFJV
WUvlvQRGpcW+prKBD59d3nU5vAy13proV/yyFGJkil4Wbtj3qRENSSSZ3WvSEJxg
jxtGyCBJgeiS/8pZm6xdNNoQFmo79pio4TxnacKkoIjmiikm3fkCZyyAJNorZycY
idqqBquPL0iV9WckE8fBGJQy/7Niv3RgX4Vlg2lIrehIwrUXhYI/wES1Kkmgz1fw
Do/iwmmvUgnjgZHvjoef
=VZft
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
