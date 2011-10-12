Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1JLGaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 02:30:05 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:57271 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1JLGaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 02:30:04 -0400
Date: Wed, 12 Oct 2011 17:29:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20111012172954.4d5a638ef2a399b72bce5bf1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Oct_2011_17_29_54_+1100_D6Nf1oi5SKBCq3tH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Oct_2011_17_29_54_+1100_D6Nf1oi5SKBCq3tH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/wireless/brcm80211/brcmutil/utils.c:20:15: error: expected decl=
aration specifiers or '...' before string constant
drivers/net/wireless/brcm80211/brcmutil/utils.c:21:20: error: expected decl=
aration specifiers or '...' before string constant
drivers/net/wireless/brcm80211/brcmutil/utils.c:22:25: error: expected decl=
aration specifiers or '...' before string constant
drivers/net/wireless/brcm80211/brcmutil/utils.c:23:16: error: expected decl=
aration specifiers or '...' before string constant
drivers/net/wireless/brcm80211/brcmutil/utils.c:37:1: warning: data definit=
ion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:37:1: warning: type default=
s to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:37:1: warning: parameter na=
mes (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:65:1: warning: data definit=
ion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:65:1: warning: type default=
s to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:65:1: warning: parameter na=
mes (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:96:1: warning: data definit=
ion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:96:1: warning: type default=
s to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:96:1: warning: parameter na=
mes (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:108:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:108:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:108:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:139:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:139:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:139:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:165:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:165:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:165:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:190:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:190:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:190:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:218:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:218:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:218:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:250:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:250:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:250:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:259:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:259:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:259:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:276:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:276:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:276:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:294:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:294:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:294:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:309:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:309:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:309:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:350:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:350:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:350:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:364:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:364:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:364:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:394:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:394:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:394:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:451:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:451:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:451:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:469:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:469:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:469:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:480:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:480:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:480:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:499:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:499:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:499:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:553:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:553:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:553:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:585:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:585:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:585:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:600:1: warning: data defini=
tion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/utils.c:600:1: warning: type defaul=
ts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/utils.c:600:1: warning: parameter n=
ames (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c:47:15: error: expected =
declaration specifiers or '...' before string constant
drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c:48:20: error: expected =
declaration specifiers or '...' before string constant
drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c:49:25: error: expected =
declaration specifiers or '...' before string constant
drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c:50:16: error: expected =
declaration specifiers or '...' before string constant
drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c:80:31: error: expected =
')' before 'int'
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3400:17: error: expected=
 declaration specifiers or '...' before string constant
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3401:17: error: expected=
 declaration specifiers or '...' before string constant
drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:51:1: warning: data =
definition has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:51:1: warning: type =
defaults to 'int' in declaration of 'MODULE_DEVICE_TABLE' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:51:1: warning: param=
eter names (without types) in function declaration [enabled by default]

Caused by commit 5b435de0d786 ("net: wireless: add brcm80211 drivers")
from the wireless tree interacting with the module.h split up.

These files clearly should include module.h (John, please apply this to the
wireless tree):

=46rom d89b14ffc84a2b8a54ffe89453b8bbf9cabf1468 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 12 Oct 2011 17:07:06 +1100
Subject: [PATCH] net: wireless: brcm80211: include module.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---

diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/=
wireless/brcm80211/brcmutil/utils.c
index 62bcc71..e96bdbf 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -15,6 +15,7 @@
  */
=20
 #include <linux/netdevice.h>
+#include <linux/module.h>
 #include <brcmu_utils.h>
=20
 MODULE_AUTHOR("Broadcom Corporation");
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drive=
rs/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index e919de2..bbaeb2d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -23,6 +23,7 @@
 #include <linux/suspend.h>
 #include <linux/errno.h>
 #include <linux/sched.h>	/* request_irq() */
+#include <linux/module.h>
 #include <net/cfg80211.h>
=20
 #include <defs.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/=
net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 03607ca..1adc3be 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -31,6 +31,7 @@
 #include <linux/hardirq.h>
 #include <linux/mutex.h>
 #include <linux/wait.h>
+#include <linux/module.h>
 #include <net/cfg80211.h>
 #include <net/rtnetlink.h>
 #include <defs.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/n=
et/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 6885755..bd9db48 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -27,6 +27,7 @@
 #include <linux/mmc/card.h>
 #include <linux/semaphore.h>
 #include <linux/firmware.h>
+#include <linux/module.h>
 #include <asm/unaligned.h>
 #include <defs.h>
 #include <brcmu_wifi.h>
--=20
1.7.6.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__12_Oct_2011_17_29_54_+1100_D6Nf1oi5SKBCq3tH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOlTPiAAoJEECxmPOUX5FEpWwP/R5MwfdDUYayyt6sPaI3YQx0
LpIlXSmu4WBGjju0jTLtx2ugGQIPLCxGXtf6s9XZN3tFC28ayNBjnCf2wP3b4ZNN
4q11bZBz+crE3fz71GEV74iKz6MtLQzTeaoLQVZLlsZq99t/ksuXu6NpJGGkQxcA
59qrN5qnzgR5Octrzw5wZPXYdeQm3+AcM6BId/J+33kArkwGiUsjRZCzybOBCMLb
WBFrAwkKpduFmoa6NSbIR68cZIyfqxzVLele7ncQrqOFtgzyJFJdaIIJG+VHlk0q
qekT24PezGVbp5Ewh3mGWqKkWct8hI37dbaGCXmtEzHG2d5/ANeSLj1pUd43n0J6
NcFMaIboMd+pnjnjRqJM38bpwKf6nwQHswlFtdxF3iXli596F7/k7x0MF3kt1Wr3
F+GFyT5+MXVN4kzh6y5Ls6JkWa3vlkBop6eaLprqNIZPrCqUIXgiQHs83oUGhZGd
eRY/SRPNAbAKDNDt/HXVSBIpLvO0tTYMnIGv0jc+2Q+33+cRu8Gw/j55jHqwJKz6
D7YQOPKFSARyWN4QMKqqNRE36XYLif4dODxEasqm1AhdlT7jijkbP7/5nrSAbMkZ
314rCIyV8Bw5NSRzExMjAOamxw/nC7kB6c/N3hcTIhG+kFoDU3YmFylBO8Vlmegu
vSDtO25zcXQHxvkh5kej
=uWZ+
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Oct_2011_17_29_54_+1100_D6Nf1oi5SKBCq3tH--
