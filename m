Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab1KOQDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 11:03:32 -0500
Received: from 8bytes.org ([88.198.83.132]:47860 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756546Ab1KOQDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 11:03:31 -0500
Date: Tue, 15 Nov 2011 17:03:27 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU fix for 3.2
Message-ID: <20111115160326.GA2975@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git iommu/fixes

Ming Lei (1):
      iommu: omap: Fix compile failure

 drivers/iommu/omap-iommu-debug.c |    1 +
 drivers/iommu/omap-iovmm.c       |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

This patch fixes a compile failure on ARM-OMAP when some parts of the
IOMMU driver are configured as a module. Please pull.

The commit-id I ask you to pull is

	08f2e6312c67fed80df9342e06ad36daf11eb80b

on my development machine.

Thanks,

	Joerg


--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOwo1OAAoJECvwRC2XARrjFSMP/RXAqnzohFtHcqP8O5L95FXa
l7mdAa6kFwqeV9sb5fN0dwTOnILyhRXRrYRlfjYxaWcDevabk9Z2Wb17VPQZCuAP
OnjYSXSdNUalGIOxaxloK8vXuNWiAboFGjhPPTmJiKveSH9oWsmHAeX6QgEp2z+R
NvI4Ux4qB2kimnPkhaJTrvavQdolIiSavZbRKrGeLPumLVUpQRfegrIbUS6nWDsu
a9sWqwnBebyl5MShhoCKYmluRr2b7QeED6NHs4rT4AqJ9jQ2trT5Nev04w3uzW+g
SlV6AAtxkDPCBrAHMBo0E1M3K/nCXjBG/wllEkCzT148CMrIVtavQbl7dDepelVh
vO3GR0Z/e1SvLLrWgG/QX9DhY41afaGcuUBiIxvVLS0r0tZxzzJ27/NR3Tnf/qfc
aJoHHbhOdNbqdx67zSLcReFVW6d9T4Rua8VDkOtn2eBO1aw6If1x+r1BVqKOtfZP
pZgraALqAcDmZCPhajWDy/F8FzfxBcJABG8CD6QC8jOb/eTeSGSri5AXI9DsGfSh
qlRNOXuX0iw9rEchuMGdv2CwrtAScPzvGtmBIGw1i2JZ6V7MXrRjGp4YiR7JivrS
7r5zL6iK/pG3ZxhWHJrJZal6Uu5QiIIwXvbCvWihxkbeSfzFMJBi2hkvFOVm/hQn
44dP1f+aPLOtZPcL8Wof
=mFJ7
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
