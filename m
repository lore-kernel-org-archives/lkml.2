Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab1IZPNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:13:07 -0400
Received: from imr3.ericy.com ([198.24.6.13]:48092 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab1IZPNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:13:06 -0400
Subject: [GIT PULL] hwmon fixes for 3.1
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-XHL6YmKMEo7cPPG8p5xy"
Organization: Ericsson
Date: Mon, 26 Sep 2011 08:11:38 -0700
Message-ID: <1317049898.3888.53.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-XHL6YmKMEo7cPPG8p5xy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull hwmon subsystem fixes for Linux 3.1 from:

    git://github.com/groeck/linux.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit
d93dc5c4478c1fd5de85a3e8aece9aad7bbae044:

  Linux 3.1-rc7 (2011-09-21 16:58:15 -0700)

are available in the git repository at:
  git://github.com/groeck/linux.git hwmon-for-linus

Chris Peterson (1):
      hwmon: (w83791d) rename prototype parameter from 'register' to
'reg'

Guenter Roeck (1):
      hwmon: (coretemp) Don't use threshold registers for tempX_max

Jan Beulich (3):
      hwmon: (coretemp) don't use kernel assigned CPU number as platform
device ID
      hwmon: (coretemp) constify static data
      hwmon: (coretemp) remove struct platform_data * parameter from
create_core_data()

Jean Delvare (2):
      hwmon: (coretemp) Drop duplicate function get_pkg_tjmax
      hwmon: (coretemp) Let the user force TjMax

Roland Stigge (1):
      hwmon: (ds620) Fix handling of negative temperatures

 Documentation/hwmon/coretemp |   14 +--
 drivers/hwmon/coretemp.c     |  193
+++++++++---------------------------------
 drivers/hwmon/ds620.c        |    2 +-
 drivers/hwmon/w83791d.c      |    4 +-
 4 files changed, 47 insertions(+), 166 deletions(-)


--=-XHL6YmKMEo7cPPG8p5xy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOgJYnAAoJEANmWzN1g3l3fPQH/R3i6Fe+h9KQFvmwOvSMean7
q9TW4GEYh9dafxY1+voUR1sr9U1Jq4h3rgL34CZqTU/UOyUBHyFhGUfywPmjVROj
/0hFPnDRZOmGlAh4boX0OOnlmlbyni3pcx7rJCi0aNMuXs7hRfV2gOXtdrCfkOKW
UHZuMF3k3lcTdYXk1vWDCVRsTUvR2DXJzxwHDNNquVL/StHrcq325+ktQNT9H6Zm
FLtGdcWJKsNkg6oiFaw6ETNKclTSa0H6T9BbvjyjRgSOmp6ghKc++1hFi0GPbZsi
c1zoYLENCTFmO5fJXHa/4YmTJ6Ujq5Ts4fOwB5Ldp6WgOVkoJkwm3NdWuAdg7eU=
=726f
-----END PGP SIGNATURE-----

--=-XHL6YmKMEo7cPPG8p5xy--
