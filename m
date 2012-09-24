Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab2IXJZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:25:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45055 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2IXJZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:25:50 -0400
Date: Mon, 24 Sep 2012 19:25:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Arlott <simon@fire.lp0.eu>, Chris Boot <bootc@bootc.net>,
        Dom Cobley <popcornmix@gmail.com>, Dom Cobley <dc4@broadcom.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm64 tree
Message-Id: <20120924192545.09a1327b66005e0ac967faaf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_19_25_45_+1000_ZyXSPmiD12E2LEaV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_19_25_45_+1000_ZyXSPmiD12E2LEaV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/clocksource/Makefile between commit 985c0679dfa4 ("arm64: Generic
timers support") from the arm64 tree and commit ee4af5696720 ("ARM:
bcm2835: add system timer") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clocksource/Makefile
index 6591990,d496a55..0000000
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@@ -13,4 -13,4 +13,5 @@@ obj-$(CONFIG_DW_APB_TIMER)	+=3D dw_apb_ti
  obj-$(CONFIG_DW_APB_TIMER_OF)	+=3D dw_apb_timer_of.o
  obj-$(CONFIG_CLKSRC_DBX500_PRCMU)	+=3D clksrc-dbx500-prcmu.o
  obj-$(CONFIG_ARMADA_370_XP_TIMER)	+=3D time-armada-370-xp.o
 +obj-$(CONFIG_CLKSRC_ARM_GENERIC)	+=3D arm_generic.o
+ obj-$(CONFIG_ARCH_BCM2835)	+=3D bcm2835_timer.o

--Signature=_Mon__24_Sep_2012_19_25_45_+1000_ZyXSPmiD12E2LEaV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYCcZAAoJEECxmPOUX5FElhsP/28IiJaw+w5eGDCOze2bR/8F
k9CO1tYRXY4ekJZMJykwtmUxWXsFDjDEFt5sJwOIVaI+IsYLowEAqofJYMsFeLdp
HBvOZrvaWcpkIxV0DXMsZwi5eEcPyqFHjTNCsvFX4t4TnegUfpoeVCQFXi9aL7lw
G9A/R+UFqVGGnoryLeWS1G54nNIgrJD03ALZfS+bZRkxj9u6W+UvPGId0ARYeJ/r
e/TLIe+rU0gFwZJdM5vhl6jdBXniNHzMocrfnyDot5SGsgoCcYmoFL5uKhrCi4m5
+WzDo47GfqAeFjJd6ZdeMOJeN4iy9BIOa3Fd8SP1TFYmKVldbbkuLnApSNhrxw7j
PiBbUTzXbt0jUqiuUb7kFWwU1kmpzZ1L/sNsryO0o54jh50RdP20NEu6Sz9xgZ1/
YrOahcJc4tXI13PZRPTxzeGlGj3yP1VpqZ0mqehv88ZQAZ5bRXpOJIbyWv7JD9lN
7xcaocWXfhs1v9V1Mk2vv/fgvdnuHvyGp5II+EG1y42SPm5bjZqO7e1NCvI408us
ge/6YrowqsKb7qFLlzXoTRJZ4C3JX14V6GA/wlAvRTpVYZ2Z8eSvzeZWsHsejhvX
1sLgy5+bktB5uMyL6Boew13BJm7sK/ieXfT7WjzXAjqCbyWUh/Yodi3KGtIcnerk
NDwMcTItAjS52cceu+0V
=vt9R
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_19_25_45_+1000_ZyXSPmiD12E2LEaV--
