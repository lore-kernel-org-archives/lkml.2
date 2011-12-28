Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1L1Kea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 05:34:30 -0500
Received: from 8bytes.org ([88.198.83.132]:39133 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab1L1Ke1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 05:34:27 -0500
Date: Wed, 28 Dec 2011 11:34:24 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU fix for 3.2
Message-ID: <20111228103424.GA2499@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 5f0a6e2d503896062f641639dacfe5055c2f593b:

  Linux 3.2-rc7 (2011-12-23 21:51:06 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git iommu/fixes

KyongHo Cho (1):
      iommu: Initialize domain->handler in iommu_domain_alloc()

 drivers/iommu/iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2fb2963..5b5fa5c 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -90,7 +90,7 @@ struct iommu_domain *iommu_domain_alloc(struct bus_type *=
bus)
 	if (bus =3D=3D NULL || bus->iommu_ops =3D=3D NULL)
 		return NULL;
=20
-	domain =3D kmalloc(sizeof(*domain), GFP_KERNEL);
+	domain =3D kzalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
 		return NULL;

The patch fixes a missing initialization of a newly added member to the
iommu_domain structure (in a way that also works for future members).
The top-commit I am asking to pull on my machine is

	8bd6960c6ae65d7f92bfb708154ee813417d7b26

Please pull.

Thanks,

	Joerg


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO+vCwAAoJECvwRC2XARrjm2gQAKEcIVA9IuQN8uTcIdsH8kys
o2veaNGi5Tm227FvdFgwS3ceBtNVsO219+jbdiszt6mzsNODvvQdwsySvfGeIF69
4/wUyMvc8LDnuvjzTXaGb/euR/fBl/hVKVljGzoucTZYZb3ceDu9Lo3+jcYbRdFF
Mkv5QuFYuVzTpXKN6aSXyQRSHlIlackngO586gXNBSJiGhTyMAZQPhBDq9Am30aL
xJJZn+7qvzGNMqaxcKBz1uunDYbPlQBmPpup/0+TvOjpmKmEMsquqhpSkdiJ+TLJ
pkfIUtX4mA+DS/uq46a0Lg1sRzLkxgrPpKn6vsCzAyKClb1A5mpOevle3n5gGaPh
ce0UQbkEgd9tur2IBAJkBqmL09Zsp1fbEWIdu5Fl2elynI4QAlpvYEfqOLD60o8j
DWQ2Z7MAaj7O+jtitEjhfmPRoLFcNKjRozKhIvROE78vglrQ/nF70RdykVUrCGRv
mBjKP4LmVbGmHC+KdHkLi7CtlGZr6lg8YkfQ2bu9BRuzvHX/K5F4fDFJUo/9oMdt
6I2dY+/TL4Ox8DekZ5eBft2asZgOfTNGQpr9npnZ9Oqk2gkIFxzFoNDDLM94RKXI
rzwB/EO51Gyo08I2Nujij8XTloloXEJ84E/qvldTS0kCrC4Z8YS1IH7ija2IiUjG
Un6R7XSVFK+slA61866V
=cPm+
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
