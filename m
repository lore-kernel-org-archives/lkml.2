Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab2LQSmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:42:51 -0500
Received: from mail.active-venture.com ([67.228.131.205]:49696 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2LQSmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:42:50 -0500
X-Originating-IP: 108.223.40.66
Date: Mon, 17 Dec 2012 10:42:51 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.8-rc1
Message-ID: <20121217184251.GA10776@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.8-rc1 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit aed606e3bc1f10753254db308d3fd8c053c41328:

  Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu (2012-12-16 17:42:21 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 7764b5282e7e04ede3020d86787122887840e016:

  hwmon: (twl4030-madc-hwmon) Fix warning message caused by removal of __devexit (2012-12-16 18:21:33 -0800)

----------------------------------------------------------------
Fix fallout from __devexit removal

----------------------------------------------------------------
Guenter Roeck (1):
      hwmon: (twl4030-madc-hwmon) Fix warning message caused by removal of __devexit

 drivers/hwmon/twl4030-madc-hwmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQz2erAAoJEMsfJm/On5mBfFgP/0dxhTbSU6osYazXG0VVy9fk
H7EsrJ0QTWnC75k4emm9LYYCho8MfjUl36s1OpT2YXmBpmKUfFAtYJwpFDeiNB8q
93Wz5lGCfIL2AZm27WTBzftx3kJ9x6JOt/czE8Nxe4r73BoUh6hQJwwjBAthbXAm
oUlhbBSxkE8YQzNVUKWpLTmu4E8VkLILtcs2sUTLvwakPEotHXxwvVM2mJCvGgaI
nMQFFIOASM2hfvHh/kL35CyGDYVteELOzqIY8gx0yvG/DSxpt4BIHe0/xO7muQ9G
PKEPBK62Yu8pQjKnOgb6RTsbWhZozvcNIcVgxFALZ4kZTQaibCIJxh8N0E+R4Ibm
RbN0n1M6G/BXzll7VSXvvlqD6k+uS2IhL9lPpIpfN+i54KsCBR6gNGkOd59vCmWc
5hGDkKB9pGcoHqMtWMsu9ZoiZ8DvIvqAvxEYr8wDP/FjMJgtfqqI7EOPH99HerXq
l7/GFDIbFjl7R8uihP/vBwbSCb5PYu0kzxCWC2W1o+h90HcOMMbMP20Tx8Wvqi7N
QSSwYq7WMd13I32Mszic3P4U2IukqvjaMnhr3WIp2Bree2F95wADu0mTOwz9BG8C
rL2DlE/TiwRp6vYsb07bVQVpkf+HdiX9wWpK7VQ0xw1dR9yk1QJLE87Dbk7XOssz
5bioqO6Uz7iDVGjtg+gV
=tPrx
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
