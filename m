Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2DBOEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:04:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32919 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277Ab2DBOEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:04:14 -0400
Date: Mon, 2 Apr 2012 15:04:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] regulator updates for -rc1
Message-ID: <20120402140410.GA15197@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 4992fa1fd425f1934f503ffa96b68e235b89db9a:

  Merge tag 'topic/twl' into regulator-next (2012-03-19 17:17:32 +0000)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-3.4

for you to fetch changes up to d49fe3c4cd22965de7422dd81d46110fc3d4deef:

  regulator: Remove non-existent parameter from fixed-helper.c kernel doc (2012-03-31 19:41:20 +0100)

----------------------------------------------------------------
regulator: Fixes for -rc1

A bunch of smallish fixes that came up during the merge window as
things got more testing - even more fixes from Axel, a fix for error
handling in more complex systems using -EPROBE_DEFER and a couple of
small fixes for the new dummy regulators.
----------------------------------------------------------------

Axel Lin (13):
      regulator: tps6586x: Fix list minimal voltage setting for LDO0
      regulator: Fix set and get current limit for wm831x_buckv
      regulator: Fix unbalanced lock/unlock in mc13892_regulator_probe error path
      regulator: Fix restoring pmic.dcdcx_hib_mode settings in wm8350_dcdc_set_suspend_enable
      regulator: Do proper shift to set correct bit for DC[2|5]_HIB_MODE setting
      regulator: wm831x-dcdc: Fix the logic to choose best current limit setting
      regulator: wm831x-isink: Fix the logic to choose best current limit setting
      regulator: wm8350: Fix the logic to choose best current limit setting
      regulator: Return microamps in wm8350_isink_get_current
      regulator: Fix setting low power mode for wm831x aldo
      regulator: Only update [LDOx|DCx]_HIB_MODE bits in wm8350_[ldo|dcdc]_set_suspend_disable
      regulator: Fix comments in include/linux/regulator/machine.h
      regulator: Fix setting new voltage in s5m8767_set_voltage

Mark Brown (1):
      regulator: Fix deadlock on removal of regulators with supplies

Russ Dill (1):
      regulator: Remove non-existent parameter from fixed-helper.c kernel doc

Shawn Guo (1):
      regulator: fix sysfs name collision between dummy and fixed dummy regulator

Ying-Chun Liu (PaulLiu) (1):
      regulator: anatop: patching to device-tree property "reg".

 .../bindings/regulator/anatop-regulator.txt        |   29 +++++++++++++++++
 drivers/regulator/anatop-regulator.c               |    5 ++-
 drivers/regulator/core.c                           |    4 +-
 drivers/regulator/fixed-helper.c                   |    3 +-
 drivers/regulator/mc13892-regulator.c              |   10 +++---
 drivers/regulator/s5m8767.c                        |   14 ++++----
 drivers/regulator/tps6586x-regulator.c             |    5 +++
 drivers/regulator/wm831x-dcdc.c                    |    9 +++--
 drivers/regulator/wm831x-isink.c                   |    2 +-
 drivers/regulator/wm831x-ldo.c                     |    7 +---
 drivers/regulator/wm8350-regulator.c               |   34 ++++++++++----------
 include/linux/regulator/machine.h                  |    8 ++---
 12 files changed, 81 insertions(+), 49 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/anatop-regulator.txt

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPebHLAAoJEBus8iNuMP3diVwP/jcxpKWkfDGv7q2ZEc2F5KoJ
TErO1Y+7gBNO4vRQR4f4CDc18l79Laq1U9KrZCSnVzrd6ue7iB6K7PoQLIWF3txd
xZiYZ1ITSq/Ds/m4MZ9wAdI4bOkspy8F9ivask6sSzY1qZBcgaEPzlF+kO7BHGEy
FQ5Uji+bgypHwAXfKt5+Z/fC4N+W3i0OXCR9pFiFSlsrSFMQVh9fnSX5p60zVRY+
au6LnifDwjwBOXwxD6kR/07HFIhfPI2Po37Ry+p97Pb1e1a/SKVYNzf1eWqbo3ie
MzuvMHipDuQWsFx6GGEgJGJcNrKersXBQAg+yWZgPQ6nFbt2IvIojD75+6oZMEfE
yNaf/xujOZDks1gjbRACobZOjDiFoLWXKGmtOvEi1209rs4upgXcvAk8k9rnOVS/
fGrxU65U0YwJ2tFfW3A0p9xrHA9Jnm7DlqXSK9K0EqGD1Y2DQ1RcIodIC3c7yPYJ
UY7ZPvfwLWEEeN05PVfymc1aM+eJGX8FP62wmpYeaqgR02Hgof1ZLq5nXOrc0Zpo
dYiquuvL9ZLbrfxT6e9jzrYWHiJHJuzQ2oE0Tsfm3kpf8C+vD17TKG17p60DdqDD
abUQpCZVe99+WxcNSII8kNt8b8r4CZbsNIVMCQSJBVi9icb1VOhp2sIpoqidE45w
BURTLuN4j+D+fQDeNnFo
=9HnV
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
