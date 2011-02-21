Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1BUFuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 00:50:32 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53386 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab1BUFub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 00:50:31 -0500
Date: Mon, 21 Feb 2011 16:50:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kim B. Heino" <Kim.Heino@bluegiga.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Jackson <mpfj@mimc.co.uk>, Dennis Aberilla <denzzzhome@yahoo.com>
Subject: Re: linux-next: build warning after merge of the driver-core tree
Message-Id: <20110221165023.c3216b96.sfr@canb.auug.org.au>
In-Reply-To: <20110221163727.0addb3ab.sfr@canb.auug.org.au>
References: <20110221163727.0addb3ab.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__21_Feb_2011_16_50_23_+1100__z7p7feV1xp9kDhe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Feb_2011_16_50_23_+1100__z7p7feV1xp9kDhe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 21 Feb 2011 16:37:27 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the driver-core tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
>=20
> drivers/rtc/rtc-m41t94.c: In function 'm41t94_remove':
> drivers/rtc/rtc-m41t94.c:139: warning: passing argument 1 of 'platform_ge=
t_drvdata' from incompatible pointer type
> include/linux/platform_device.h:133: note: expected 'const struct platfor=
m_device *' but argument is of type 'struct spi_device *'
>=20
> Revealed by commit 71d642908d4e8e7a2a4a6e0490432e719ff466d5 ("Driver
> core: convert platform_{get,set}_drvdata to static inline functions").
> The warning is in code introduced by commit
> 8fc2c767b06067b417c565c4e75731e68ed41fd8 ("rtc: add support for ST M41T94
> SPI RTC").

There are also:

drivers/rtc/rtc-ds1390.c: In function 'ds1390_remove':
drivers/rtc/rtc-ds1390.c:161: warning: passing argument 1 of 'platform_get_=
drvdata' from incompatible pointer type

Introduced in commit 06de18085122b873012cb23f043e2bdcf5f50923 ("rtc: add
Dallas DS1390/93/94 RTC chips").

drivers/rtc/rtc-ds3234.c: In function 'ds3234_remove':
drivers/rtc/rtc-ds3234.c:161: warning: passing argument 1 of 'platform_get_=
drvdata' from incompatible pointer type

Introduced in commit 2f9b75e09ec3f62f2ebecec0ac9aec58656c2459 ("rtc: add
device driver for Dallas DS3234 SPI RTC chip").


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_Feb_2011_16_50_23_+1100__z7p7feV1xp9kDhe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNYf0fAAoJEDMEi1NhKgbsV+YH/Ru+WO6aDz2Wjk9BkzNH6lJZ
spyk2aeQe5pOdM0MuLSM/le9aJBU5ZoN8ZhdoUXuv8z1RGXJ+N12PFs/zJp9TtkP
i8IhLaKUa0iU2hMxiZqOL2DwaTEA0ZX0p9giQmpO+QTZU/cyjjChadF2E47sfKZf
HpAqZK7HduuTme4b1yMuZ6g6/vvqEHAdJYXV0ZfUGXfIwuOnYGDqPXVd0YbjiPqU
WAm4n2NQpfpu0BXLlFvzmUTgqZZN5otcx3ZDqtUNPRH6ucqooh8Sy3RP9GS50AIr
Yr6tjQznbuR4ZKypX36GWdJ3XWnxwNjvk2scngxWH6olobFFYdXRS8uqCD4VwaI=
=ci2O
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Feb_2011_16_50_23_+1100__z7p7feV1xp9kDhe--
