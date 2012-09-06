Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab2IFX25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 19:28:57 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:41270 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2IFX2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 19:28:55 -0400
Date: Thu, 6 Sep 2012 19:28:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/for-linus-3.6-rc4-tag
Message-ID: <20120906232708.GA16704@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MZf7D3rAEoQgPanC"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MZf7D3rAEoQgPanC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Please git pull the following tag:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.6-rc4-tag

Nothing controversial. Fix for the newer tlb flushing code;
an old fix for Xen-SWIOTLB that had been bouncing around until
we narrowed why it fixed it; and a simple one-off check bug-fix
in the P2M re-use code; lastly changing the order of operations
for pciback when doing Function Level Reset.

Please pull!
Alex Shi (1):
      xen: fix logical error in tlb flushing

Konrad Rzeszutek Wilk (2):
      xen/p2m: Fix one-off error in checking the P2M tree directory.
      xen/pciback: Fix proper FLR steps.

Ronny Hegewald (1):
      xen: Use correct masking in xen_swiotlb_alloc_coherent.

 arch/x86/xen/mmu.c                 |    2 +-
 arch/x86/xen/p2m.c                 |    2 +-
 drivers/xen/swiotlb-xen.c          |    2 +-
 drivers/xen/xen-pciback/pci_stub.c |    8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

--MZf7D3rAEoQgPanC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQSTGuAAoJEFjIrFwIi8fJAA0IAM7XVEb13guz7RMceY+ee68I
rS4lIh/kvZc0Ds1SMsAiBgtbqdBfiMnVON9C0cSKzIwfEJurtGnXfUlZcLuN8Jsr
AC8edoNfnWr0K4hHthNOPZVms7ztLUjVqawpIdlEO8tnv2c3NawnC9jzX7qZ8pOW
BHFXksRDMbzSbn603WkthaxIBYV4whzlyINWCZSPRHcTrwUUE3eq8w2pkY1cv7Bg
L6fEuvrDdE2Nojrd1oXn6+nloEMATNUg+CPQ+ZxJ9Gu9iaaGblaoX0uXLmpHpWC6
cL0oB1Ty6anOosFiyvBkZFz+4YK/96bJtWwWMAis4BzrxyZuq7f+9tdyZCnz9WM=
=37sc
-----END PGP SIGNATURE-----

--MZf7D3rAEoQgPanC--
