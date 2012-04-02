Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2DBOFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:05:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32924 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732Ab2DBOFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:05:00 -0400
Date: Mon, 2 Apr 2012 15:04:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap updates for 3.4
Message-ID: <20120402140458.GB15197@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-3.4

for you to fetch changes up to 4b4e9e43fd210e0cd2a5d29357e7c000e13e08ae:

  regmap: rbtree: Fix register default look-up in sync (2012-04-01 11:47:13 +0100)

----------------------------------------------------------------
A simple bug that's been lurking for a while but not terribly visible
since a high proportion of chips have no register 0 so the normal
failure is that we end up doing a bit of extra I/O.
----------------------------------------------------------------

Lars-Peter Clausen (1):
      regmap: rbtree: Fix register default look-up in sync

 drivers/base/regmap/regcache-rbtree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPebH/AAoJEBus8iNuMP3dWi8QAJiROkTQig3m4jlke7GDD8BS
XCIsMaP0RcF5ubE/rWdBTRdmzAE83/atGRkbBh0ZBimA+zncOjvz/JE/rmeYqviP
rCrxt2w4VjmKMqwyEiZWGoy+sc16YPXdZsyqMlCmu4XEr0WF05uc0WwYue65GRCj
EY+Yxn5cFUUbjZCL7DFh9Se7VllTkn8s7PPtkgyYJGpvXhTcnN9MVEC24lALSm0N
C1l0kPRTA6ybKIA53kEoAZZ8aqUIhj/VjB/gK9F0NevUU3NYXhhu8eNwhG3rDXwq
/95o/RtTSfSEipPFZzIMwazkzeKIfAXPjHekriBh4kFTq6w55KE5D3sKFVLea3AG
XJF41Z0IszmUlFe5eJNLpg8PlwUTL6frpYe1yzoc7PrR5choPNNy+yxfKmddKqhK
4VjH/mYNrW5M6Hqp/OiV4/6GcrxrjhucaaNPnLpaq17qHypZfgHy9YvWON/S4dwc
Ib292dz2wbDfY0HmnzhVzD1fxl8z//Gv2ivIP/dfTc0uk8RevVvpb4EaduNW+EWw
A/QxqpSzf+ZVHqeLpkQ3/jE6d1yzZnsox87zFnfZS4Dxgz5jjGyawWcS0h8lsSfx
xeAoRTA9WaiNVfPNbwGjw29IbbuPAEL5W8RS/Vymumwup9trSjR+/Msq+ziUVXUT
oW7pAcFSFAjtNwaqzBnL
=cQpC
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
