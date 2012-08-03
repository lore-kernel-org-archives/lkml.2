Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2HCNgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:36:25 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:46401 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405Ab2HCNgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:36:22 -0400
Date: Fri, 3 Aug 2012 16:32:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v6 08/11] arm/dts: Add twl4030-usb data
Message-ID: <20120803133253.GJ8269@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
 <1343639400-28725-9-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9pltayyoy9lWEMH"
Content-Disposition: inline
In-Reply-To: <1343639400-28725-9-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9pltayyoy9lWEMH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 30, 2012 at 02:39:57PM +0530, Kishon Vijay Abraham I wrote:
> Add twl4030-usb data node in twl4030 device tree file.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/twl4030.dtsi |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/twl4030.dtsi b/arch/arm/boot/dts/twl4030.d=
tsi
> index 22f4d13..761a5a5 100644
> --- a/arch/arm/boot/dts/twl4030.dtsi
> +++ b/arch/arm/boot/dts/twl4030.dtsi
> @@ -37,6 +37,18 @@
>  		regulator-max-microvolt =3D <3150000>;
>  	};
> =20
> +	vusb1v5: regulator-vusb1v5 {
> +		compatible =3D "ti,twl4030-vusb1v5";
> +	};
> +
> +	vusb1v8: regulator-vusb1v8 {
> +		compatible =3D "ti,twl4030-vusb1v8";
> +	};
> +
> +	vusb3v1: regulator-vusb3v1 {
> +		compatible =3D "ti,twl4030-vusb3v1";
> +	};
> +
>  	twl_gpio: gpio {
>  		compatible =3D "ti,twl4030-gpio";
>  		gpio-controller;
> @@ -44,4 +56,13 @@
>  		interrupt-controller;
>  		#interrupt-cells =3D <1>;
>  	};
> +
> +	twl4030-usb {
> +		compatible =3D "ti,twl4030-usb";
> +		interrupts =3D < 10 4 >;
> +		usb1v5-supply =3D <&vusb1v5>;
> +		usb1v8-supply =3D <&vusb1v8>;
> +		usb3v1-supply =3D <&vusb3v1>;
> +		usb_mode =3D <1>;
> +	};
>  };
> --=20
> 1.7.9.5
>=20

--=20
balbi

--M9pltayyoy9lWEMH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQG9MFAAoJEIaOsuA1yqRErHsQAImatsn6AM6f2p0VTKg6Zbxe
CJED20SfbCYKdzk4j7kAtEJ5sUvd35Y54bt7QNQ+GfPCWma6+W/j09hiSXsCP7eH
9Ejh4KHStQgTFnc94g8d33M7XMFJ72YU2svBc/ZyCwrl6LBNrPyuPd0DD66lFGRm
vqsbKZdveCn0q7if/gRdgJwcYmEIuN9YkpgGF2DCMR8mU6VoRYiKah1TfzzWXhxd
egQvhuEaBLF0/ZrpQ7ZvLskxGDbvcHhOXkqUFblFE8Pek8CtgfomuOBtI83zZLPu
OAPhzxNiaNfnxHviXrOj0lPZWJoibQbuaQfmMeu4e+QA4jQuUl3n6nuyY7oRQjsg
WG2ndWsFSIchR055+am8sHe/JA+UbgkboFiDXi+sYZ5w7Z4ZCE8c4QppRAJTuEcS
BMQe0BQZMEL6gPI6QyiZT2h6Tdm0psBa1NSWHJyddxSLQiThRxh8N30P3Zh0k7cI
KvNp3aiWfYMptnjwrf+p3uBnjRrLO5OB4FYO06PUiotjKhguhDPxTI1D/fdZXKDt
0h290/jImMGnAAaGIsfNbvxjfgCjezHl3Gfd3DyuFdUrNZ4/PGa07nQs+Y071cPV
envmiJ08qaPhVGpFK0fDLrWdSNQS+K96ayQLfqWYyJGB2oyysV8P9WZuN+mVDojq
TGVh0Wy6akKljlYeO/3z
=zR5X
-----END PGP SIGNATURE-----

--M9pltayyoy9lWEMH--
