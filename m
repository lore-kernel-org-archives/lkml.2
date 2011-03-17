Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab1CQXKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:10:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51213 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab1CQXKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:10:12 -0400
Date: Fri, 18 Mar 2011 10:10:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Kim B. Heino" <Kim.Heino@bluegiga.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Jackson <mpfj@mimc.co.uk>, Dennis Aberilla <denzzzhome@yahoo.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: build warning after merge of the driver-core tree
Message-Id: <20110318101002.8ef23d7b.sfr@canb.auug.org.au>
In-Reply-To: <20110221165023.c3216b96.sfr@canb.auug.org.au>
References: <20110221163727.0addb3ab.sfr@canb.auug.org.au>
	<20110221165023.c3216b96.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__18_Mar_2011_10_10_02_+1100_4U/nE7EamBeIYFe."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Mar_2011_10_10_02_+1100_4U/nE7EamBeIYFe.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi All,

On Mon, 21 Feb 2011 16:50:23 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 21 Feb 2011 16:37:27 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > After merging the driver-core tree, today's linux-next build (x86_64
> > allmodconfig) produced this warning:
> >=20
> > drivers/rtc/rtc-m41t94.c: In function 'm41t94_remove':
> > drivers/rtc/rtc-m41t94.c:139: warning: passing argument 1 of 'platform_=
get_drvdata' from incompatible pointer type
> > include/linux/platform_device.h:133: note: expected 'const struct platf=
orm_device *' but argument is of type 'struct spi_device *'
> >=20
> > Revealed by commit 71d642908d4e8e7a2a4a6e0490432e719ff466d5 ("Driver
> > core: convert platform_{get,set}_drvdata to static inline functions").
> > The warning is in code introduced by commit
> > 8fc2c767b06067b417c565c4e75731e68ed41fd8 ("rtc: add support for ST M41T=
94
> > SPI RTC").
>=20
> There are also:
>=20
> drivers/rtc/rtc-ds1390.c: In function 'ds1390_remove':
> drivers/rtc/rtc-ds1390.c:161: warning: passing argument 1 of 'platform_ge=
t_drvdata' from incompatible pointer type
>=20
> Introduced in commit 06de18085122b873012cb23f043e2bdcf5f50923 ("rtc: add
> Dallas DS1390/93/94 RTC chips").
>=20
> drivers/rtc/rtc-ds3234.c: In function 'ds3234_remove':
> drivers/rtc/rtc-ds3234.c:161: warning: passing argument 1 of 'platform_ge=
t_drvdata' from incompatible pointer type
>=20
> Introduced in commit 2f9b75e09ec3f62f2ebecec0ac9aec58656c2459 ("rtc: add
> device driver for Dallas DS3234 SPI RTC chip").

These are now in Linus' tree :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__18_Mar_2011_10_10_02_+1100_4U/nE7EamBeIYFe.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNgpTKAAoJEDMEi1NhKgbst3YIAInN7wUzOLhe/Y+F4DMbOOSV
Wy3LGxW5RqwIB4YiJ0xq78/VWvJBGad1u5NyVPwiQJqQjELhCmbwtvKfGom+/OcJ
sddZ29Dqwz5csZ30MOYCa7kBaLZeSpVJu/Q49rjme8I2rdJDkmzZ2bSJSaXDBlSO
ZydtS/XkttdMWYEwF5RjGeBH8cR1Vt3ef1qLqT5edV1XlNczY4eB59DgvobhWYYO
m0pPjPhW6Wwk1qiWQwYiwsV79Az5p4A7lIqHUj/1BC32fsKU+4sMhwcmqi9dlSo8
+ACePrfJgX/zN40LFtg1Zejfe0KcGXTHZDxN+GSwpfaovH1C0S3+iwB5xWKuBts=
=8bcP
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Mar_2011_10_10_02_+1100_4U/nE7EamBeIYFe.--
