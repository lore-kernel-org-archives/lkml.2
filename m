Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab2HZRjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 13:39:37 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65081 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab2HZRjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 13:39:36 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 26 Aug 2012 10:39:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.6-rc4
Message-ID: <20120826173940.GA32304@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.6-rc4 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 43ca6cb28c871f2fbad10117b0648e5ae3b0f638:

  hwmon: (asus_atk0110) Add quirk for Asus M5A78L (2012-08-22 22:33:31 -0700)

----------------------------------------------------------------
Fix sensor readings for Asus M5A78L in asus_atk0110 driver.

----------------------------------------------------------------
Luca Tettamanti (1):
      hwmon: (asus_atk0110) Add quirk for Asus M5A78L

 drivers/hwmon/asus_atk0110.c |    6 ++++++
 1 file changed, 6 insertions(+)

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQOl9cAAoJEMsfJm/On5mBoaQP/A1hokwMqpm3G39OPA2NHjAA
tBQaE3FXI+T7wm3UdxwwY2WfyCDVKCVGagetHZ6kriyOD5B3ETdLs8zmnJMwrAvK
arKtfPY5bm8ECxtjdnsnfpV5XxYqRIlpUiyskgBE5zTWVwFDemzb9B5VOCpxCIkt
EqRACOcNSKGbjBBdupcBv4VAOkw+BYZvsH9kuk/8Uv7SYaQjxtageVuCtsuBqE6A
FYtnTlrjRVT7yD7G4uKcBegCbMs3vAw6nHVw371/YU7RZ3zd+COaG4saror1k5/q
oE4ihMcHdlvAKQV4Oe19yPXydtbeqc0snzyPG1edEWq2qfo2O5NeUhYwzTVNUwiN
5pMFhhPPgxm+qcDHo84vvVPR/Ve+uGTx9gGTfQpQnuFesXoXzFUpAEsamLUP0YEF
o7cf4+VRdWeF3uAv/1/XOfuEn+8o+xUCf0xO+vv7x1zAwHXZJP0/DyKSpifuD2qf
qb1WPF3Bqe1KTKySuxmh2i5o65GC9iXCzEQW6x3xjddncGxJegs6i0otYcNb4Au3
UfSFCuVvakGsN8qPP/SlMNg4NoapX1xYAv7UtP6wYBa4FS1yKq90mYQD6rg6OR1H
OdjnaJCpSiytayARmri6pRv0dTiL0OB44/wdP0jauYlhusv0ete7kBNFW6lo4U6y
jyGTwOwBaoSAZeUjgpP2
=PIh5
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
