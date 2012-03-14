Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030624Ab2CNNH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 09:07:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57400 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757627Ab2CNNHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 09:07:24 -0400
Date: Wed, 14 Mar 2012 13:07:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [GIT PULL] regulator fixes for 3.3
Message-ID: <20120314130722.GK3133@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pN9MePJoZbRKbUk1"
Content-Disposition: inline
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pN9MePJoZbRKbUk1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit fde7d9049e55ab85a390be7f415d74c9f62dd0f9:

  Linux 3.3-rc7 (2012-03-10 13:49:52 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/for-linus

for you to fetch changes up to 9365121869a15da99d6091802f11a82d59024d62:

  regulator: da9052: Ensure the selected voltage falls within the specified range (2012-03-11 20:39:10 +0000)

----------------------------------------------------------------
Another small batch of driver specific bug fixes, a couple more errors
in the da9052 driver and a bad return value in the tps6524x driver.
----------------------------------------------------------------

Axel Lin (3):
      regulator: Fix setting selector in tps6524x set_voltage function
      regulator: Set n_voltages for da9052 regulators
      regulator: da9052: Ensure the selected voltage falls within the specified range

 drivers/regulator/da9052-regulator.c   |   12 ++++++++----
 drivers/regulator/tps6524x-regulator.c |    2 +-
 2 files changed, 9 insertions(+), 5 deletions(-)

--pN9MePJoZbRKbUk1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYJf1AAoJEBus8iNuMP3dSYcP/1W+5LSqI86ovOlzNeJSbUWM
4lZjzsu2HuY1seBdfk8tT3rjPd5SFajVWtQVqk01s7Ev5DQ0w7+q218Ilzzj/Eu7
2ZXrnvfQFn7jfq9utmb+DcYAgCUaBACAdxhAUNYhA49d27cTHg/xBES/26dPFbe2
YsRYpn22W++li6YQx17qT1J5KhIYh0cDdXbM7uGKsWtMVe33W3qHE/1mO7ncvKO9
/sjNzQiNbQh8c2zS6k+HLdHPMMApxndT8o/XBqBTmq7HLQBClMdAmjnY7EX7mOUq
pDvUBpBaaHYmqeb3WFw6XId7/UhooaIuwAkQ6TMGztiUL2Gq3jidV06uRfCkNpn0
8lZdH5t0L5R4cQOvYWV9M1T5n9GEseXLE6dQcPXedZmruwvHT4NoHLarRZRJBdUg
vLNvarI3uGPGgvQ6NmuF9Y5SZry4GXciFsq1e4Zb97pT7k3LgzyvjToU+wHnCpDy
ycODWoLX6a6TZ3Zw+jhxZYRJxoxYcy19OiSTaGtwfTvGVyHSp3891c6vhzdRA4vI
PzAh6HEJU0qEqFlcAcK5zXhRinjvJwerlFiI9K06oPy+GVgvKq3Rxefmxj2758C6
5qo8XCrA8zAyaExNEZtDymtEctJLKV+g4z++PyTw+4EOjQmEuEKtOyqRddX0GXmc
gYDlHSUScs/d1I14CaVr
=tdmw
-----END PGP SIGNATURE-----

--pN9MePJoZbRKbUk1--
