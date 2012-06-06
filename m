Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2FFN4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:56:37 -0400
Received: from 8bytes.org ([85.214.48.195]:54196 "EHLO
	h2027444.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab2FFN4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:56:36 -0400
Date: Wed, 6 Jun 2012 15:56:32 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU fixes for Linux 3.5-rc1
Message-ID: <20120606135632.GA4196@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jun  6 15:56:34 2012
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4fcf619228382056420405
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-fixes-3.5-rc1

for you to fetch changes up to eee53537c476c947bf7faa1c916d2f5a0ae8ec93:

  iommu/amd: Fix deadlock in ppr-handling error path (2012-06-04 12:47:44 +0200)

----------------------------------------------------------------
IOMMU fixes for v3.5-rc1

Two patches are in here which fix AMD IOMMU specific issues. One patch
fixes a long-standing warning on resume because the amd_iommu_resume
function enabled interrupts. The other patch fixes a deadlock in an
error-path of the page-fault request handling code of the IOMMU driver.

----------------------------------------------------------------
Joerg Roedel (2):
      iommu/amd: Cache pdev pointer to root-bridge
      iommu/amd: Fix deadlock in ppr-handling error path

 drivers/iommu/amd_iommu.c       |   71 ++++++++++++++++++++++++---------------
 drivers/iommu/amd_iommu_init.c  |   13 +++----
 drivers/iommu/amd_iommu_types.h |    3 ++
 3 files changed, 52 insertions(+), 35 deletions(-)

Please pull.

Regards,

	Joerg


--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIbBAEBAgAGBQJPz2GQAAoJECvwRC2XARrjQm4P+K/JukEgCkjwgSzelTOjOOZa
WH4tLMEYYFHRLU17wC5X/e4mXr8WmmvBenU7hLPeMXoWUe1DQkPyz6L3Cx7DAcWB
B81A0N0QhWu3tqSKhp0K+RrC39F2o+p2cpwnv12lSqA/BfhSd2feDQ/7GTjw2t55
5X7vn5ilnk8AwyXVjqdTfTw0uyDyHOhYta4iRIcVYy8KByv0YBQbvwWkbXQ8iPGw
AnFicllEIS1F4cjkU3Q0ROLoaN5mgmWvuNkipfELkeiKuoXfbEh5YpHrvIIgaBv/
FlHAvarn8eQwYtRWfBSq9FOzmV9R4IShV9SEjVjAk5NCw5I48M2aXoHDtc5ckpnf
/e1IvOjibt0uHv4yRokw/gHKLJFnh20LulVFwE/EYykLF3XopJFXaLir2IVDYT2/
m9S7f5va9vU+vggg6mNsMm9tNPeZyaizYY4UnSADLkYWi7gmYETvhsDuPBOQqVSS
pjRRIV+rj4vZw4VGJ1nCOd2Ddz13YDkg+rXhiWHC7BxC1a2tNCbg93HLBVFruIjv
mknyRZUFzymYUrxMB8NY0tG/WJjAAb5TXPacxSjG2XZx71kn29M9VK8+yxZe8/V7
Ogo1f1rb5St/3WXHDqkbAKvNLpeiez9jYC7jWmQQV+J/PyaQ3cZbe17YUhIfSn1e
7sDuO7B6nhYsYGnSkqU=
=sQYu
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--


