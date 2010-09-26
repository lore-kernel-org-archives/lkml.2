Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0IZPEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 11:04:49 -0400
Received: from vps.mortis.eu ([79.99.135.181]:55890 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab0IZPEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 11:04:47 -0400
Date: Sun, 26 Sep 2010 17:04:43 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Lutz Ballaschke <vegan.grindcore@googlemail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/3] watchdog: add f71862fg support
Message-ID: <20100926150443.GA7185@salidar.me.mortis.eu>
References: <20100926142535.GB2150@kreios.titan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20100926142535.GB2150@kreios.titan>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 26, 2010 at 04:25:35PM +0200, Lutz Ballaschke wrote:
> Watchdog support for Fintek F71862fg Super-I/O added.
> Two different hardware reset pins of the F71862fg chip can be configured=
=20
> by an additional module parameter.
>=20
> Signed-off-by: Lutz Ballaschke <vegan.grindcore@googlemail.com>
> ---
>=20
>  drivers/watchdog/f71808e_wdt.c |   44 ++++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 44 insertions(+), 0 deletions(-)
>=20
>=20
> diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wd=
t.c
> index 7e5c266..546cef6 100644
> --- a/drivers/watchdog/f71808e_wdt.c
> +++ b/drivers/watchdog/f71808e_wdt.c
> @@ -282,6 +295,28 @@ exit_unlock:
>  	return err;
>  }
> =20
> +static int f71862fg_pin_configure(unsigned short ioaddr)
> +{
> +	/* When ioaddr is non-zero the calling function has to take care of
> +	   mutex handling and superio preparation! */
> +

Given that this basically documents how the function should be used
(i.e. API documentation) you might want to put the comment block
*before* the function's prototype.  You could use kernel-doc for it if
you wish (Documentation/kernel-doc-nano-HOWTO.txt).

This is just advice though, so:

Signed-off-by: Giel van Schijndel <me@mortis.eu>

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"There are two major products that come out of Berkeley: LSD and UNIX.
 We don't believe this to be a coincidence."
  -- Jeremy S. Anderson

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyfYQsACgkQZBYm/87l50JjtACgke2jhnOyUcNTgg2y/rEFAoEC
oMYAoMYqUB7u7NSZj7EpzED+IwbVP1hu
=l7mI
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
