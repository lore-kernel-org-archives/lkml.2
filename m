Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1JMGUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 02:20:20 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:38192 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab1JMGUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 02:20:18 -0400
Date: Thu, 13 Oct 2011 17:20:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the moduleh tree with the staging tree
Message-Id: <20111013172005.3fddf0e3ef5f5b5c5736b04a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Oct_2011_17_20_05_+1100_Tpc6SF5AnPit1cIE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Oct_2011_17_20_05_+1100_Tpc6SF5AnPit1cIE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got conflicts in
drivers/staging/brcm80211/brcmfmac/bcmsdh.c,
drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c,
drivers/staging/brcm80211/brcmfmac/dhd_linux.c and
drivers/staging/brcm80211/brcmfmac/dhd_sdio.c between commit fc2d6e573be6
("staging: brcm80211: remove brcm80211 driver from the staging tree")
from the staging tree and commits from the moduleh tree.

The former removed the files, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_Oct_2011_17_20_05_+1100_Tpc6SF5AnPit1cIE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIbBAEBCAAGBQJOloMVAAoJEECxmPOUX5FE7JgP+P7G7dXXbAqCRFPMnsxRTwFu
SWRARL/eEOt8KLncYke1t5LqulA475Z8IorbYp6VEK4MYZMpYxx7NPxAdj25mIAG
rcnEFncj73Eexg1IR6G3t0liaXRRSmiUwlriMk0ukeB0WNzCFx332qWyKwjU/TL0
qYIw0NZzBoVkoaKkcNQXQ/MF9Lpxk+ZA1s+godgVRTgRJZJzMr+PM1RVk0Jd/yoQ
uQ15s2zdhNBbWTsbZEBDsavpFkIoSKnuRkVXSTU031S1qp5D7v2hdx9jZy2bUJg/
4KJBc9Ik3+RgGF8sTJpjY1jeG9N+TaoBhSWf0oTw+cIlD5WV3AyVp3RVqZoehjRA
FIadc+nXD24hrBRX/QCvAFBLaFuG/McofEleeyergDIJpWhqks9k+yDrxwLD+FMm
3OsrPaTpTqmCYl2Z6OhUVwJsz+59WT1vfSTQSb1I9hhzdjb5OBCJ+8rpf53iWNWY
MouksZuMLIwohliFoWqm3yaaBjcDJHxsnHH/aIjdGovbsaY2E8NZ9xs+U11wCIHX
qRSfiIXU7uMO/gzm9+L6b70FEZW59/35E/sk8m5ZWQtk80EZH7uVXL0L39kAg8wy
aohwJ2zR+CqJ9y1wZz3rmyCOEVxTj8RK/qTIrfiFvh8/wltNjcIkwHEUG19KBzVo
rjiASbuTeO5RPsfBx94=
=l02S
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Oct_2011_17_20_05_+1100_Tpc6SF5AnPit1cIE--
