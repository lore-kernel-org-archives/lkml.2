Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab2KTEp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:45:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57301 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564Ab2KTEp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:45:56 -0500
Date: Tue, 20 Nov 2012 13:45:47 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 0/5] mfd: arizona: Updates for v3.7
Message-ID: <20121120044544.GF4483@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p8BcnzLwh3ipgLRM"
Content-Disposition: inline
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p8BcnzLwh3ipgLRM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:

  Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/mfd-arizona-3.7

for you to fetch changes up to 82db57511f6fcef74b60f7a48182637133cf2ba2:

  mfd: arizona: Sync regcache after reset (2012-11-20 13:16:10 +0900)

----------------------------------------------------------------
mfd: Bug fixes for arizona for v3.7

These have built up over the release cycle.

----------------------------------------------------------------
Charles Keepax (3):
      mfd: arizona: Use correct array for ARRAY_SIZE in mfd_add_devices call
      mfd: arizona: Correctly report when AIF2/AIF1 is underclocked
      mfd: arizona: Sync regcache after reset

Mark Brown (2):
      mfd: wm5102: Update register patch for latest evaluation
      mfd: wm5110: Disable control interface error report for WM5110 rev B

 drivers/mfd/arizona-core.c  |   14 +-
 drivers/mfd/arizona-irq.c   |    1 +
 drivers/mfd/wm5102-tables.c |  519 +------------------------------------------
 3 files changed, 13 insertions(+), 521 deletions(-)

--p8BcnzLwh3ipgLRM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQqwqsAAoJELSic+t+oim9musP/0eE46Vl+sJUm5vHXbifUBCC
LycDkROxaWePdgG4X50TTifmn+XOraaBS4RdqhmIMe6zt+y+5iv+DI9AjPcu5kkB
FfwsGb6Xl1mTtaGSZUaPnu8RHjNL3I8fotxIrRkdcc2veiLG7DNeI2Q0JWBp6sMR
5/3YYvNtivPnaahL3cqzX5ebnBXT72JYDknJHmWBh7Nf60c4LG3UznHquo/adwQz
Ae1ytbZPGQneE8REuQZTPyR4RntcesZSjz6Nrpr7pGynjP6HtD4l+dH4LiDaH/n8
mvHnPL1GN9p2vxUY23dWKi0PC8JHQckPBfhdqun77uSuzyIfexox4FXmRBc9XIK0
g1XUckEeYLTuI7ONdxrqHKWmxVDsrjg89Y+PBH5QMCBSh6v7S55aQiO4eDYCGVuU
uHGKVZDmM0PKQgUIxb9td0qMYVOqajmefErDzJ6/4nnxUwcUVVMvB2jy2uxnlApM
xPy89ri4OI1yoYSfDhehIU77n9pReFguvY3CB2zM+g+ChV8OLLuFx80Wko1qsqnH
VdpDbetnBdfyHg1psl62WjztRaT8Pw/ABO+9kXyQyLBkYH7IFiphGEb0MIdDC6jz
pqonrgqkZ2VAjkjLTCVfYEMIS4/4hhaf2Ntvkwnnl7QbYaRrMqyeuGZo6tpcSszs
EEMQtfcdehutE1u+5arm
=Zb/j
-----END PGP SIGNATURE-----

--p8BcnzLwh3ipgLRM--
