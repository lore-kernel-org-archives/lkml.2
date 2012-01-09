Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab2AIRyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:54:41 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:61651 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab2AIRyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:54:40 -0500
Date: Mon, 9 Jan 2012 12:52:48 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: tj@kernel.org
Subject: [GIT PULL] (xen) stable/for-linus-fixes-3.3 for 3.3-rc0 (bug in
 3.3-rc0)
Message-ID: <20120109175248.GA32536@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F0B29DC.0078,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Please git pull the following git branch:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stabl=
e/for-linus-fixes-3.3

which has one compile fix on top of d4bbf7e7759afc172e2bfbc5c416324590049cdd
(which was merged in your 3.3 tree on Friday), the git commit is:
Tejun Heo (1):
  Merge branch 'master' into x86/memblock


One simple mismerge where an extra ')' was left.

 arch/x86/xen/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Konrad Rzeszutek Wilk (1):
      xen/mmu: Fix compile errors introduced by x86/memblock mismerge.

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index f4bf8aa..58a0e46 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1852,7 +1852,7 @@ pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
 	xen_write_cr3(__pa(initial_page_table));
=20
 	memblock_reserve(__pa(xen_start_info->pt_base),
-			 xen_start_info->nr_pt_frames * PAGE_SIZE));
+			 xen_start_info->nr_pt_frames * PAGE_SIZE);
=20
 	return initial_page_table;
 }

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJPCylmAAoJEFjIrFwIi8fJhTgH/jwmKkl6gqigavtqvJiXjvyA
15Ff5DbGgHGmvXu7V46oHW+dcE5Abl1s8HDu2bkJXUfbNfmnNjnA3C2SIQzDoGhN
Q4492wWY9VYHJCNnxmRlX3EvpVFt2WAotpJeGhtKiyAWOVRG+O6g3Cc2wl0S5BRW
2puIQsbqwkG6SjSljmbE92HdV5QxZQKlXF0r/LTE/4FI8Qb2lk0tLeSDolmCub/K
SFyKBHJhsCW8vbivPUakn6ClDHn+fkupKh0Phnyd035XKEmh+6+sX37Mc0q6ANRe
+R4u/kTD2joOUOGgmzjGsOv8j5u2MxTto0p887011IQUfjSEYuO4oxe7ZqX2i+I=
=H5rN
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
