Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2HFImV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 04:42:21 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:56116 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792Ab2HFImS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 04:42:18 -0400
Date: Mon, 6 Aug 2012 11:38:45 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 1/4] arm/dts: omap5-evm: Add I2C support
Message-ID: <20120806083843.GA17612@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1343997486-710-1-git-send-email-sourav.poddar@ti.com>
 <1343997486-710-2-git-send-email-sourav.poddar@ti.com>
 <501C08CB.3060701@mvista.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <501C08CB.3060701@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 03, 2012 at 09:22:19PM +0400, Sergei Shtylyov wrote:
> Hello.
>=20
> On 08/03/2012 04:38 PM, Sourav Poddar wrote:
>=20
> > Add I2C data node in omap5 device tree file.
>=20
> > Tested on omap5430 sdp.
>=20
> > Cc: Benoit Cousson <b-cousson@ti.com>
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > Acked-by: Felipe Balbi <balbi@ti.com>
> > Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> > ---
> >  arch/arm/boot/dts/omap5.dtsi |   35 +++++++++++++++++++++++++++++++++++
> >  1 files changed, 35 insertions(+), 0 deletions(-)
>=20
> > diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> > index 57e5270..6b68dfe 100644
> > --- a/arch/arm/boot/dts/omap5.dtsi
> > +++ b/arch/arm/boot/dts/omap5.dtsi
> > @@ -145,6 +145,41 @@
> >  			#interrupt-cells =3D <1>;
> >  		};
> > =20
> > +		i2c1: i2c@48070000 {
> > +			compatible =3D "ti,omap4-i2c";
> > +			#address-cells =3D <1>;
> > +			#size-cells =3D <0>;
> > +			ti,hwmods =3D "i2c1";
>=20
>    Address postfix in the node name and no "reg" property?

that's because of the ti,hwmods attribute. OMAP is still not entirely
converted to DT and there's this weird ti,hwmods attribute. OMAP's hwmod
framework will fill up register addresses, irqs, etc when the device is
created. Oh well...

--=20
balbi

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQH4KTAAoJEIaOsuA1yqREyVoQAKKkTcGy302m5Gam9wnCP0Cb
HXqBoaioUwfiXyV0sM4soLy4P1Q0yULDNzttzsYOhPMSSQx5ewbyh6sa1MJK8qvk
bILOFDE3z6cYdjZQATlo7QcvxpcjSBaD0RxlEsdZBTtNPWN2dIrLmbl1iQy/UVkx
oS4d5aKLj9LQLWjcG2d4FpbLu+oeLMIIF67tY4vr1JXscWoIX3XPZ/98CwmtTUXE
yAL2hkCrX3jFc0FgR7oCNwdfkZ8BPpp3wbN7Mec6dI0cFcmoVU7XdT6tqXnaqtju
p3I6CdDh9cBdMwte5zNFM6OB9Jhr97Xjsu7eQSmcO6O+R/6LtHRliRab52ZIw4ib
h5kfSEEweWA4ypVqpF4z5p9tydkgtNoojdfErLyiPAW1mem7cgQ9ftRHShjBqJko
hlKZH8doQe0ibLRsIXtdP3qugImbk96Fms7U/B0WZ6Ubo9CLWiJL+9/8517qmuYB
50fdoLFMucafW49zoYzpjsGmCGrAMIRHPrXDCr4Z32Us5haOFpDFkR1vdDMHPpqU
ymaFJhwNBOYzi7j3Gf9IH1FFadYOXxzRk/z7RRZ2GGEknut7bV0RoIDZtiXapZT8
Xd5qdyxhs9sNV0DD7ihzriy7RFYYzNTD4zy12oGkdhNk334pFLI3xg4Xtk9hhQxQ
HEWtrI6XeWWKmZ0Jrkp3
=h60n
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
