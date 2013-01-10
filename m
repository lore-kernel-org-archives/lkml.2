Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab3AJMCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:02:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49956 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753786Ab3AJMCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:02:33 -0500
Date: Thu, 10 Jan 2013 12:02:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/11] extcon-arizona updates
Message-ID: <20130110120231.GL20956@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xjamM5M9kpPM/bcu"
Content-Disposition: inline
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xjamM5M9kpPM/bcu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/extcon-arizona-3.8rc3

for you to fetch changes up to 708f5b582ea16b60701e275fe5233ec4c57859cd:

  mfd: wm5102: Add microphone clamp control registers (2013-01-10 11:35:42 +0000)

----------------------------------------------------------------
extcon: arizona: Updates to arizona extcon driver

This patch series adds a number of new features to the arizona driver:

 - Headphone measurements.
 - Alternative detection mechanism for non-default system designs.
 - Microphone clamp integration.
 - Support for additional detection pin.
 - MICBIAS rise time configuration.

There's one trivial MFD patch which is here because it depends on
register definitions from the new features.

----------------------------------------------------------------
Mark Brown (11):
      extcon: arizona: Convert to devm_input_allocate_device()
      extcon: arizona: Remove duplicate mic ramp configuration
      extcon: arizona: Only set GPIO if it has been requested
      extcon: arizona: Allow configuration of MICBIAS rise time
      extcon: arizona: Use microphone clamp function if available
      extcon: arizona: Support use of GPIO5 as an input to jack detection
      extcon: arizona: Enable basic headphone identification
      extcon: arizona: Move start and stop mic functions earlier
      extcon: arizona: Support HPDET based accessory identification
      extcon: arizona: Support direct microphone measurement via HPDET
      mfd: wm5102: Add microphone clamp control registers

 drivers/extcon/extcon-arizona.c       |  634 ++++++++++++++++++++++++++++++---
 drivers/mfd/wm5102-tables.c           |   10 +
 include/linux/mfd/arizona/core.h      |    4 +-
 include/linux/mfd/arizona/pdata.h     |   12 +
 include/linux/mfd/arizona/registers.h |   48 +++
 5 files changed, 658 insertions(+), 50 deletions(-)

--xjamM5M9kpPM/bcu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7q3MAAoJELSic+t+oim9iBEP/AneP5KH2ukrLe03YQCltuBY
ENRFAquAWjZfRCx8MdntD8p19KmzHAYkrqDp1iPSrMsFnV2XkAoYRXWtt+r4PHla
cqHMVft/PwUn0Ci+TY1UhxQSfWl0qUDhJmw4WsqjOqKydrVui1+7QwdRJT8Rb5xw
wvvdhXbFV0O9DgTyZAe1TTEP4TZORH9vh5604gwFQsXuD1V7U9QGCM4wDdwb9hvk
YDP7NuMGmqewaKvh/9c+nbct46GnLOPqw/ZJHKY6s+A4osnCo2VFoXH2BrTLQ1CJ
ac8TC0LS9acY/JBjPuZMTlbT50zm04Iizx7gfZwKDHhLJXxASR9HdSvU0ufX9Z8B
KEkxMM8mG3dP6ioNJvlwHMmPfxclTQGq0d/GPv9SqtOPTw9owzQJY9JANHUyVJAd
IwwLb9am8QkjnlzexPhAqGQh1mfBH0Gp/crb4NvjzqZ2YH4eOiMTqhGJ5VKdneWu
XjtI/3vwiO0Yox58e6QKBrGwcw9VWFCf5Rwcm36mWqUiqIOzTC9X0xROHu5FuHvt
NvKc98QHjmVpUX8xzvahBE7dWD1yfpgOIKWxQVD3a0wOUk/W0kBe4bHfyHzssdeH
Q3v68ocVw1CViOkrahSxIh5912pOqeVzMMPKh26GOtJSfjJ59L41mXBBfDTyU1wZ
XAQ29NNrE4kHVBr9iiEK
=lR01
-----END PGP SIGNATURE-----

--xjamM5M9kpPM/bcu--
