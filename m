Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab2ADBkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 20:40:37 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:56143 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2ADBkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 20:40:32 -0500
Date: Wed, 4 Jan 2012 12:40:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20120104124020.5b481be704bd0040219ee0e0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__4_Jan_2012_12_40_20_+1100_WY2aPh+iFs/WMqnc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Jan_2012_12_40_20_+1100_WY2aPh+iFs/WMqnc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/rtlwifi/rtl8192cu/sw.c between commit 9d9779e723a5
("drivers/net: Add module.h to drivers who were implicitly using it")
from the  tree and commit e97173c985c0 ("rtl8192cu: Fix WARNING on
suspend/resume") from the wireless tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index c244f2f,a48bea6..0000000
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@@ -42,7 -42,8 +42,9 @@@
  #include "led.h"
  #include "hw.h"
  #include <linux/vmalloc.h>
 +#include <linux/module.h>
+ #include <linux/atomic.h>
+ #include <linux/types.h>
 =20
  MODULE_AUTHOR("Georgia		<georgia@realtek.com>");
  MODULE_AUTHOR("Ziv Huang	<ziv_huang@realtek.com>");

--Signature=_Wed__4_Jan_2012_12_40_20_+1100_WY2aPh+iFs/WMqnc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPA64EAAoJEECxmPOUX5FEjTAP/Ai82hdlxmnpw5DHsGAFBWWp
3r+TZT5hRFRwFDoFBuwH+QQX9h5LfPMcutjXBZT94L3/boq0+WhUKBNhATVYNGir
8zudWqGaaCg0h8Jm0jacKC9ledfx55GlfDHp4rO7Mqp68kiEFgX7hQxu5hlRiVt/
xDDeuzuaSIK8Ex+4h1ELhoSgdDwO2/ZNiizDNU5/Jqv8bhUzE4Pp9YtbYywtEwof
ip7a2Av7nvRqZNZdGOCbit7jZ5YaBf8KRDWS0wmxAb1D0oQGAzB1fKZxOg5DlXAF
VJadyzzc7epUEwgd5k9VDRnHB8Cl1e5C3XnaF6XSkool9LyOyKraUzpXhpn4Q4DN
luYHfCO56cXzcw43E38ztzZGADHLYwGUM/LCnnHNCn4cMf/78mLc+YZAC+uLBTMd
DouO3sST9/NVmTOIXqViwiKaHbBopfdEfhWOn1twIe1phx3vkfBevt+nUl1UtiNX
UaUBD4Eo0QTgFD3U78spyzLI4Dt98ELRoqFVrvAcwZUbQerv7C0DfyTSVcZnaZsK
+yIgMIMiXeIgUvxnRfKrYGmLNuuQuuLD1qgbjV+DE16AktUH1llpIn2lUttrjQdn
XohElee05MkSMBJRU9/NO0hulPh5xwqLNPaa3YGbg68V+L3vhQ8PTUczZnXukZMQ
kWV/WkQJ2eGEloUS02Wj
=YHOK
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Jan_2012_12_40_20_+1100_WY2aPh+iFs/WMqnc--
