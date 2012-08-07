Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab2HGOoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 10:44:38 -0400
Received: from 8bytes.org ([85.214.48.195]:51812 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab2HGOoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 10:44:37 -0400
Date: Tue, 7 Aug 2012 16:44:30 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Fixes for v3.6-rc1
Message-ID: <20120807144430.GA8827@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Aug  7 16:44:32 2012
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 502129d020429252265525
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-fixes-v3.6-rc1

for you to fetch changes up to 31fe943599b7e5870edb9decb7fbb9538b218f26:

  iommu/amd: Fix ACS path checking (2012-08-06 18:10:04 +0200)

----------------------------------------------------------------
IOMMU fixes for Linux v3.6-rc1

These patches fix a couple of issues. First of all a few problems with
ACS on x86 introduced in the last merge window, where ACS did not work
on AMD and a NULL pointer dereference when there ran against SR-IOV
devices.
The patches fallen out of coccinelle checks fix a possible invalid
memory reference and a possible memory leak. The other patches mostly
fix build errors and warnings and a wrong return value.

----------------------------------------------------------------
Alex Williamson (2):
      iommu/intel: Fix ACS path checking
      iommu/amd: Fix ACS path checking

Hiroshi Doyu (2):
      iommu/tegra: smmu: Cleanup with lesser nest
      iommu/tegra: smmu: Fix error initial value at domain_init

Joerg Roedel (2):
      iommu: Add missing forward declaration in include file
      iommu/amd: Fix pci_request_acs() call-place

Julia Lawall (2):
      iommu/tegra: remove invalid reference to list iterator variable
      iommu/intel: add missing free_domain_mem

Sachin Kamat (1):
      iommu/exynos: Fix build error

Thierry Reding (1):
      iommu: Include linux/types.h

 drivers/iommu/amd_iommu.c      |   25 ++++++++++++++++++++++---
 drivers/iommu/amd_iommu_init.c |    6 +++---
 drivers/iommu/exynos-iommu.c   |    6 +++---
 drivers/iommu/intel-iommu.c    |   26 +++++++++++++++++++++++---
 drivers/iommu/tegra-smmu.c     |   17 ++++++++++-------
 include/linux/iommu.h          |    2 ++
 6 files changed, 63 insertions(+), 19 deletions(-)

Please pull.

Regards,

	Joerg


--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQISnNAAoJECvwRC2XARrjFBIQAKd47G/0gwXifCR80m58+PFl
KOlcmbJ3gIfSQB3jVghGZeI3kp9KSP24W/r6bXF47J/y63gs5eQqQkGYEFJqtAuZ
cqVVB5vEqgqlbQOyRIWBgNtM32SU8BDQ3oCV9npy7GwH6SzElZk2EG3q/QarNMFt
4iaXegkeeL+knBG+VFYrCvuy+svjxbtZDS1zEGt5eM6yhXufHqoF6BfMPAiZGV1S
1wWOKNAkqKpk1Gh+H7KHt1cKQwa/FwJaO59HVpfEkh1UWuCv9wWK6BiMdLU8nP9m
mGSZG+v1vy+/STHF2Hyn8jD2vPy9Aq6hp7wssZf3KnixCdoi1ZXj5j3oyH047Onw
RmAyCHzGuzg+PNqLdB5IGWBPn6wUhyfVth6bdHYW9N53aL9KuS+Upz0Tu3xcbDOv
kiCl11mTjhdkD3aP7wdfLW5xtnotwzs5nK2m8r34ghQXl6FDk2cfWY3+h3hyHtMq
gcW3en1fJh/meBCBX9iKAwO+7+OuYmca+6TgbzteQBbAZfUwsSEzZJAU5kKBDgd8
Pvv9UFMtVH6GjyGAyzlKqIMWr2zoCvgaE1kpP5pHDsRESPgiIfmz3UhmMqotPXwx
1vSN9DLsaucudXtgqUl0tbFpiFsJRivgwF11TGV+dlM8wmsNzt2M6SiUOOUzCLj+
eSBPfWRLjYi0L6G3RFbt
=6RUq
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--


