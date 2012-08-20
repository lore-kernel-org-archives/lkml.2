Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab2HTKGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 06:06:20 -0400
Received: from 8bytes.org ([85.214.48.195]:55204 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab2HTKGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 06:06:17 -0400
Date: Mon, 20 Aug 2012 12:06:13 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Fixes for v3.6-rc2
Message-ID: <20120820100613.GA2980@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Aug 20 12:06:15 2012
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50320c1722978043564008
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 31fe943599b7e5870edb9decb7fbb9538b218f26:

  iommu/amd: Fix ACS path checking (2012-08-06 18:10:04 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-fixes-v3.6-rc2

for you to fetch changes up to 2bd5ed002c0c493ac328f13a9e2a504261a7d48e:

  iommu/amd: Fix wrong check for ARRAY_SIZE() (2012-08-10 11:34:08 +0200)

----------------------------------------------------------------
IOMMU Fixes for Linux v3.6-rc2

Two fixes are necessary. One patch fixes a boot crash on MacBook Air
with interrupt remapping enabled and the other patch fixes a regression
(which causes a boot crash on AMD IOMMUv2 systems too) in the init code
of the AMD IOMMU driver.

----------------------------------------------------------------
Joerg Roedel (1):
      iommu/amd: Fix wrong check for ARRAY_SIZE()

Seth Forshee (1):
      irq_remap: disable IRQ remapping if any IOAPIC lacks an IOMMU

 drivers/iommu/amd_iommu_init.c      |    2 +-
 drivers/iommu/intel_irq_remapping.c |   18 +++++++++++++-----
 2 files changed, 14 insertions(+), 6 deletions(-)

Please pull.

Regards,

	Joerg


--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQMgwVAAoJECvwRC2XARrjBjAQAIKWbHYEGTuqkd4QvKfZ/Kts
xbyLgvc+P2wtVo4DEKZqz9/CskpO859xdzkY4lbf9NuEAQpggWCZIeVMGHf5Awbc
LRiAStRMe6MvdA0yDx9Kg/DjOni3RlfHPiy/wT+v+BiW5t73J8YKnfACKNhIZ/8w
KmLEqNvsbepqEbNw0FMdUhCb/BwUxHT2k1iP42TkCBbs99Lga/jGP8B5gSwz6TO8
DnZDFsynM/XgpRrEdJE9cFITakNn1+Ykij9Gk0hoSG/IUxNWZvyNcE1K4ZTdtCmb
j09pQJIch3qBdA6R5RsaYQs4Ti/bFhuJD/yz6CyPbQxgMYJ2WXRUWTmSrdDxIuB1
vPENmWP4nR50fO2zUKEIMUqnBP7eQVJLUWBBhJ+o5S6r9xdUMmHa627LLbH2UsUK
Ry1RZjq/ebMXdAd0p/jiqqoBed4gbE/RUos8DC3BX6B1IqF1Mlz++W4pdjhqVxHM
LIIoi7rtgCb3MGb5tBlBbxSLE6i5VeOKu0koZpV9y8aOzL2qyEz4c2V4jZPfbcw9
k5oGapV9j+XnjONSHmzWbNVZx7wJUcr7d0824rC970z9tNwjtKyhcVgLi/3IP0XB
0C/EiuhYNyZdpIKcz7d6eaYImvClCIV58aWsvP9sCaO1Qqtc49SMFGPENRgwqKx5
OtqXPsthJZjehBbxSTRa
=8jKX
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--


