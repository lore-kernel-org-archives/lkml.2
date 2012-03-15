Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031033Ab2COPip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:38:45 -0400
Received: from imr4.ericy.com ([198.24.6.9]:53411 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030995Ab2COPil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:38:41 -0400
Date: Thu, 15 Mar 2012 08:36:24 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.3-rc8/final
Message-ID: <20120315153624.GA11981@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.3-rc8/final from tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter

------

The following changes since commit fde7d9049e55ab85a390be7f415d74c9f62dd0f9:

  Linux 3.3-rc7 (2012-03-10 13:49:52 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Guenter Roeck (4):
      hwmon: (w83627ehf) Fix writing into fan_stop_time for NCT6775F/NCT6776F
      hwmon: (w83627ehf) Fix memory leak in probe function
      hwmon: (w83627ehf) Describe undocumented pwm attributes
      hwmon: (zl6100) Enable interval between chip accesses for all chips

Jean Delvare (1):
      hwmon: (w83627ehf) Fix temp2 source for W83627UHG

 Documentation/hwmon/w83627ehf |    9 +++++++--
 Documentation/hwmon/zl6100    |   14 ++++++--------
 drivers/hwmon/pmbus/zl6100.c  |   12 +++---------
 drivers/hwmon/w83627ehf.c     |   17 ++++++++---------
 4 files changed, 24 insertions(+), 28 deletions(-)

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYgx4AAoJEMsfJm/On5mBF/QP/joJny3gbI5fyB0hBF4eax2x
nKghdcAlMlAPXWOkQTbi+o4NuceWvRBI9OBhaYuYZdGv0DwBRpxsqbK7gXoRp852
kYsL48Rp7CXi190zoMyZaaCMatjuM//H/WVEarISpyknMymlD78Voqwaj9OVfhyJ
4H7DtVGR3qZLsqlUsEsM/eydi5i8CcgTjJczkkYL349DQSGo7PD2R1cAx20mGlt9
cgf0UaZnfSwUzNQqfVs7wR9rtQLO9EFvTvgdOAQSBIpcDM8v5yL5+wWZmQILa6IQ
Ob8VfNAbxw4Mm9Z9o3y24nG4CQPF+cbQoLGSlXhhKIfNSkXFE4gm6hVmriweh0Rz
vZLdjaFqjfoNk8l8bPeDJ49NYxU8DtGxWUetzau7Kbe0NawhCOwqiGEz2QeNvYq8
31FHHev/Qz2B/k3hUSIIKfa+63afgNkh58huiA08HqnQumDiyXHUeO1vV/EKuUnY
nOj8qVyxgwaPl9I44KZmRPIJQh5pUppgLoOTKSR1m6rwjiwVBIVvvhpFi5tJ0Moz
Zr/0DXahyQGgPpK8mRCha4JoMJ/BNzkrZOv39RsEdQsVq9xIGYpxhj6WSlU8PHuT
HbJpYmiOC5fa60I5EnCnjObOoNMX8yP6UodNSUTYWvyCfyCjNsknFtZAK4Da/bLi
z8FP7XIullegG62MNBa1
=1tiT
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
