Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2INEVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 00:21:16 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58712 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab2INEUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 00:20:45 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 13 Sep 2012 21:20:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.6-rc6
Message-ID: <20120914042051.GA20414@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.6-rc6 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 55d512e245bc7699a8800e23df1a24195dd08217:

  Linux 3.6-rc5 (2012-09-08 16:43:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 080b98e9ab30734bda2f1b8b33cd55a4c4ef406a:

  hwmon: (ina2xx) Fix word size register read and write operations (2012-09-12 06:42:11 -0700)

----------------------------------------------------------------
Fix word size register read and write operations in ina2xx driver, and
initialize uninitialized structure elements in twl4030-madc-hwmon driver.

----------------------------------------------------------------
Guenter Roeck (2):
      hwmon: (twl4030-madc-hwmon) Initialize uninitialized structure elements
      hwmon: (ina2xx) Fix word size register read and write operations

 drivers/hwmon/ina2xx.c             |   30 +++++++++---------------------
 drivers/hwmon/twl4030-madc-hwmon.c |    9 +++++----
 2 files changed, 14 insertions(+), 25 deletions(-)

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQUrCjAAoJEMsfJm/On5mB8v4P/jYlP0QN/lIbuPgG7mWCAWyw
7EYIdTAu/tE1HIjcXmx97p5b/cDA1jB4JTJs5KhOJp5FUccNEXaf6WS3Q7j4EppN
bUJrhsLJNqcwIgpyis2HNpedMxDhHDL4zlE6lVXt1joOokol3EERo2UHTH6N9+Lj
NhGgJjPCZkBQvMnizKelgOHx8G27sE47+g6sOzfC1252NsamMeWOHt1O0A+Z3UwH
IslcBOiRa8nULskFbDTjDYDdTCipbZFJeIG5u8VuyPPe17g/9AO6ufYsW9XppZDz
306ed1Ldz111WGR50geTXyT09VrF5DeFHOcqi01bB+N+NodGlvnrm8Rj92TSCP25
Oe+usfubzqDW7WFhBM1/NQ1i2bWuwufsIIRynqnXxI1yDLyXF5fVN3jM735LH1TO
2/T+XwPyRO9Ec+Z8kORGgMh4hPRlk+dtzkU6MnSMxzwYzoIZm2Mylv+WiJYexQt5
Ty1g8bwVRq+wtW6hJHrKHo9qPDh0/Dp+/Gl2oQEZxDWAPIRE3SlLyv4e4JN/fgdI
oSeo4sEaoRn7XDUhkrgfxpr50jaEp9WU481dY/Ojvw9Sy0gl/zkBTyX4Eid252BV
QyuyqZZEU/5IuCqCp0LQy41nIe5wiABC3ayIypjDVrqUQ0O5JlWOSIDf7s54Gf1L
YBoSUQ43H9UlLc/HEnNv
=Z2IP
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
