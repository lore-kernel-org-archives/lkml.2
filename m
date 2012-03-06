Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030541Ab2CFMVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:21:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37969 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030501Ab2CFMVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:21:39 -0500
Date: Tue, 6 Mar 2012 12:21:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [GIT PULL] regulator update for 3.3
Message-ID: <20120306122136.GN19635@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QGBKWVSgmlsIyJ+t"
Content-Disposition: inline
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QGBKWVSgmlsIyJ+t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 192cfd58774b4d17b2fe8bdc77d89c2ef4e0591d:

  Linux 3.3-rc6 (2012-03-03 17:08:09 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/for-linus

for you to fetch changes up to 4adf9beda58364497889c06c1badf129a71d48be:

  regulator: Fix mask parameter in da9052_reg_update calls (2012-03-05 12:28:58 +0000)

----------------------------------------------------------------
A simple fix that's obvious from inspection.  There's no mainline users
of this driver yet (there's some i.MX platforms which will use it).
----------------------------------------------------------------

Axel Lin (1):
      regulator: Fix mask parameter in da9052_reg_update calls

 drivers/regulator/da9052-regulator.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

--QGBKWVSgmlsIyJ+t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVgFAAAoJEBus8iNuMP3dxQcP/jgKaWTob3DYPg/9FnIX3d1a
ML0sGDDd6OzHu+gFy8LuuIFG+3ZmjZ1C/OgjuTsvdEnkFQBTS32/hgq45rdsm8dJ
T5GxKjNTDizazTrQmr4AEXDUWALjgLpY0Tv6CXzPwBoRWjmlbqPiJUrdhS86oIKx
nEaVJTi9hYmSwUDSHt3zTxG+hrrDUPzqndX4MenL1WGo3IuVYCPgX9zT4OtCXkHa
7JpGx/aqOWjHlz027ANDXQXj+0hBK53OrYG9+tbaBf+a3Xkj6lXXoeUn4eywXFMi
MQmQT3cn1KcjXzrBeQDL6cNUeVfeUegk/oAnHXh3mlTubXJoiTPo5REXV2SUByN3
PUN6yRIbNEbjDY4tCDOnMCE8r3LsEMkQtAwh8XO78wEoxhp8udkTjaNsaVjKyBHB
LAabWvEPQgn08/nIQaQ6hQybgEkVRk+81qtr6Ic7oQnXX7AkL8ae3JmSGEbmIgTy
yIRBXmeUBWRswiqMWvxaGokNe6kMWD/mWwb5Wow3b77+4lkP3m2s5jN0sbhprBNN
4AoKotilbVBY2w7YiKcGk7XRkIH9+JtEFe5nPS3zjtfR5yq7OjL5ZsvczQzTtqC5
2q2gw95yejCf+frsLocsOPi1cHxDDnOmL5wYGyD1a6cdMdCoaTLeYw8JjoNptqAh
XeFts8QokdKxUGy7GoRN
=bSpl
-----END PGP SIGNATURE-----

--QGBKWVSgmlsIyJ+t--
