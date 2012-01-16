Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2APLLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 06:11:19 -0500
Received: from 8bytes.org ([88.198.83.132]:42045 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab2APLLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 06:11:18 -0500
Date: Mon, 16 Jan 2012 12:11:16 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [git pull] IOMMU fix for 3.3-rc1
Message-ID: <20120116111116.GA2666@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 53999bf34d55981328f8ba9def558d3e104d6e36:

  error: implicit declaration of function 'module_flags_taint' (2012-01-15 16:21:07 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git next

Ohad Ben-Cohen (1):
      ARM: OMAP3: fix build on !CONFIG_IOMMU_API

 arch/arm/mach-omap2/devices.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

The patch fixes an IOMMU-API related build problem on the ARM/OMAP
platform. The commit-id to pull on my local machine is

	1a51a0ce174ddc0b0c11b6a0dbd179d95020e80b

Please pull.

Thanks,

	Joerg


--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPFAXTAAoJECvwRC2XARrjrU8P/1sIoZaeSrfuEZMlAfK1MwzW
T1CGtkd4XBjoNqTr4dHO3yLDe0kD37EJVX6kXjyhGwRXKvmntLDR+gM+0HbCnmbv
uuilKIGvE5r+iZtOvrENJINr7Ta7XGsmk5ASPrH6KB+9Y07jP3Wno8TZxxh6Nc8b
FM+I2FKPFTu4DJYzH7R9D/X9ZtMm59YkPpkGIgWBAM7Ivtvf7XzRGoH7V3VnarEB
RpsBv817Huhe5YJSEmM4GOta449opCLY9GF7IVnw6ZF+voU3YqVun8ZT+mTRPcAL
Z4uoH2uhh4IIY4a0y6EsycF+/+wqSOy9oLNvy6aLtB5iJx5tV4Fpro+Q3ughaSCM
S+zHpzsA2Mpe9ZaO8WL4KZFZdj95OvZty9kA8KLq1aoxciYXhTVMLj9eXDZXhwZT
oHMV582wC+25qjFLga8FpNsptGxDE1wrAHwA5vo8RPD1Rtmmcf2QP1cR20nInDMK
+wvQd8Zqdt1B92m5Mk/ovrlnxXosC8YidOWo31bfZQSkChGd2L4Vi8HFpnsWy0QN
hzAabeOpg9zJgLtZ63/ISOqrET7AVXDabPZlZdCLgZaa02N3o4HQHTfAM/3cvuvF
uDfB/RE+ZS8e6fezRzAp9WHiRXUWzfYGQ835/BEOfs6zwpU26Bc2AoWYtoGpb5G5
DtgfZD2sbSjnuq2Rcm2t
=4Uuj
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
