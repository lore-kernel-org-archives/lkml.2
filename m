Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab2CHQ7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 11:59:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37475 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855Ab2CHQ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 11:59:39 -0500
Date: Thu, 8 Mar 2012 16:59:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [GIT PULL] One more regulator fix for 3.3
Message-ID: <20120308165936.GR3638@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCKkSrrNUaKEhaIQ"
Content-Disposition: inline
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lCKkSrrNUaKEhaIQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 4adf9beda58364497889c06c1badf129a71d48be:

  regulator: Fix mask parameter in da9052_reg_update calls (2012-03-05 12:28:58 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/for-linus

for you to fetch changes up to c4632aed3e5b134c55b54af19db49662959384c1:

  regulator: tps65910: Configure correct value for VDDCTRL vout reg (2012-03-07 19:28:37 +0000)

----------------------------------------------------------------
Another small, clear fix in a specific driver.
----------------------------------------------------------------

Laxman Dewangan (1):
      regulator: tps65910: Configure correct value for VDDCTRL vout reg

 drivers/regulator/tps65910-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--lCKkSrrNUaKEhaIQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWOVNAAoJEBus8iNuMP3d3qAP/iSPbWapWgzuPHoDySgg80nv
/M+9zJm0peJXYDbSQ57oJjbOBBkoUd3NeezPeYMdhgzd6xFzYwsb8Iu+NHYJqrd2
KDW7MdKRxZ+cQzlL3avnnU5Fs8nZQKA/iFOaDwi9zLzAIUssqPh8mIhlMLuiDxc3
U593hzVPssaPtBCBrBBLzuVRoI2h/HHjmHooaCVKzvwJ/rlTqc5jJDWfqPi7cm3/
0ufPhSDedpUzjxySAEzUMq3fabH1fQFsKHgweczI+swFRU4AtK+vOnpwhArMLjVQ
xUO9Qja34X1pTHZ4mXOyXdkZ2yQB9prHj573kZIN2pGF+WA/mL2CHvDjojuguPKx
ePgcYjDCSYJ3QV7mEjV4fQk6DPB0qasXTxlJf7PsykxhaRCObibc0VeljUInvkiT
Gc2DtsoWI0tvCNZapCLCfT/j+Zfk7mqJDGMY9Ghq7NIbWr1qtYAQ95h2frFgvidj
cdgFzTgWNwJkZgaWXeIJ+MbDoB8/Xx+tpktwSr48jXwZSzbXMA0AZoLOu08+2RNS
cV+qGR4Nvvr73ZXJCc8/vuI/nKi79d8/eQqV4Lrma6OYf028zJOS7lrQhb9c+w4r
4qSL5tbAynCgY7PlbVlGITbx+93hwv4y0hNiJvk/wxMX9jkX84+bozo+SrD2Q5nq
3ySi/i8Bw5qfs5qX0Ep4
=r8+A
-----END PGP SIGNATURE-----

--lCKkSrrNUaKEhaIQ--
