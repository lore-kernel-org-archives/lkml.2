Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab2CINcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:32:10 -0500
Received: from 8bytes.org ([88.198.83.132]:49394 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368Ab2CINcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:32:08 -0500
Date: Fri, 9 Mar 2012 14:32:04 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU fixes for v3.3-rc6
Message-ID: <20120309133204.GA10481@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 192cfd58774b4d17b2fe8bdc77d89c2ef4e0591d:

  Linux 3.3-rc6 (2012-03-03 17:08:09 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git iommu/fixes

or as a signed tag at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git iommu-fixes-v3.3-rc6

Jan Beulich (1):
      x86/amd: iommu_set_device_table() must not be __init

Ohad Ben-Cohen (1):
      ARM: OMAP: fix iommu, not mailbox

 arch/arm/mach-omap2/mailbox.c    |    3 +--
 arch/arm/mach-omap2/omap-iommu.c |    3 ++-
 drivers/iommu/amd_iommu_init.c   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

Two fixes are queued up. The first is an additional fix for the OMAP
initialization order issue and the second patch fixes a possible section
mismatch which can lead to a kernel crash in the AMD IOMMU driver when
suspend/resume is used and the compiler has not inlined the
iommu_set_device_table function.

The top-commit id on my local machine is

	6b7f000eb6a0b81d7a809833edb7a457eedf8512

Please pull.

Thanks,

	Joerg


--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWgZUAAoJECvwRC2XARrjanIP/3LDrB55SxHDduJpxyFeMqzK
bifXzJdeLgPtBM6hzkgAplru+WsfjUjvn7L0G+TEnbV1a6/cr4K+L0GMIWOmUlTD
wf7VgR0x/6aJ56pHtxsoUXK71VIWBGPFPp3hZEXLasD5OIZDWYHe9BwKWhMrpttT
7ampKNIlGNAE0dEbvSaJPgmD5EswrJjunUhbDQezJN6ozqOBXPYafVrnFUo3glPG
xUQCQw7Ts6HiWGhO4FPhAAhy/DLKG9RJGRE5ne8qOC+94EEyWTvBDrUUyXl9xCB0
Aj7vyYjZ1q8SXX2ae9SUMj4afE4OxZ8UGgFVlbC4abkxTHPdMLyuoz7vq83UhlIj
aip3lr7dndy/DzjV696luo3jIhoAYIznxZW7PbZfo7/KZ1TKDyQrI6Hpj/l/6Lhd
DONgk2Ztwl7o89ZcFQzEUl/9zY6h3YSdvsyyrTHIapyPJ+yJdDTcrxMBXk16YPsG
Tn+Vu0JwTStf+emTucJZhhGXpJauwBrKHJch8maHvrbc+xyz3+tnHfhxFm/b42lr
j6qq4AKXBaeuwS/9n7063Ko2ewyVj5IYacqVq0rAtC4Jcm8nbkuDQwEQ0MbH9t0k
tMvcH4C5X2LPJAxwyeFjECG9gl9X5wFL2BOXHVTvgZXD9dtqaiS2HE25pI/yH2n7
BUsy5jl69w3oDpFeQ/OR
=H0lM
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
