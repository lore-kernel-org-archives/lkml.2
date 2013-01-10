Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3AJMSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:18:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41509 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002Ab3AJMSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:18:31 -0500
Date: Thu, 10 Jan 2013 12:18:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 0/9] mfd: arizona updates for v3.9
Message-ID: <20130110121828.GN20956@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YuJye9aIuN0w6xGV"
Content-Disposition: inline
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YuJye9aIuN0w6xGV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/mfd-arizona-3.8-rc3

for you to fetch changes up to 98b9f5c07baa1a30e5548ad1686bcbec569c9c55:

  mfd: wm5102: Update rev B patch for latest evaluation (2013-01-10 12:08:11 +0000)

----------------------------------------------------------------
mfd: arizona: Updates for v3.9

A bunch of minor cleanups, nothing too exciting here:

 - Updates to tunings from evaluation.
 - DSP memory access information for WM5102.
 - Support for customisation of microphone detection levels.

----------------------------------------------------------------
Mark Brown (9):
      mfd: wm5102: Mark DSP memory regions as volatile and readable
      mfd: wm5102: Mark only extant DSP registers volatile
      mfd: arizona: Register MICVDD supply first to ensure no retries
      mfd: arizona: Disable control interface reporting for WM5102 and WM5110
      mfd: arizona: Check errors from regcache_sync()
      mfd: arizona: Allow customisation of microphone detection levels
      mfd: wm5102: Add registers for microphone detection level configuration
      mfd: wm5102: Refresh register defaults
      mfd: wm5102: Update rev B patch for latest evaluation

 drivers/mfd/arizona-core.c            |   19 ++++-
 drivers/mfd/arizona-irq.c             |   18 +----
 drivers/mfd/wm5102-tables.c           |  132 +++++++++++++++------------------
 include/linux/mfd/arizona/pdata.h     |    5 ++
 include/linux/mfd/arizona/registers.h |    4 +
 5 files changed, 88 insertions(+), 90 deletions(-)

--YuJye9aIuN0w6xGV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7rGNAAoJELSic+t+oim9cXMP/RWglTuXWOwpnsvmt2HwzgRM
GwlsPjuQfoPz06eG75/ecQpncWOyjDeyEnR9ZVB61VkbZmNFR3BOnrH3CB6ngTLL
qZpXCbbedmRVTWAZBgsRYSFTwq1QcS+Onb8r/UEfNiCB6FKcCoyP3hV4CxxGIUDL
6GNMYq8W7SL6k2B+/dRtp8qhZB8zfVW2w0y7bqiaPxSbHJXOvpCZ8vMrx4FYYin7
yRZbMYVL7yiMvdMrRgm2SS0lEB5UGu97SrmREtb69lZeAYZcLVJUVWdw3AGn9K1q
bkm9SPj2dfxNO1Z+Uhw2Ab7jl1UI/CtxcgwW3XbABZfdWTTgL4XG7wO0ep2wWsDA
KwFAAYmlnFZAUyPyYMCBhHWuw7o8sBKqpGZ5BjTHWQxxDq9UYuj1qcgB8JcvDNMN
ZgrUOK1KGOMP8SSl5GafOSUAS2A524l1cnA3sS72vcJ+Uqsbie5Gdy3ljXE1n/Mo
cZVRgPdBr5pu2F1XAFdSStYYgOnpbwVOX7g5uvDk5DCIBtPow4Y/QlP4jx3xxkQ3
/AXeGYk68ucjGNi6F4YpqwfO0OPo4n+8HHB83shXpkLw6zXQFZYzI1UVggx2t8wq
kg4rJD1mwRWEZ4E+MK7gEdInH/eoG+rOvbRnOIxXP3Gxl9ZGIVxgT+q39nIwXJp0
5U7S7YPkOGxt6cyLOIU4
=54Iq
-----END PGP SIGNATURE-----

--YuJye9aIuN0w6xGV--
