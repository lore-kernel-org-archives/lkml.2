Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2HCNbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:31:12 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:49668 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238Ab2HCNbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:31:10 -0400
Date: Fri, 3 Aug 2012 16:27:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v6 02/11] arm/dts: omap: Add omap-usb2 dt data
Message-ID: <20120803132737.GD8269@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
 <1343639400-28725-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SFyWQ0h3ruR435lw"
Content-Disposition: inline
In-Reply-To: <1343639400-28725-3-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SFyWQ0h3ruR435lw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 30, 2012 at 02:39:51PM +0530, Kishon Vijay Abraham I wrote:
> Add omap-usb2 data node in omap4 device tree file.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

looks good:

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/omap4.dtsi |    5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index 29c6243..15f1890 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -279,6 +279,11 @@
>  			#size-cells =3D <1>;
>  			ranges;
>  			ti,hwmods =3D "ocp2scp_usb_phy";
> +			usb2phy@4a0ad080 {
> +				compatible =3D "ti,omap-usb2";
> +				reg =3D <0x4a0ad080 0x58>,
> +				      <0x4a002300 0x1>;
> +			};
>  		};
>  	};
>  };
> --=20
> 1.7.9.5
>=20

--=20
balbi

--SFyWQ0h3ruR435lw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQG9HJAAoJEIaOsuA1yqRESGkP/REMA5WtMDzVYW6C1ClDk5vo
1b/CJUghZPEHdWbpNwGHUNEK02OPg50pjSKIDuMKyNXn6pBWR8dPjCY/2dKeOE8G
XTTYfMsB6xdsZvjioiWA4WyA5qJtXSagqXeDC5FEHsNWrDEUivx3ufybXJ+YY9Jc
K9Za4I6LmLjoVpohXM9qsiPLITIoC7VvQpErmErc2mlROdToxIMok5w9XMi6B+Kq
OkFzaDGoVl9vsmn0CRt3P14RrBnvWb/ptX0Sm/6ZFjLk/fVYBranExAT+LT+FEIn
UV5F509hkOAH1aTi6iaHESWugp4uPixjtnDhfjmpjm3GX2Dt88HjexmetnLhqUSd
b+1EqJiShs/n3aQNGZR2xzKREvRI11NRfiFgA/y6oI/mw5fdZEirItC3GpJedXnZ
sapQ5w1MzfOpcWMYb+u24wXP6EhFJMzHpu3C4Oj/0xZyKDcI3m4Ds9hIyGXRc7Ko
7jXmF60nN6PS/OnJhYK9v7LyrQHTQ5xkI+FeuJ+xjF7oODi0MnD0y9KNEFoUSRW1
IQ+6ItxWaHgJzfDwdUuUrQzKyi9Tp99m8Rp5rk0OIvA97hoAuhhNDLWo4IV8zpKb
uskrp6KsuLI0Q2nURpLEq1QAVsjNWGVj9CvNyZUbGJS5jAdmgL84axNmOfl1UhCc
YlNxUAXB1RMQhZbdgEZy
=YYxz
-----END PGP SIGNATURE-----

--SFyWQ0h3ruR435lw--
