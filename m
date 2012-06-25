Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab2FYWbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:31:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41222 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757430Ab2FYWbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:31:01 -0400
Date: Mon, 25 Jun 2012 23:30:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] gpiolib: Add support for Wolfson Microelectronics
 Arizona class devices
Message-ID: <20120625223058.GD30406@opensource.wolfsonmicro.com>
References: <1340454566-7206-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACRpkdbKyHtwcsGoph_s-YPtn9yUxxKQBfXc_ksiNu=yE51spA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6WlEvdN9Dv0WHSBl"
Content-Disposition: inline
In-Reply-To: <CACRpkdbKyHtwcsGoph_s-YPtn9yUxxKQBfXc_ksiNu=yE51spA@mail.gmail.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 26, 2012 at 03:13:58AM +0800, Linus Walleij wrote:
> On Sat, Jun 23, 2012 at 8:29 PM, Mark Brown

> > + =A0 =A0 =A0 regmap_update_bits(arizona->regmap, ARIZONA_GPIO1_CTRL + =
offset,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ARIZONA_GPN_LVL, v=
alue);

> I'm guessing that regmap is caching, selectively updating volatile
> regs and marshalling the writes in the background.

It's just the standard read/modify/write operation (the same as you've
got for ab8500 IIRC).  As far as the immediate user is concerned it's
just doing the I/O, the API will work with cache or the hardware
depending on how the chip register map is configured.

--6WlEvdN9Dv0WHSBl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP6OabAAoJEBus8iNuMP3dTEEQAJ2ryh9tN6Kq/9wauYCPDaER
TOaIgQ6kWlOu247wzIQTuWXGj1qsmvKwGRZ/Zsw89BTzI42cVRhIPQMR/QvMdgWQ
3zG16H+qTMHQ2olFK6acl8LOYMy5b9LPK/AM/EtzEX0oopMlhHwj1n+mLJ2sS6hB
zXC/ZcAK5mMwUcMhSUXXnflwAHPkDbPmfElf8fWCgFGUDoQgvv9aW8ppWr9jQ1CP
xxhw4/+o1l5ZsAh07+7dKDwjMw91T/xxG5fr9IbG9oE4dNUpYk3qPZmJ1j1DHvw9
ueDbMBo+vwqm4lrHS9DkIwCdbhpR+LwtdZUAUfsw1A7L65gT+8CT7zO245Vfhxw6
CZsNQZBBybj3W5GdaOzYnwQmkT2ZLFuWbgIe+sh/M9rqLJkSzfUr5tWaelOhl4IL
ZtRhKpd3IzuhnvXEGAKX/q1WYVU0O0kj7gpCDuYgTvWRx5qrjUDnv5AN6k8xRhxL
1NqSNoTp8zr6Q9NfaqkEmuWhdLrQ6NxH0q3ZdVmL37B+mzwBTW7FlV2wzuQDcDQB
KhzWdyq/Zz7PdhDlCKbMxXMlONN4x4/tFCjgA1B1U2ZO3Py+7htOPbHCtncD1RGI
A2M9rfY3lYny1pIEBb5xZ3xKkN1eV+JIIJUp0ZqIUDXWewdQ1JmNt8U39/T45+A4
UXzlCh8JL4uewBejurjq
=4UHw
-----END PGP SIGNATURE-----

--6WlEvdN9Dv0WHSBl--
