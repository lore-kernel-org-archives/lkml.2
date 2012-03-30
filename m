Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020Ab2C3ArE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 20:47:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41151 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2C3Aq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 20:46:57 -0400
Date: Fri, 30 Mar 2012 11:46:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Linus <torvalds@linux-foundation.org>, Robert Lee <rob.lee@linaro.org>
Subject: linux-next: manual merge of the acpi tree with Linus' tree
Message-Id: <20120330114646.36f43b519577e22227039987@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Mar_2012_11_46_46_+1100_aSZN0TA86Zj0Y8Fq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Mar_2012_11_46_46_+1100_aSZN0TA86Zj0Y8Fq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next merge of the acpi tree got a conflict in
arch/arm/mach-shmobile/cpuidle.c between commit 9f97da78bf01
("Disintegrate asm/system.h for ARM") from Linus' tree and commit
ee807dd89c00 ("ARM: shmobile: Consolidate time keeping and irq enable")
from the acpi tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/cpuidle.c
index 21b09b6,ca23b20..0000000
--- a/arch/arm/mach-shmobile/cpuidle.c
+++ b/arch/arm/mach-shmobile/cpuidle.c
@@@ -13,6 -13,8 +13,7 @@@
  #include <linux/suspend.h>
  #include <linux/module.h>
  #include <linux/err.h>
 -#include <asm/system.h>
+ #include <asm/cpuidle.h>
  #include <asm/io.h>
 =20
  static void shmobile_enter_wfi(void)

--Signature=_Fri__30_Mar_2012_11_46_46_+1100_aSZN0TA86Zj0Y8Fq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPdQJ2AAoJEECxmPOUX5FEx3cQAJtaOp2M44N0S6PBV4BkU8lL
s6urTkkGqbdeuHUqiiRAr11gL81tRHYBdSzMbJJiJ6CKVDntU2budYcV/JAynNG2
8987uB81d9IgfamCAyvy3YymZIt3xIs88/tz2rz9pG4oI9E7d2A8KDYoZLCMV6U0
3LI/Hk/irUOecIOgU/1RxKIKUqRdZbetEKA04AJ+0zBgOBM/uvW9Ntou5MqlRdw/
xAlPVO0gTnJIIxEki+tvyHxAIfN15j7bSQqK1yViEvMgDhsR8Jjad+j/6lttCHSy
xhf0fQUXrmglhcuM1Bjgw2AQMQnbwpWRT05P0p24jmbYHXS9+R0nCfDcZwo4xw+X
owUp56XZSIX//6IanzqFJFA5I67p604mhP14nwgJNoLYawL+o/jO5M57i96UVvUh
PIxrgQyn0n877nLq0t/X6W+KHQ0Icm0g/39orLCzeLb0qTPUyEX8+zkUIe6cENF1
wcMFoG4PEoVvhM3nTtv94SVWTHiXj6hYNs2yDcqeFcDu4gxRVlPRYVtyzozNMqZa
CfRCFZ5uF71ZzmdLyTZZ4PK7gIAsxp5eATCCq+EC4bI8VMhgtPDL8aZ50S41Nu6F
/8DnD3SGL/fXV/j5co3B204T5Je8DpgrNXRDJCRU7Ez8SlnGLzCBNi+5kiWDhFii
kikHDcrsIGtSIXyhXQ3o
=FVEp
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Mar_2012_11_46_46_+1100_aSZN0TA86Zj0Y8Fq--
