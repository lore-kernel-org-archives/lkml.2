Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030245Ab2CVCjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:39:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60069 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab2CVCjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:39:43 -0400
Date: Thu, 22 Mar 2012 13:39:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: linux-next: manual merge of the slave-dma tree with the sound tree
Message-Id: <20120322133930.b75bb87714ef197d22d56cf3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Mar_2012_13_39_30_+1100_eON2aC3a77O5uydn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Mar_2012_13_39_30_+1100_eON2aC3a77O5uydn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

Today's linux-next merge of the slave-dma tree got a conflict in
sound/soc/imx/imx-pcm-dma-mx2.c between commit c307e8e32e11 ("ASoC:
imx-pcm-dma: Use dmaengine PCM helper functions") from the sound tree and
commit 16052827d98f ("dmaengine/dma_slave: introduce inline wrappers")
from the slave-dma tree.

I just use dthe version from the sound tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Mar_2012_13_39_30_+1100_eON2aC3a77O5uydn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPapDiAAoJEECxmPOUX5FEi3kP/AslmOWsp6fqmEw46kyoZEqY
NFum5A9eGySfwCd1vrKjkIZOuWJFtc4UigS2WMIaHQM7NDk4fNDZlLshJHJ2h2sf
60tT6Y3TAdDGmGIPYLwswrUlVp/wATZTq/jv4GJOxh3ezcm5TMCyQoT/PVe2a4Ei
V+KvAkWxeKZnjxsXcVbbCfWazQiOx/Bpd/AwtPOrPlS93qF2ZoN1wN8XwOqP1J6u
KdvEOffnVfxPH55hDz+l0O/VC6FO/eHHdIl1GF1J1XJtLURpBEKFJYVsJhSxIIfe
C97Vkr0Sofpaqf2GBsbaJ04/XPnrI6jBG2X/61hNjQqlyFqL+3G9RWMSg4SpmW01
UyeY4AEW2sfu9G5Gt+k2ID6EPUn7zC+Zo7W+HOcWp/CEL2ezYOJiiO+m56M+7x2k
Ow1LQlw1PLEwi8c83Y7xbEGH/wFCxEZdP8GDhpAaa+kC20hQqKnpKbdtXZv24crI
u1q6azC0K19gUElU42fRcFDC3N9EOwc/xfAAltLy3++SNgA7S96jlo6cC3BmtSIy
DhYIaYd8ZVaiFSdAtlgDr3LIOevc66v/dIGWYfnim+2CF7DHZubLbadF6SrSu2EN
go7OWEIs/FmBiQGgDCf95PLhL/m0ecdAMQypqx9YfgQbpa0vd2VdGNoYVBnEpZk6
FsDGkOIh0oqSzLSE5QaB
=c6PH
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Mar_2012_13_39_30_+1100_eON2aC3a77O5uydn--
