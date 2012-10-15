Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab2JOCHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 22:07:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49786 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab2JOCHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 22:07:37 -0400
Date: Mon, 15 Oct 2012 13:07:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20121015130728.06a0da8ae06c362aed2871fa@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__15_Oct_2012_13_07_28_+1100__bkrKz=T4y+7364H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Oct_2012_13_07_28_+1100__bkrKz=T4y+7364H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/arm64/include/asm/unistd32.h between commit f3d447a97f24 ("arm64: Do
not include asm/unistd32.h in asm/unistd.h") from Linus' tree and commit
"compat: generic compat_sys_sched_rr_get_interval implementation" from
the akpm tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unist=
d.h
index 63f853f..0f13ca8 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -25,5 +25,6 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
+#define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
 #endif
 #include <uapi/asm/unistd.h>

--Signature=_Mon__15_Oct_2012_13_07_28_+1100__bkrKz=T4y+7364H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQe2/gAAoJEECxmPOUX5FE19gP/j6pMH2jP09PmvJxJnqrw0VT
mozvusIzOCN2mhAwLX2yhg9/lQUK9KzY0CMcunyBMTRJvy0aGAr8PJda1RqdhkNk
lmo/HCFGrFY/DdE/yZ6blMKnY1h+XzCfe6QUpmtTvJCYDKo1/gAVSDkjbha47sGH
6/Gpnpgckn3ZzR1y0EHhlMm5VKHa5drsgEWKVN9Nu58X3k1Gx7bMZBNg9dEK9HXS
sudJ7S2qhRhHdSYcEzVWUtxoTLxqPHnA5YucjwMpTiam1KIQvdhj5jKzcrqJH2eF
+1WNI/S0vEJNOmckK7X8Jvrhp6BcKfN8Cf+ZvLxOO52ZoGn5tpW2mqqmafsJ5ToF
MdYwElXOOq/VcJAMXXWDOyvhP848Op+W1sp6OfmNm1yFuK7C639BuhuvTiP31tnY
YJsxBlirA64Bv6g+hVJyUeSYQDumX/Mzo3H6ot3GxKME2hBW/u9UijOq1Oo/Ffwr
acgGpd8GFOE9D6XrRt3ZmVTCEeCZGcPRvLLbT/gxZswKWrLEaLMPI+T6D0ynbn/b
8mB3a1Lxwqy808PnX7zm2Sxx0R0nTmn8PwZhbht2lY25+Zi4zl5SHsHumUsO/WjH
GPQ7+2SOeEDOZyatLmSV688cGcjpbPTLrddGKGtoYia9jOuqfcaeIDIqMIbjSgmR
JDx930cguyiWxUeUiWFM
=xD0Y
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Oct_2012_13_07_28_+1100__bkrKz=T4y+7364H--
