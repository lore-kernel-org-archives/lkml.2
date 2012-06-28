Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2F1TNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 15:13:47 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63698 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2F1TNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 15:13:46 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 28 Jun 2012 12:14:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.5-rc5
Message-ID: <20120628191402.GA20318@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.5-rc5 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 6b16351acbd415e66ba16bf7d473ece1574cf0bc:

  Linux 3.5-rc4 (2012-06-24 12:53:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

for you to fetch changes up to bb9a80e5719abae235c7e9c7391a3a17b64a217b:

  hwmon: Update my e-mail address (2012-06-25 06:46:24 -0700)

----------------------------------------------------------------
hwmon changes for 3.5-rc5:

e-mail address updates

----------------------------------------------------------------
Guenter Roeck (1):
      hwmon: Update my e-mail address

Jesper Juhl (1):
      hwmon: (applesmc) correct email address for Jesper Juhl

 drivers/hwmon/applesmc.c    |    2 +-
 drivers/hwmon/jc42.c        |    2 +-
 drivers/hwmon/lineage-pem.c |    2 +-
 drivers/hwmon/ltc4261.c     |    2 +-
 drivers/hwmon/max16065.c    |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJP7Kz6AAoJEMsfJm/On5mBbDUP/10aXshFegLaqq/Q/6MJcy4d
Nxi2ebiZ86IepcxxT8eUAIFt06GgJojzMdrY8OLx2UPYswMTDAiwCcfRRgiDhqzg
a0PxaSBuNsuBgHhxSc+uVWzMRE1kGgCl08Vjm2/FU5gls3y+15g7WF61hvszdJ5C
goKffxaFMjDJK5FsqYvfmXG78RcUzMvi0Vu9S7frVGZVaumpRWgKNUVHHCuAcggC
W/tCZvmGSmaAW4SGFttA4IzzfqeM9vwQzTWdt3QXCW90As2mK64mQwoMhCFqpIKe
+e3tnuyrTZjHX3kcFQL5DZOUkZzM7/H8gfGsNPvUd8lD+6w70biZnhDRBr0vjs2N
vRDEQaTqJWobIuDM+rXWAKc/1RVL+2JOqBBrA0xlFEhlA9LUJzcjq4kDfJV7HTQ3
G0LxycbtwX+0MTGmo1q9gzrP0X9n02zD1y4YnrXT+2xt4o+ExyMU51RQRldTnQ0I
IUXqyNDlGG70UGP/KmAAs/V5psCyFCdl+DEjcYaw/UEVuUb5SmeVPCFqyzlm8my9
QhfP5UTu+Kjfrdspdam0lRpEPiu/X0dy7fqQiyJ9KbGjsz9rAvr5+WI2TnPgvJsr
7TZQc+GPySxplFMFzl1yKbg2INPJpl0W75AmNUKSGPKLdk5WHCE6e2TF7X3T/pjS
vjxbkAQ1At1nw8/9TppG
=kh3/
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
