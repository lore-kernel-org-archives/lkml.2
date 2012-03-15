Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab2COCYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 22:24:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33893 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab2COCYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 22:24:04 -0400
Date: Thu, 15 Mar 2012 13:23:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kevin Hilman <khilman@ti.com>, Jaecheol Lee <jc.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the cpufreq tree with the
 cpufreq-current tree
Message-Id: <20120315132352.b8c8bbf0242c1f3b31333675@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_13_23_52_+1100_9s.b80lUciam_sVZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_13_23_52_+1100_9s.b80lUciam_sVZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the cpufreq tree got a conflict in
drivers/cpufreq/Makefile between commit b09db45c56c2 ("cpufreq: OMAP
driver depends CPUfreq tables") from the cpufreq-current tree and commit
a35c50510dd4 ("EXYNOS4X12: Add support cpufreq for EXYNOS4X12") from the
cpufreq tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/cpufreq/Makefile
index fda94c7,3cbbcd0..0000000
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@@ -44,7 -45,9 +45,9 @@@ obj-$(CONFIG_ARM_S3C64XX_CPUFREQ)	+=3D s3
  obj-$(CONFIG_ARM_S5PV210_CPUFREQ)	+=3D s5pv210-cpufreq.o
  obj-$(CONFIG_ARM_EXYNOS_CPUFREQ)	+=3D exynos-cpufreq.o
  obj-$(CONFIG_ARM_EXYNOS4210_CPUFREQ)	+=3D exynos4210-cpufreq.o
+ obj-$(CONFIG_ARM_EXYNOS4X12_CPUFREQ)	+=3D exynos4x12-cpufreq.o
+ obj-$(CONFIG_ARM_EXYNOS5250_CPUFREQ)	+=3D exynos5250-cpufreq.o
 -obj-$(CONFIG_ARCH_OMAP2PLUS)            +=3D omap-cpufreq.o
 +obj-$(CONFIG_ARM_OMAP2PLUS_CPUFREQ)     +=3D omap-cpufreq.o
 =20
  #########################################################################=
#########
  # PowerPC platform drivers

--Signature=_Thu__15_Mar_2012_13_23_52_+1100_9s.b80lUciam_sVZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYVK4AAoJEECxmPOUX5FEGTAP/2+ZYK0MEdgV0b4YjkqF9MVL
jgneot+kg/9dDE2nJzu2M5tqG6vZrR5+bmT09g8Z9/+9gCV6ZaClaRmqefbZ5/vC
9fDKbRRBOLHKfdlrYf0qsXRQLrI5qvUeEL31oCTXISNTpUGTfLMub753+RX/d7Rb
G24frYnQZ6hmQdM5ogBg03Th5qTsGEJ7+OgjyMU4YFPBfAXRJZUl1NjO+qpsRTWF
3teP+SDPrqIsC0Xo4kVCCa0MRxd76V8Pesd0xHbtDgdZBU/1lvr6bC6Rvmn/a3w0
anwXUPjxDv4VrqGPJPRbSke35DA3bbLrp5i0uBqCmngsDPjEINOefo1REPG+qpbz
36VG7jR1+85cj8P63+lIQvRgFvompZu4pyUrgtvzMcVq3JOUZqT4+j59sNujWdCl
1pG1FgxL1GQ2gl5rMnIozMWYGtXnFIHXaIYXfoT4Olov6S7iGPj1qDDC4YJMVyyv
0jxxDmyA26i6ghmH727+dkTofXjIoMwyhYOUuynJYD8ixqtQ8MI6zjbCeSPZp7dx
GfUPzPQQ962U7pPJ+L53OzbFqqvek2r+xfs8JfzQYRKFMUYN9Cbby8+YWp4nHaLo
MQYuEvYt044yoEOnq7npd8CQdl86vfFayvTeWw/tbWhojSf0psQ0AqIWAVQOQV/f
H1HicqZBwY/DSkyn2f1K
=qLer
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_13_23_52_+1100_9s.b80lUciam_sVZ--
