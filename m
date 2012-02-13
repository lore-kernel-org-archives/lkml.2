Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab2BMWKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:10:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60551 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511Ab2BMWKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:10:21 -0500
Date: Mon, 13 Feb 2012 14:10:16 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, dunlap@xenotime.net, lrg@ti.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1 0/3] Support for open drain gpios in gpilib/fixed
 regulators.
Message-ID: <20120213221015.GB11931@opensource.wolfsonmicro.com>
References: <1329114588-15430-1-git-send-email-ldewangan@nvidia.com>
 <CACRpkdb5VA4GJpB_0Xra=R0LUD9fz4CoDLjuwFHZ8SnTMz3fpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <CACRpkdb5VA4GJpB_0Xra=R0LUD9fz4CoDLjuwFHZ8SnTMz3fpg@mail.gmail.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13, 2012 at 09:02:03PM +0100, Linus Walleij wrote:
> On Mon, Feb 13, 2012 at 7:29 AM, Laxman Dewangan <ldewangan@nvidia.com> w=
rote:

> > This is series of patches =A0to add support of the open drain gpios
> > in standard gpio library and using this in fixed regulators.
> > - Added GPIOF_OD flag so that client can request the gpio with this fla=
g.
> > - Added support for the sysfs interface for open-drain.
> > - Handle open drain gpio configuration properly.
> > - Use this flag in fixed regualtor to tell that gpio is open drain.
> > - Gpio documentation changes to have support for open-drain.

> My gut feeling is that this stuff needs to go into pinctrl.

Does that really make sense for cases like this where we're emulating
the open drain support rather than actually configuring the hardware
into an open drain mode?  That emulation is a pretty GPIO specific
thing.

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOYpBAAoJEBus8iNuMP3doK8P/RJqkDHgKuFEdybO5UCAt+K4
pZcWrolaDlHU+GHfjhSGi5l9bAm9XbViwnv9WiGPaePwrRU9go06EIbSfAsDZ2PA
AAOv9X/gAXdnVUn7rJhA3wVB4EzrzYHpU2U+ei4SZLSzxMMDzGzvFrUweTYN3o4s
huHvG8BMTheqpRelxXM5UrRsNZ7IM5npJzmFbEeVwCN5ROxDSkXljDoKtqZjON6G
8y/H+KiJD5WdRiIO5w/6vgRz1ytDxryVj8wPZy4zrI8mb4rGnID2AcV9M9NIFfHm
GgR+PW0tIO+2qp44G94MApbHr4mb+LNJAXuE1tT3nKMxCQr3vMQJjR9q3/9/yJQq
P8dKCsE1ISEOJg7lZJmljMpGxr999VOFM4VueN5v/XJrvVG+Nomasl4dhu4KpI1c
L31TPQ6Q4yG4JohpQYIMBLpMfYNmBAK3xrEg+CgeVq4R5I6QvPKL2WkeKn7up7b8
rju2uY0lCLhL+fMxtbblLey4yqauYGVsg8tOUQRmJVcPZ5bV/J5Sdq78j/ggElF9
tb5+nrdYEYGCEFnHlZ88HI4qHqfPExh+fhUswEg5tBgcDx35bMKGbAK5HApLvT0p
4vLxXw3m72wMNWLwB0PaS7llxlKiPCaqHkCvKtYALAdQtiy40IExXkWFI5GI1K4a
Lh+1sCHvziouusjVxPwS
=/udR
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
