Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab2ERPgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:36:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37203 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673Ab2ERPgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:36:19 -0400
Date: Fri, 18 May 2012 16:36:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/16] regulator: db8500-prcmu: Separate regulator
 registration from probe
Message-ID: <20120518153615.GF4039@opensource.wolfsonmicro.com>
References: <1337330355-17747-1-git-send-email-lee.jones@linaro.org>
 <1337330355-17747-6-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gdTfX7fkYsEEjebm"
Content-Disposition: inline
In-Reply-To: <1337330355-17747-6-git-send-email-lee.jones@linaro.org>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gdTfX7fkYsEEjebm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 18, 2012 at 09:39:04AM +0100, Lee Jones wrote:
> This will provide us with a convenient way to register regulators when
> booting with Device Tree both enabled & disabled and will save us a
> great deal of code duplication in time.

Applied, thanks.

--gdTfX7fkYsEEjebm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPtmxoAAoJEBus8iNuMP3dbI8P/1ccbeUTEy4Pt4voKhSgGg+W
oOgtLDZ2TL9fKxDBqUvmxBeOChVEpxOeKgxGZ61r9f+dLqwxSWuM9EUlcLGQNiZO
HFp+gLF6MUwDDK3z7P3DAAP7S6DDxUcn90qWHYWfXs2/EOgO1s5w9Kg+Awt0Vl0y
mu1/w0dY83lslFeRH7gQhjZLa7DjdvKYnUeByQjzREZaQ8hoolz9fvaLhnHKhCP2
tL55//XgrN22E2lLK750WirP5m/5O+npy09F4fmVCIzLs6ppikxqp+puyWthmtGA
ieo0VG1BlpQpngVlBuJth/0XgO50rO6sa63A5LSZM9MF/zPxzDpER3TScAzPTGc9
Dg70UbCLyJjThI88amSz4GtxU+iPUVBzPSOvP3alSB56V3uUkZdbXfCRb5ZCAAh+
nCeDppuzgBQZv88wQazL0PnKH4UORUVwJ8Lg4KUH5DVbbQamH1dhFtrMEKKEww6P
+mc+Wxgc+4lRYYDx4leqq2pZy0/WBJz5iGOWk0dp34FG8aIbSXpyhUSqY8kHBKTa
0D9J9h9XuRsCYXC7HtuCkzXziEFnraavUtAKN8rX6ikCrw4JbNmQ2LztIH/ElCaw
EVTwUsL6/qNVySmEJgqxSlDUanZCsdCpHziNyDouXScITZNfnd9wtSmlvNYspIn6
VnEsRUq3amzoPaXiWqQP
=C7cf
-----END PGP SIGNATURE-----

--gdTfX7fkYsEEjebm--
