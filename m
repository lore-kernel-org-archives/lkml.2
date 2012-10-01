Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2JAOyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:54:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56043 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2JAOyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:54:32 -0400
Date: Tue, 2 Oct 2012 00:54:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: linux-next: build warning after merge of the tip tree
Message-Id: <20121002005423.7530890bfcfaca06666dfc72@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Oct_2012_00_54_23_+1000_zwowgVAWCZlC=_Mt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Oct_2012_00_54_23_+1000_zwowgVAWCZlC=_Mt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (sparc64 defconfig)
produced this warning:

include/linux/efi.h:503:13: warning: 'efi_enter_virtual_mode' defined but n=
ot used [-Wunused-function]
include/linux/efi.h:504:13: warning: 'efi_late_init' defined but not used [=
-Wunused-function]
include/linux/efi.h:505:13: warning: 'efi_free_boot_services' defined but n=
ot used [-Wunused-function]

Introduced by commit f383a1e37bc3 ("efi: Add a stub for
efi_enter_virtual_mode on non-x86") and following patches.  These
function definitions should be "static inline".
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Oct_2012_00_54_23_+1000_zwowgVAWCZlC=_Mt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQaa6fAAoJEECxmPOUX5FE2AQQAIbCDSl2we04JkCwgZS4p8bg
FvGiGghuk7J/ApxBWUgknkESKRDezJfcyo/hk2bQpm76AN4LMaZYQWi3rTEefr7D
UJX32wKoL5x0/wScWMji1OX6Gg2FjWjN8sL/PE2IPxT0IRg/kPeF38kj/oEBb3uP
6oI8MxzGzvyShpqpI59cjhqBnJVDE6ARfUPvpRsvYbICI02OuU8WQaQKCOZfmqZW
1WZVfnB4LkD8oxa1sI9aAw6ZsyVXi7eBKOHK1Ds9t6EyK/GbP10uT40UlD0n8K6n
fI0Z5L+FfmMVEtUcEt6d/hTA9OSPTY3VG5scJ76SXiwynoNgoChHeuvatiC6UJJv
q8YquFO/8JfD9XR1I4Z3rIbrCez0u5PYUm4y9ktV3HAqC1LCuTWS3ExopiPtJRaV
eZs5tACImLYXmcQuMYd3ZuASKl8/jUH6aA7RPhrinifC2yyxZpY1Dov5xmDuIWX6
h/WIm6u7JXWIijEgDsGcwxMfNF+fZ7e2m4abTWL7YBdLoSA+qUbzoihx9hwFekS/
DtEf2U0blC+xfu3dXt4V13Yck3imRT1r/x8xq8WH3E1eggzPm8lkmhb1LmuYXCiN
KXmtoUV3TyWl5IgiBw+VzNnKIctEVTNzBbD/IE+NzWRKEx9MAF6rwILcBtwmAU3a
v4VBiT6Hy6zEBR3eQfIY
=rAKK
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Oct_2012_00_54_23_+1000_zwowgVAWCZlC=_Mt--
