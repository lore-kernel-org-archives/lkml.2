Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab0LOXbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:31:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46565 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab0LOXbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:31:51 -0500
Date: Thu, 16 Dec 2010 10:31:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/linux: Add missing include / fix build failure
Message-Id: <20101216103141.6f0a418c.sfr@canb.auug.org.au>
In-Reply-To: <201012152204.18881.PeterHuewe@gmx.de>
References: <201012152204.18881.PeterHuewe@gmx.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Dec_2010_10_31_41_+1100_WetOpxbSu7BuwW5P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Dec_2010_10_31_41_+1100_WetOpxbSu7BuwW5P
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Wed, 15 Dec 2010 22:04:18 +0100 Peter Huewe <PeterHuewe@gmx.de> wrote:
>
> From: Peter Huewe <peterhuewe@gmx.de>
>=20
> This patch fixes a build failure[1-2] by adding the missing asm/memory.h
> include needed for arch_is_coherent().
>=20
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> KernelVersion: linux-next-20101215
> Used configs: hackkit_defconfig (arm), ep93xx_defconfig (arm)
>=20
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/3651495/
> [2] http://kisskb.ellerman.id.au/kisskb/buildresult/3651425/
>=20
> Error Message:
> In file included from include/linux/list_bl.h:5,
>                  from include/linux/rculist_bl.h:7,
>                  from include/linux/dcache.h:7,
>                  from include/linux/fs.h:381,
>                  from arch/arm/mm/mmap.c:4:
> include/linux/bit_spinlock.h: In function 'bit_spin_unlock':
> include/linux/bit_spinlock.h:61: error: implicit declaration of function =
'arch_is_coherent'

All (or most) of the above information should be in the commit message
(so above the "Signed-off-by").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Dec_2010_10_31_41_+1100_WetOpxbSu7BuwW5P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNCU/dAAoJEDMEi1NhKgbsjOQH/RkrPfYq8wzDOrrDqb4pCYqY
/ajyjUJtOUZriQcT0/qBUIGAKonIt21Nra9suDjCd40k0xs0hRsAf7GTlxXt311u
wSXkiMve36nb6srdjQHjauOg/Ia26a4hXLwgcD5ZO6v8ffwsKutPmV7RHCuzz40X
LBaAjyCLDD0TP3GNwgf4VD+8AIqQENTisLdJoHaVbHBjjU06eVd6zN6Rh4/G2mU/
l52Np/UUvH0Yf+6eQ797UOV5/Ht2ZkoU4PEkPnSqUuNyvE9VNu1mGqGnRmoVMSW9
9z13w5NFBzx8obS0sgBJiDhgQZwPheHmYp4VTPxk8fnVwRRXBv56xKJks0cwBiU=
=BvRT
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Dec_2010_10_31_41_+1100_WetOpxbSu7BuwW5P--
