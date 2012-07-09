Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2GIN4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:56:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40954 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753527Ab2GIN43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:56:29 -0400
Date: Mon, 9 Jul 2012 14:56:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120709132420.GF3934@opensource.wolfsonmicro.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120707032907.GA15120@srcf.ucam.org>
 <20120709123253.GA31383@sirena.org.uk>
 <20120709130629.GA29130@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ahP6B03r4gLOj5uD"
Content-Disposition: inline
In-Reply-To: <20120709130629.GA29130@srcf.ucam.org>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ahP6B03r4gLOj5uD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 09, 2012 at 02:06:29PM +0100, Matthew Garrett wrote:

> There's ongoing discussion about unifying ACPI and ftd representation,=20
> and once that's done this isn't a problem, but right now there's no=20

Where is this discussion?

> terribly straightforward way to do this without a lot of basically=20
> boilerplate code. The biggest issue is that ACPI has a very different=20
> idea about event delivery and we'd need some way to abstract that.

Right, but there's lots of bolierplate code with this stuff anyway and
it's not fundamentally hard.  Last time I looked at ACPI it had a rather
different model for how all this stuff would work than DT did which
isn't terribly helpful here.

--ahP6B03r4gLOj5uD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP+uMBAAoJEBus8iNuMP3diRUP/3hVh504e7dVZabDmfkER032
R+8NEfBxbQBpI7m1ZCubKtqHNitaxFKXOZKijENS2msUJmidUn/75HxNhDX1TTA0
HfQ6hgyX1B9QhVb5oJ1jitd1esAJah0c1U3S16yV10dlZMMxT6QiwB6uoPezYy72
FIDxqooX5XQO4LnJBOAH0BW06D5kGl896SCTbEQyTYaKxDtfJgHKBFxZoccg/5Hi
C1bpBKVtnITOD4TO9TPPF8GJxpVh59/u5pj3PA7lHIaduYD2VLYNcZBm95GGYWI1
oOrWtFfs+Mfrqch2GJmkua8AAzvuNp7OoMuT+tcgqczI0ZCZvqbJERal6gPzhC9D
TtJKGId2ivyvEC7WCpqFlUYXFGvFJs5//qEc91Nl9zeDtXaew0OZJYGo743XPOfm
BL4oabBpzLkPlg7QxaxSvRUD6OufBm6Vsh8/BdZNs0m0anyh33UV0FFXhK7P836e
oS0xwrpw7zNoa7nnANOouLwsnFESwH88OYVltoSodkvNYj4boo8Z1jsum0tcqJJI
otUIbSF1lO7y1sHOZ0G2mekZyEFho0LnqrH/iiFDtZxAEzkc5XzNpMeWg6sPVF6R
k+PhpUYmJEGePI3LqAI5dFvM9VFaWXKH+fVJ89cJJ0ALAb4ED0cA1nFoQEu4Rlyf
MsjNmDPW4rpgtXeU68sH
=XuZi
-----END PGP SIGNATURE-----

--ahP6B03r4gLOj5uD--
