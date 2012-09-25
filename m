Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab2IYGrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:47:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60204 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2IYGrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:47:08 -0400
Date: Tue, 25 Sep 2012 16:47:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: linux-next: manual merge of the arm-soc tree with the sound tree
Message-Id: <20120925164705.602503e31a0c29e88bbc9066@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_16_47_05_+1000_bgwABrL4WGm/vy2k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_16_47_05_+1000_bgwABrL4WGm/vy2k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
sound/soc/omap/omap-pcm.c between commit 946cc36ae550 ("ASoC: omap-pcm:
Convert to use dmaengine") from the sound tree and commit 7d7e1eba7e92
("ARM: OMAP2+: Prepare for irqs.h removal") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc sound/soc/omap/omap-pcm.c
index a2636f6,b309941..0000000
--- a/sound/soc/omap/omap-pcm.c
+++ b/sound/soc/omap/omap-pcm.c
@@@ -29,9 -28,10 +29,10 @@@
  #include <sound/core.h>
  #include <sound/pcm.h>
  #include <sound/pcm_params.h>
 +#include <sound/dmaengine_pcm.h>
  #include <sound/soc.h>
 =20
+ #include <plat/cpu.h>
 -#include <plat/dma.h>
  #include "omap-pcm.h"
 =20
  static const struct snd_pcm_hardware omap_pcm_hardware =3D {

--Signature=_Tue__25_Sep_2012_16_47_05_+1000_bgwABrL4WGm/vy2k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYVNpAAoJEECxmPOUX5FEhrsP/AxsIZ6AAbnfu5oa19vMzU8V
GVHd3O88nshIpSCD9t/nVsDg1u8od+6n6j65n0g2CVGXGypm1il3QOEU3+kP+RY9
bL+Soj6qyRJLgRenMukvuX8O6JYrnrrTXsdPQjgJymUh7QunGeb7SWkyF/RM7sNK
ypfk44oHxs8xVPs3848G+0qsJXW8ufiE4Mf8c6LFzVcyJAxc1jpLixxn/XH05bMA
P8gV3mHvdU+I/Vc+3hMRmddDUkRQff2MS/zmSQ4g/OcLI0iKymejDyAJDoFWT2TZ
OLQajpGucv5i92+s1AjtlFA0p0Qm73G+c6ugd+dzVDwHfkNVlFd6QfNA7Y0luMnG
1f7oHfcrFeFblSK3jUqCYZ1Xmkz9ktVREY/rIcoI58cj9TLZEOSKklJkSoQHNn78
OASZJ34iYSYHk5dkjhB1ToaapfjZMrS1HCk5h0rB51kRSIdKV4I40SMCb1e7d55S
U4wVKXDizrF3r/QMmbgvajirEjbt8r3gfv7vSDzKVF7pm+bahQDUO7uCENZanBGp
v20CusmJAKJ/KBzwXp1QyQkF3grfNyHQM1xnN6MHCrD7bCqJFJKfdPQAA/HJ/Wp5
97LJ2S2ANiMbVActJhZC9KKT42qDNZnJ3r/7M238gbomjGQ/WxR5LAlNQGila+NT
yozFdkFrhu2K80k8WV93
=JR0T
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_16_47_05_+1000_bgwABrL4WGm/vy2k--
