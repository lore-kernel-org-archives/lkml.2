Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab1FGKd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:33:56 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:52512 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906Ab1FGKdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:33:54 -0400
Date: Tue, 7 Jun 2011 13:33:49 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, balbi@ti.com,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110607103346.GU12242@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <Pine.LNX.4.44L0.1105251010580.1987-100000@iolanthe.rowland.org>
 <Pine.LNX.4.44L0.1105251033550.1987-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cqG5pBpskktEuCrX"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1105251033550.1987-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cqG5pBpskktEuCrX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 25, 2011 at 10:39:24AM -0400, Alan Stern wrote:
> This patch (as1468) changes the Kconfig definition for
> USB_GADGET_DUALSPEED.  This option is determined entirely by which
> device controller drivers are to be built, through Select statements;
> it does not need to be (and should not be) configurable by the user.
>=20
> Also, the "default n" line is superfluous -- everything defaults to N.
>=20
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

this patch makes a lot of sense. FWIW:

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>=20
>  drivers/usb/gadget/Kconfig |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>=20
> Index: usb-2.6/drivers/usb/gadget/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb-2.6.orig/drivers/usb/gadget/Kconfig
> +++ usb-2.6/drivers/usb/gadget/Kconfig
> @@ -597,13 +597,10 @@ config USB_DUMMY_HCD
> =20
>  endchoice
> =20
> +# Selected by UDC drivers that support high-speed operation.
>  config USB_GADGET_DUALSPEED
>  	bool
>  	depends on USB_GADGET
> -	default n
> -	help
> -	  Means that gadget drivers should include extra descriptors
> -	  and code to handle dual-speed controllers.
> =20
>  #
>  # USB Gadget Drivers
>=20

--=20
balbi

--cqG5pBpskktEuCrX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7f6KAAoJEAv8Txj19kN1fpsIAIxi8B8BgZlH7u08PBcywmPr
ZSeaLRM5N7IfiG7n3+wkbXo84Ryu42GQqAa5m7KyswnEEs1UlfT22PfnMgva0H0n
SB+y4rxyFLYy7BZcmRIuAeww9Cn8dcXQ5xOnAwwfSgu4oANudzHoa3MJ10o5QROt
i209nrOO6TGS8SNAqomRCOhdsb/SN4fOe9oeM7L7qluUzSTFYv/Iprp3b5OlLxxI
hxLl7Pg3DCryxaeHpcu28JpkezhIzb1waSNHgOOI6isTtqvQ/uScDXYcjQJfsB5h
Wv+mni0g5h/58NM9+dSlATReaNjJ7snO/tXiTgi7O0HiOx6M/BMLJYMXSH5VAwg=
=z8Gs
-----END PGP SIGNATURE-----

--cqG5pBpskktEuCrX--
