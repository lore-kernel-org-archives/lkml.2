Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab2HCNiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:38:50 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:49873 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753779Ab2HCNis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:38:48 -0400
Date: Fri, 3 Aug 2012 16:35:16 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v6 10/11] arm/dts: omap: Add usb_otg and glue data
Message-ID: <20120803133514.GL8269@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
 <1343639400-28725-11-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I4VOKWutKNZEOIPu"
Content-Disposition: inline
In-Reply-To: <1343639400-28725-11-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I4VOKWutKNZEOIPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 30, 2012 at 02:39:59PM +0530, Kishon Vijay Abraham I wrote:
> Add usb otg data node in omap4/omap3 device tree file. Also update
> the node with board specific setting in omapx-<board>.dts file.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/omap3-beagle.dts |    6 ++++++
>  arch/arm/boot/dts/omap3-evm.dts    |    6 ++++++
>  arch/arm/boot/dts/omap3.dtsi       |    8 ++++++++
>  arch/arm/boot/dts/omap4-panda.dts  |    6 ++++++
>  arch/arm/boot/dts/omap4-sdp.dts    |    6 ++++++
>  arch/arm/boot/dts/omap4.dtsi       |    8 ++++++++
>  6 files changed, 40 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3=
-beagle.dts
> index 5b4506c..f3d7076 100644
> --- a/arch/arm/boot/dts/omap3-beagle.dts
> +++ b/arch/arm/boot/dts/omap3-beagle.dts
> @@ -67,3 +67,9 @@
>  &mmc3 {
>  	status =3D "disable";
>  };
> +
> +&usb_otg_hs {
> +	interface_type =3D <0>;
> +	mode =3D <3>;
> +	power =3D <50>;
> +};
> diff --git a/arch/arm/boot/dts/omap3-evm.dts b/arch/arm/boot/dts/omap3-ev=
m.dts
> index 2eee16e..8963b3d 100644
> --- a/arch/arm/boot/dts/omap3-evm.dts
> +++ b/arch/arm/boot/dts/omap3-evm.dts
> @@ -18,3 +18,9 @@
>  		reg =3D <0x80000000 0x10000000>; /* 256 MB */
>  	};
>  };
> +
> +&usb_otg_hs {
> +	interface_type =3D <0>;
> +	mode =3D <3>;
> +	power =3D <50>;
> +};
> diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
> index 99474fa..4b8c142 100644
> --- a/arch/arm/boot/dts/omap3.dtsi
> +++ b/arch/arm/boot/dts/omap3.dtsi
> @@ -215,5 +215,13 @@
>  			compatible =3D "ti,omap3-hsmmc";
>  			ti,hwmods =3D "mmc3";
>  		};
> +
> +		usb_otg_hs: usb_otg_hs {
> +			compatible =3D "ti,omap3-musb";
> +			ti,hwmods =3D "usb_otg_hs";
> +			multipoint =3D <1>;
> +			num_eps =3D <16>;
> +			ram_bits =3D <12>;
> +		};
>  	};
>  };
> diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-=
panda.dts
> index 7052422..dd19370 100644
> --- a/arch/arm/boot/dts/omap4-panda.dts
> +++ b/arch/arm/boot/dts/omap4-panda.dts
> @@ -93,3 +93,9 @@
>  &twlusb {
>  	usb-supply =3D <&vusb>;
>  };
> +
> +&usb_otg_hs {
> +	interface_type =3D <1>;
> +	mode =3D <3>;
> +	power =3D <50>;
> +};
> diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sd=
p.dts
> index 6326d7c..0fc10d4 100644
> --- a/arch/arm/boot/dts/omap4-sdp.dts
> +++ b/arch/arm/boot/dts/omap4-sdp.dts
> @@ -162,3 +162,9 @@
>  &twlusb {
>  	usb-supply =3D <&vusb>;
>  };
> +
> +&usb_otg_hs {
> +	interface_type =3D <1>;
> +	mode =3D <3>;
> +	power =3D <50>;
> +};
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index 15f1890..7886518 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -285,5 +285,13 @@
>  				      <0x4a002300 0x1>;
>  			};
>  		};
> +
> +		usb_otg_hs: usb_otg_hs {
> +			compatible =3D "ti,omap4-musb";
> +			ti,hwmods =3D "usb_otg_hs";
> +			multipoint =3D <1>;
> +			num_eps =3D <16>;
> +			ram_bits =3D <12>;
> +		};
>  	};
>  };
> --=20
> 1.7.9.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
balbi

--I4VOKWutKNZEOIPu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQG9OSAAoJEIaOsuA1yqREYC4P/1FwOeggbhQbv5FTavoxr6BH
EPgFUfnGfWDYgigcdpre+ngLcqYeVMvMxmKZ5YJUMrc8gRz6JnHDJE6WH2Fivugd
6j4LGf8htgGXAdSg8mhqPpW6WHg/IBq4PPgluVPdRCW7ocTivdv7JyTtREtaKByL
POHiwV6xqDXN+yHCSJeN+V4E81NtD33nW3DI5MdQXKkxyvWvkVrYRCfKwEydP/Gp
aZIL9UlBJoU+jNUjj4ZcgosMgTlo4Gz7to4XO2JQcU33RKceAvCYop6G6xp1szDb
guTjE3StVLpeSPK53gb2TVQmVER6kXqoGx1P/g0jVK6UqH3zsGzCWDJser4BauAa
39jvGflqZ4tvrNqaWwMgj0TGfMNoWAAMfL3R6BLH/33B7eG7CeqRQ0xaygLK3RIp
ypqrp4cxvt9ksgGYLkmurQDGItLjaAQJcztB75N5Elz3TZXj9tkXUXxkHZbhcqnJ
44mstPyTCSrd4qF0v3tbvMiXUaqOQXw/eOLhGa2NFGD/Ipk/bbBnLZszX4XpdAyS
Aq7eWjG7afnjASMjJgGvNzYPm/Jj9SRbRencI8x/1P4dN5o3I+JriRGj/keabtLn
8mvhVvpyVMQN9ASzXRZ4PmwibpRxSOOsZVtInCTzdbrtlYzYT9PufECqjvyjJyt3
bVjqYLX+egnP4z6Z9FtF
=EMR0
-----END PGP SIGNATURE-----

--I4VOKWutKNZEOIPu--
