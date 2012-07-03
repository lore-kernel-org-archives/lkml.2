Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2GCWHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:07:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34250 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab2GCWHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:07:33 -0400
Date: Wed, 4 Jul 2012 08:07:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King <linux@arm.linux.org.uk>, mturquette@ti.com,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clkdev: Add default clkdev.h
Message-Id: <20120704080721.5664d57eaf234e6289a0d2bf@canb.auug.org.au>
In-Reply-To: <1341335077-672-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341335077-672-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__4_Jul_2012_08_07_21_+1000_.2mc__n2EhBCVZ0O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Jul_2012_08_07_21_+1000_.2mc__n2EhBCVZ0O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Tue,  3 Jul 2012 18:04:37 +0100 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> Ease the deployment of clkdev by providing a default asm/clkdev.h which
> will be used if the arch does not have an include/asm/clkdev.h.
>=20
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Looks good to me.

Reviewed-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__4_Jul_2012_08_07_21_+1000_.2mc__n2EhBCVZ0O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP820ZAAoJEECxmPOUX5FE0zMP/2wTJMIDnti7DRJ4JCAuDIR1
FPPx/bX3zwL4DC+fqIkKoA8WiPhE4MkD7X7R/YIEVnhS72seRNd+Lx3H4LSLnmSo
+SNOvZnVFAVm0F6khWfLtq2NdMfP6GEUNtTREwjpPRlabztoSi9dAPln/wV5qepL
mUoCZyCapG19Y/Sz0vPDASPc9Dt+/00Vw39P1CNrWhbp5uAVutQSL9nacrqhJhID
e96Mx1mqN1ZfY+YZmvNg4ma3vl60TS9yRYcIISpzTHDa41tGfUUdDCstfllSa3jJ
7L4hK4Za6zBjUoVfOBQs+qiyqZAga6OdXvLtFTVH5PA57v+rEbJjW6efMILLQfPp
iejSRI/1/4YncIiCTfBkRROyyAbWp6fPOegJSB/4jG7eYsuFj1mKG2Ss/ah69wdp
8Xco1RS91LdnDNcXnZbCrrWd4WqzDGAeWSoH7du+wUGPu8Kv610qA2lTanNYDEMq
/Ohuo9ArYkTNG7JGqEu+X04Z1sSwpiIh7FIxRvVZ2+EZ9GzhG1XZT3kwxxneomyq
Qt3jKoaqKzuh3mxP3vq2efonfnj1+wxyw6nBMZS80F6OsY46U42MugV3mCvqFu1G
EA2Z0pDk2MyN+NHkIyjyjyNIjcehF1zXdScTjaMjOmbq9B6nEyA+BuIv0NlWLsk/
H1ZWFhDAFsW/gT0pUlyW
=kSjr
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Jul_2012_08_07_21_+1000_.2mc__n2EhBCVZ0O--
