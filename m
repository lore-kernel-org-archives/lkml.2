Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2HTMOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 08:14:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49206 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753576Ab2HTMNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 08:13:54 -0400
Date: Mon, 20 Aug 2012 13:13:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [GIT PULL] regulator updates for 3.6
Message-ID: <20120820121352.GB26991@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/=
regulator-3.6

for you to fetch changes up to 908d6d52928a7f2a4b317aac47542c5fbef43d88:

  regulator: twl-regulator: fix up VINTANA1/VINTANA2 (2012-08-15 17:19:01 +=
0100)

----------------------------------------------------------------
regulator: Updates for 3.6

A bunch of fixes which are a combination of minor fixes that have been
shaken down due to greater testing exposure, the biggest block of which
are for the Palmas driver which hadn't had all the changes required for
mainline properly tested when it was merged.

----------------------------------------------------------------
Aaro Koskinen (1):
      regulator: twl-regulator: fix up VINTANA1/VINTANA2

Axel Lin (5):
      regulator: palmas: Fix calculating selector in palmas_map_voltage_ldo
      regulator: palmas: Fix regmap offsets for PALMAS_REG_SMPS10 vsel_reg
      regulator: palmas: Call palmas_ldo_[read|write] in palmas_ldo_init
      regulator: palmas: Fix palmas_probe error handling
      regulator: anatop: Fix wrong mask used in anatop_get_voltage_sel

Heiko St=FCbner (1):
      regulator: gpio-regulator: Split setting of voltages and currents

Laxman Dewangan (1):
      regulator: tps6586x: correct vin pin for sm0/sm1/sm2

Linus Walleij (1):
      regulator: ab3100: add missing voltage table

Marek Szyprowski (1):
      regulator: core: request only valid gpio pins for regulator enable

Mark Brown (1):
      regulator: twl: Remove references to the twl4030 regulator

 .../devicetree/bindings/regulator/tps6586x.txt     |   12 +++----
 drivers/regulator/ab3100.c                         |    1 +
 drivers/regulator/anatop-regulator.c               |    5 +--
 drivers/regulator/core.c                           |    2 +-
 drivers/regulator/gpio-regulator.c                 |   38 +++++++++++++---=
----
 drivers/regulator/palmas-regulator.c               |   23 +++++++-----
 drivers/regulator/tps6586x-regulator.c             |    8 +++--
 drivers/regulator/twl-regulator.c                  |    5 ++-
 8 files changed, 59 insertions(+), 35 deletions(-)

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQMimAAAoJEFJkBDiqVpZ4sccP/2rTUfAiEz6TqWU5OfdKFXSv
vmzdkZCycqSIWMRp3kJAxQBfY+7JuWcx7dUONeT20c9faUkltJ06nRaCkXMzNADr
SZumbQFz2xTvLKWB7jZJzHwcGQth+p+czNhih3sZ83ym7zHmtESCCDBYX0p8NP0S
EQHCIbhBbddaxPI1Fk0TjCBcg9qntoYdtkYCK6doovnTreMbqvryc2sG/mHXsEPB
F7htXiCaOZwFmWSbAG4vfb3kb5/bZq8LNcTVp/O4fl3IzSC07Ey37wsmIuPdNjEW
UiuNjzldx/BIrjNF4CLfRf6Cpvgu5nRhdFDavMjrtIZKwlwm1jPXuISEruBtgDsG
wCN9k3vhthc45hkSkuEjWFXOXr/Hv44vJjKuVHyBf4tFhEc57A8P5Lui3CL6dc9w
gO4tlYYHsPy0JFKaB7Lm256PfAsZOd7Uo+3k9SWDcq6Ncx/R780SM3gF2cohvVRJ
Q4TScB7RrZJ85wVri/rVw3t8Ww1YShewBeiG4VFamYI3lbDPV9esEM3KP3lPynba
zJMZIA2xahR0HZrJR5ah0rPgitZRZwfopPIdVDNbcF5oqQP6u3SuFtvlT4oG2agJ
Ihy+hJPjEUxceWfo61kEiLktD/dRnDBOnord6jiVz7vuDAg+QKOCmyhkbX9Ldecq
wzkfHs9Aof+2palIK7EK
=vldY
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
