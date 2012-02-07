Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab2BGSZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:25:20 -0500
Received: from 8bytes.org ([88.198.83.132]:48337 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157Ab2BGSZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:25:19 -0500
Date: Tue, 7 Feb 2012 19:25:15 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU fixes for v3.3-rc2
Message-ID: <20120207182514.GA2866@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:

  Linux 3.3-rc2 (2012-01-31 13:31:54 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git iommu/fixes

Joerg Roedel (2):
      iommu/amd: Work around broken IVRS tables
      iommu/msm: Fix error handling in msm_iommu_unmap()

 drivers/iommu/amd_iommu.c |    3 +++
 drivers/iommu/msm_iommu.c |    7 +------
 2 files changed, 4 insertions(+), 6 deletions(-)

One patch fixes an bug in the ARM/MSM IOMMU code which returned sucess
in the unmap function even when an error occured and the other patch
adds a workaround into the AMD IOMMU driver to better handle broken IVRS
ACPI tables (this patch fixes the case when a device is not listed in
the table but actually translated by the iommu).
The commit-id to pull on my local machine is:

	05df1f3c2afaef5672627f2b7095f0d4c4dbc3a0

Please pull.

Thanks,

	Joerg


--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMWyKAAoJECvwRC2XARrj5AMQANZMEwUBU7+fL1sNL0U51WFf
u/doJqfXlsV1okXAOqOqF+LNycsfwjoyZL0MMqmRXkc8hxRfLrKUSQd8GuzSbLqH
yTldHxrwTeegrkqakUNj0OMoDjn2SItdDrwDdgk7QMDGfrNXHY3NnQ55i0feENiZ
XFLoBekcbfuAKEFn7BjPUYc/ZKxqQEGB6/580s5QtJhzFHUG89HK5hQHQngPZOlp
2u5UjgddOnLj+CKNlIfxv+3Mfbn/hJJWZEt0sfsm4NWjOBwYxEeYxQozw5XUGlZX
Fx1AB9dNM51omHk15zTG5xyOZC9PXRD21Q53smEEZkMAxFp935IbLZFM89ncgrzM
wjdDXN9r9FnhVVf0ywHMSx85Z50UR/vLLaLTYXjuKbQkGPMQOEhgu5eAr6rMVMb1
oiuW7X6W9fHRNv5l+oPU8pY/7RwBj+7h4gin2RdxVaTJoW4pGmLsdMxV9Wv6sbJo
Ir4egkRflTV/gzsglVKdd7sd2db6BBwK9ipEgkvzfxsR036FCTlQ8eyMWKQ8VrrX
QgCiOjzGOWHJVhsAWcrVag3nrDkorQCvg8BPcvy8bNZhU4Il3MAOliYk1Z0cNCW8
6mvQBD6CuMz7BNd6tVnMIuztQ9dJPLD7kxok4xqA8a9JdKi/NXA3MOxX+OOUQXEb
4erP/s/OnwT4RU6/o6HL
=NYj8
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
