Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab2CHFzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 00:55:47 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41024 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2CHFzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 00:55:45 -0500
Date: Thu, 8 Mar 2012 16:55:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the omap_dss2
 tree
Message-Id: <20120308165539.8a3b718be677de97a8767cd5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_16_55_39_+1100_r+CVUrMNoJ2P=hBP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_16_55_39_+1100_r+CVUrMNoJ2P=hBP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap1/board-nokia770.c between commit 58e0d6ab02eb ("OMAP:
N770: remove HWA742 platform data") from the omap_dss2 tree and commit
2e3ee9f45b3c ("ARM: OMAP1: Move most of plat/io.h into local iomap.h")
from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap1/board-nokia770.c
index 9b6332a,abdbdb0..0000000
--- a/arch/arm/mach-omap1/board-nokia770.c
+++ b/arch/arm/mach-omap1/board-nokia770.c
@@@ -30,7 -29,7 +29,6 @@@
  #include <plat/usb.h>
  #include <plat/board.h>
  #include <plat/keypad.h>
- #include "common.h"
 -#include <plat/hwa742.h>
  #include <plat/lcd_mipid.h>
  #include <plat/mmc.h>
  #include <plat/clock.h>

--Signature=_Thu__8_Mar_2012_16_55_39_+1100_r+CVUrMNoJ2P=hBP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWEnbAAoJEECxmPOUX5FE/lIP+wSIKyn7EFKDRkK0LH/rm9Ga
QySNT63cJv58WFDQS+3+BnAO6fRFVXt7lVFJbbRVq2Oq6PbzJ0rei1u0hCRcMsa/
Vr4sFMU4Te29YU4rM/vgl7yDf1gv0xSa4QGvFQwAHp5I6GroH6cebs0E0XNoWTQt
rVBUW9/cTnxALnDjZdzGaKM5D58AOWW2PJOonRsEGB8+CE1UgxmXZXHeks+9D2rf
eqEP20ynUPDA64M4E1m/syex4Wa5HIRxkODxl7mnwVOXPnKzWpNDpH9qZBmx1uTG
FgflkBj7xGkJ/UvCEghrNZorI1mL5TpRZr8M3dCiB1seKNJ1OmvpmMW/BZnf2u9N
wqoQ/ClIN4RNUpo/+khOfywa/Fg70t0djvUGENkLCEIE0ynHyoLISZpMOcfuqqyD
iiRPoqA74SHFYEUT5pRKzTZl5Zeb3vW8y2tmfiUHiFiHxPOB+eiOEZk5VProwKzu
TEGy0nUckU4+RjX71EL28jMJbQfRRabY/Grsn1i6iudbM5F+3f5NEgjcRLckVVBW
/pofuaF3Xmd6BJEPKprQUDbN3jSAdrd7K4nVHF2Ynxopy2MmsOocI6qR4gtj0GGR
2uuMgnTsmubRQBpFTRqfv2LzxUfiCpSU3vI+9gKWhbFMG7XiVEGzf8T9f7Ip+gwT
MbuUIR/SAyWMBMqC0PCy
=3wBG
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_16_55_39_+1100_r+CVUrMNoJ2P=hBP--
