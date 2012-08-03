Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab2HCNZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:25:17 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:47453 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752328Ab2HCNZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:25:13 -0400
Date: Fri, 3 Aug 2012 16:21:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, b-cousson@ti.com, rnayak@ti.com,
        tony@atomide.com, gregkh@linuxfoundation.org, ohad@wizery.com,
        linus.walleij@linaro.org, myungjoo.ham@samsung.com,
        rusty@rustcorp.com.au, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 2/2] arm/dts: omap4: Add ocp2scp data
Message-ID: <20120803132137.GB8269@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1342593039-7728-1-git-send-email-kishon@ti.com>
 <1342593039-7728-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <1342593039-7728-3-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 18, 2012 at 12:00:39PM +0530, Kishon Vijay Abraham I wrote:
> Add ocp2scp data node in omap4 device tree file.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/omap4.dtsi |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index 359c497..29c6243 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -272,5 +272,13 @@
>  			ti,hwmods =3D "mmc5";
>  			ti,needs-special-reset;
>  		};
> +
> +		ocp2scp {
> +			compatible =3D "ti,omap-ocp2scp";
> +			#address-cells =3D <1>;
> +			#size-cells =3D <1>;
> +			ranges;
> +			ti,hwmods =3D "ocp2scp_usb_phy";
> +		};
>  	};
>  };
> --=20
> 1.7.5.4
>=20

--=20
balbi

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQG9BhAAoJEIaOsuA1yqRE6OAP/Az2xWFnZj1Tx8Rq5/kc8nTR
p4f1+BNqD4C/Lol4N/zzoKoUG4307iVYU9uJQWn7pgNSuSDYiBLDspVAns3WhC4l
k6jvILgu22AbDxCgnT3c7nbfuuFtzjcBmSFWtwMBtH0jMC44rC4sSR+zlAhK9FVp
7KGhqYZGgbTyjyL5829XLeH07vPdDGQ6lDIvHHZcadnEs4UTdUghNaRed7G8b/IF
g/CZ3phrOdo33NObHB3OuAoI4axmdTE1sd+1ku4qccLhI33kPWBQc1isweobFnZY
d90TbIddeHtuCy+k9zOrNbAY9eF4toOVuMHZZZ7pOR8hGacmwBAtN/NFpR84hEIU
MatYwntIRUW3EZumO2yON/1V47gwrINKGByE7KM14rYGz0BTPdDg1zS2x0Cixvng
bNTGytLmqI4X9jjQUNA5KMnDSV8nMQEx5TAj8KevkexHulrp2dsXrYK1mB08/IOW
+EnrVi5cNG+rLgdBPfTbEHkx7Z/VZvhK0e8+tQuhA1V8Hkk1CLMq5ZPPiXc3zSEL
Pqf+YUl/q+cgtCaUcuF379utymG2ssIxzwz3aUqG1sEzq7kYpejZg2YwQMwisf0p
+OcOSWi0gfJgZs5ClqpTwYr0UGA4jNoIopHx3+npAlU1zLYw9gdTyg5/a5iUxtFO
CyR79lFqHcLoKWCHC5Qz
=QNpb
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
