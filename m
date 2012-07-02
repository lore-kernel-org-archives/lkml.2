Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab2GBH1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 03:27:21 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:44459 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754147Ab2GBH1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 03:27:19 -0400
Date: Mon, 2 Jul 2012 10:24:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Roland Stigge <stigge@antcom.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy: Fix Kconfig dependency for Phy drivers
Message-ID: <20120702072445.GD16670@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1340722608-997-1-git-send-email-aletes.xgr@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZARJHfwaSJQLOEUz"
Content-Disposition: inline
In-Reply-To: <1340722608-997-1-git-send-email-aletes.xgr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZARJHfwaSJQLOEUz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 26, 2012 at 11:56:48AM -0300, Alexandre Pereira da Silva wrote:
> USB phy layer driver are only built if usb host is selected, but they
> are used too by USB_GADGET drivers
>=20
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> ---
>  drivers/usb/Makefile    |    2 +-
>  drivers/usb/phy/Kconfig |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
> index c691eea..f5ed3d7 100644
> --- a/drivers/usb/Makefile
> +++ b/drivers/usb/Makefile
> @@ -46,7 +46,7 @@ obj-$(CONFIG_USB_MICROTEK)	+=3D image/
>  obj-$(CONFIG_USB_SERIAL)	+=3D serial/
> =20
>  obj-$(CONFIG_USB)		+=3D misc/
> -obj-$(CONFIG_USB)		+=3D phy/
> +obj-$(CONFIG_USB_COMMON)	+=3D phy/

I'm not sure this is the best solution. Should we introduce
CONFIG_USB_PHY for this ?

--=20
balbi

--ZARJHfwaSJQLOEUz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8Uy9AAoJEIaOsuA1yqREKNQP/1yyg3rjckBj5qkbfYM3MGOI
AHppaqsXaJ/s5oDVrZlPsn+0B1If5OC6ofr2H3pOP/DgY6wEHlnIkH+LSZVkYY27
/cWtADBttvLKkFu+Roj9OwdoWCVSqZtBLiFE/NQ+Afel612pmvruzqNj2UyvjKMx
J/hx3U2/iC9QqhFdFeheAke6LZg59sM8+zEX6cOAB0B7HgzfV0RiddOwxjz3Hlrx
VYRRLzg6K9qaS/GysZgTd0t8hDVcEW0tpMCWPWXDI1hKlrU1BwbP7a2DUZcL5+6H
uE0yf8FxAFcbMPPlWRlG6+WjboQ/EEvduIAZHADOowLTWTtxnrxbr6evT8jqaZBh
J5JjuU4d96FXlg/pBbwW+BPz1YH3y/Z5M7SD/PEdzEX9H3JdTbQ2h7v2zs5FSonK
R9aoJ359HdiQpTMjvo7yZwvMx9T7v13cdKYRcw2DZOJcnT8emZRjAnfskN/ZxTtt
dSYAGCsg8Sm58f3joLpJ0RkcOGJ3mcXviO/yyHXBDgfOezJRCiY6M0Z/opd2gDaG
7KGe1z4l0YxqKumqJAufmHLdOIWDbbJA2VVGTv7R/D3EyxHhDigyP6KmfNEypdhW
7S2BgAsCZaS3pfCmqYNYqF+4e2h8PPDPGEKLFlIyGdIgLPuEzGOtKQDeKBw2iEqj
FS990O7Tik3q123EqErC
=bHgZ
-----END PGP SIGNATURE-----

--ZARJHfwaSJQLOEUz--
