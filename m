Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab2GWMMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 08:12:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49871 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2GWMMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 08:12:42 -0400
Date: Mon, 23 Jul 2012 14:12:22 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpiolib: Use seq_file's iterator interface
Message-ID: <20120723121222.GA27187@avionic-0098.mockup.avionic-design.de>
References: <1334229961-1844-1-git-send-email-thierry.reding@avionic-design.de>
 <201205121256.14283.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <201205121256.14283.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:TEhiFmlr1l4eE+TCR8yWlNgjsu+KD5h/ub0h8k9UTIv
 BvRxr51W3abiajkyaViLCUhh91wcAeIoVX0AzGjo4o5gmU3OlB
 w8T5O7F2pRubWwZLQ5ZpQu9YKDJHwT9+ZFjK5fqH3F90D858HZ
 wNfP8VjzOlJAgQ+CEstfUU6Gp20e+TRNSIbTxGFdaalzVjhhM0
 l3fzkuQ8ELNbnYxCiGy5o2Gc6aIVG/ybAgfXOiE+QzznncjgNc
 b72ne7GA3DAtacomZgTpNq9+wup5Eys9MJdYIV7RlCvhBsvIcb
 3slpC21toKeLzT87cyO0Lwu40tuQu+l2AZXXFANkyB+9xPmhrO
 dLgyUaydt/f5rNZAn/OcpsV/5X71Ht6nDatdJXu9C6LuewnBYM
 ELZu1jUDcxZKhPdJLFtGJB6KN4NTAy2My4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 12, 2012 at 12:56:14PM +0000, Arnd Bergmann wrote:
> On Thursday 12 April 2012, Thierry Reding wrote:
> > When dumping a collection of items via seq_file, it is recommended to
> > use the iterator interface. For the gpiolib debugfs interface this can
> > be done to dump each GPIO chip in turn.
> >=20
> > Note that for gpiolib this is a little cumbersome because it does not
> > provide a list of registered GPIO chips and the only way to iterate is
> > over each GPIO individually. Once a chip is found, the number of GPIOs
> > it provides can be skipped as a small optimization.
> >=20
> > This patch was requested by Arnd Bergmann here:
> >=20
> >         http://article.gmane.org/gmane.linux.ports.tegra/3535
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Cc: Linus Walleij <linus.walleij@stericsson.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: linux-kernel@vger.kernel.org
>=20
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Grant, Linus,

Is this good to go?

Thierry

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQDT+mAAoJEN0jrNd/PrOhsM8P/RNd8m0kJ190ATvq++fnWtum
igLOrdb7lK2vPXSqL126eHKegNTLmGF0CKZiom72leBMLcQcOz6MRTNrR9lC6SN6
IgPsBxxHUPU3Iz8ie7eePUZ7VzGJOszKbOkT+VgD+wPYaBPQPPpY/BIlz3NdcNfd
DiRz+YGEamaAmxtHVl2VKrlDYrythUZUCfLfFNgoLdi7tlTAMc5+g5LS0u5qFC81
KYdi8B2J72Bj2JsVAA9yYXJa54b7GIPdHGey1ON7ZzK1unXEsumChIoJnkdYb6CG
UwZeSvMO2Xfg9w8+Pwa16WSEB83ylM/8ia56yv3geAcNgY0mwEJ4Lh6VTmmb/A3X
zhsYR5HlXhowYzcN3li2CSkyr4KT0g4XNxX5SKtekJALQdW258vt8semPoXfQhqc
u3PgEdAS/IKNJTMwOYSMcRqmXntTQUNs8/JgN1hGml8yOyNfRZqQ/UpqngNH6IC+
YWi/ZkQTm9V0VfPE8X4LyjoNponJq7VhnuDEo/dbzUpjO0gHPHYqCwdfSqrx6ckr
q4jtG6jFLHcVd7YZqZUr0YASe1qSjQzR3RPFOXPxnhjewCNxVghYOWePeZRzJm70
ga02StrsERVK3pZ5GULnqCyNjlmr8T9GyTFiGlU4sg8sCcWfB7H46Ol/tLGPqqlL
Curl/PNaWj/YM2AtXy5P
=2KHy
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
