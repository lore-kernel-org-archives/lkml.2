Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab2HCNfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:35:17 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:56653 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224Ab2HCNfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:35:12 -0400
Date: Fri, 3 Aug 2012 16:31:43 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v6 06/11] arm/dts: Add twl6030-usb data
Message-ID: <20120803133142.GH8269@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
 <1343639400-28725-7-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HuscSE0D68UGttcd"
Content-Disposition: inline
In-Reply-To: <1343639400-28725-7-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HuscSE0D68UGttcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 30, 2012 at 02:39:55PM +0530, Kishon Vijay Abraham I wrote:
> Add twl6030-usb data node in twl6030 device tree file
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/omap4-panda.dts |    4 ++++
>  arch/arm/boot/dts/omap4-sdp.dts   |    4 ++++
>  arch/arm/boot/dts/twl6030.dtsi    |    5 +++++
>  3 files changed, 13 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-=
panda.dts
> index 1efe0c5..7052422 100644
> --- a/arch/arm/boot/dts/omap4-panda.dts
> +++ b/arch/arm/boot/dts/omap4-panda.dts
> @@ -89,3 +89,7 @@
>  	ti,non-removable;
>  	bus-width =3D <4>;
>  };
> +
> +&twlusb {
> +	usb-supply =3D <&vusb>;
> +};
> diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sd=
p.dts
> index d08c4d1..6326d7c 100644
> --- a/arch/arm/boot/dts/omap4-sdp.dts
> +++ b/arch/arm/boot/dts/omap4-sdp.dts
> @@ -158,3 +158,7 @@
>  	bus-width =3D <4>;
>  	ti,non-removable;
>  };
> +
> +&twlusb {
> +	usb-supply =3D <&vusb>;
> +};
> diff --git a/arch/arm/boot/dts/twl6030.dtsi b/arch/arm/boot/dts/twl6030.d=
tsi
> index 3b2f351..8e3aac9 100644
> --- a/arch/arm/boot/dts/twl6030.dtsi
> +++ b/arch/arm/boot/dts/twl6030.dtsi
> @@ -83,4 +83,9 @@
>  	clk32kg: regulator@12 {
>  		compatible =3D "ti,twl6030-clk32kg";
>  	};
> +
> +	twlusb: twl6030-usb {
> +		compatible =3D "ti,twl6030-usb";
> +		interrupts =3D < 4 10 >;
> +	};
>  };
> --=20
> 1.7.9.5
>=20

--=20
balbi

--HuscSE0D68UGttcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQG9K+AAoJEIaOsuA1yqREklYP/ApfQoBYdu1of+sPdqkvrGUe
DqhOIPCoBMKXsuLIkbEP5t+srZxGQl5al0LRvgmBy0aUBH+slpqdYfzOy0+Ypnip
Le3xZlJW3k7XZ0SulhHw0c1I6fF57+qUF8OhoPJJEP78B7jf/k9amuEAgusLqGqS
SXnvLK0mXPx5E6uZJALtux/tC5Q2jB/UwWqTT1/M4jzexsLYn9leoB9pbUATXEHG
uJ2qv+Sox5dkDgo6lsBNQYwW1zEG/Y/EpHku+JeLwUJXqqLsvRIScApLcUNGeZx6
RlMUiUXWDLtos1kpVklhrnMWENNB5BjRWcSq42xOSiJ6mW+T7WFJIowWNb7Uvwgu
jtHPuKOuFwaOPjh3TWaavFn/xae8xPafLYeMn2nkDeIbUY8X2hI137lzXgmga+TI
kYC8qO4SbUz/p6P5OoMi0gZ6maie6APYqMUvHiXYV0apcmrnS0o54scB6VxfmgqN
OVvh1mQQ2SzVu2Gfit3SgRrOdQn8Lp37JIaq7gUjSIU51u9nIJU9t7Hl2VWaGmJT
99Baax2dzMaaI0uHB2GVi74mpD0j5IzcNxRyoH+yfnepneqXm80e5xCBwu6uh9mH
kv2PtYgQRikYEVBHtlX4P1RowJt6H0IM/s5hR8OfKa4tZcBm22V91Zl77TWslt3e
r7oXeiI+OzcXCiBa6fGy
=jPEB
-----END PGP SIGNATURE-----

--HuscSE0D68UGttcd--
