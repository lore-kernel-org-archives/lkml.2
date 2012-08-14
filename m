Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab2HNKDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:03:14 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:34968 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435Ab2HNKDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:03:13 -0400
Date: Tue, 14 Aug 2012 12:59:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCHv2 2/4] arm/dts: omap5-evm: Add tmp102 sensor support
Message-ID: <20120814095923.GB11416@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1344852313-30484-1-git-send-email-sourav.poddar@ti.com>
 <1344852313-30484-3-git-send-email-sourav.poddar@ti.com>
 <502A20DD.5030707@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aVD9QWMuhilNxW9f"
Content-Disposition: inline
In-Reply-To: <502A20DD.5030707@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 14, 2012 at 11:56:45AM +0200, Benoit Cousson wrote:
> On 08/13/2012 12:05 PM, Sourav Poddar wrote:
> > Add tmp102 temperature sensor data in omap5 evm dts file.
> >=20
> > Tested on omap5430 evm with 3.5 custom kernel.
> >=20
> > Cc: Benoit Cousson <b-cousson@ti.com>
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > Acked-by: Felipe Balbi <balbi@ti.com>
> > Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> > ---
> >  arch/arm/boot/dts/omap5-evm.dts |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/arch/arm/boot/dts/omap5-evm.dts b/arch/arm/boot/dts/omap5-=
evm.dts
> > index 200c39a..45a8aeb 100644
> > --- a/arch/arm/boot/dts/omap5-evm.dts
> > +++ b/arch/arm/boot/dts/omap5-evm.dts
> > @@ -18,3 +18,12 @@
> >  		reg =3D <0x80000000 0x40000000>; /* 1 GB */
> >  	};
> >  };
> > +
> > +&i2c4 {
> > +	clock-frequency =3D <400000>;
>=20
> Have you checked if we cannot run at faster speed? Reducing the speed
> will impact every devices on the bus.
> It might be needed, I just wanted to be sure.
>=20
> You should maybe just add a small comment to explain what the device is
> doing with potentially a link to the HW spec if available.
>=20
> The same comments are applicable to the bmp085 patch.

that sort of information should be placed on
Documentation/devicetree/bindings/*/$device.txt, right ? Why should we
replicate it on all dts files ? Besides, there are only two such entries
on all ARM DTS files. Do we really want to make dts files bigger with
links to documentation which can even be moved at any time to other
location by the manufacturer's choice ? Will anyone actually keep track
of such links to make sure they aren't broken ? And even if someone does
track those links, do we really want to keep sending such patches for
the dts files ?

--=20
balbi

--aVD9QWMuhilNxW9f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQKiF7AAoJEIaOsuA1yqREh28P/0xhK3vmuH4f8+glpT+QJGQU
cA/y3F/BS2655o3kyEUpSVeylvhY237alABksiDUSoddGuxGdfoHTwmTGTUp4UZf
2cr0kz83eRvGQBnMqU0PbujI6c6UZqde23Bv1QhsMy4jD3jlJSjWgaSLbh8BHzx8
6W1jK+yAXeauVK9+d88Cpv8/pzoYjCNeVKRYb3LEpWFf51iDsg1Pu2+C0RSU14Hi
gvUfNn3TqgleABQ5MX5HSemFn6icMoefUyy9nUHm+arPUcBsuvSmVLJr3xG6Iqbc
5dAiSI0BztQLRh+kEcMNBmvybzZINtcCRBbo1TtKAkwIrQcxwhNY7A2Es3mnPej+
fS/h/dqBIKpfrRBg9QV8P5f3w6E8OgpYMXYmgYm0BUNteNa4ENAlNAOK9uL+fN3B
VwIqARNanC/q0lmHS52kTrpJ4kVxR4glYl7v6o/jK/xI2ralx4kw7QEkJB2/bJ14
sYaNyQk1qDpsHZg7BACDD1uw7rw4lZNGUFEgvSChTDlED1pSTLRHQjv84CvDGxM7
xcXW6GWngbJhXKwP8/+o0jDsFKZNsn2b1pXFL1m76mvKj1GvUDHB0t04r5uW4HjE
yPvm1asb/thS3ufcCeEnRfzKhiAQgfGgaEhX3zBzSYJoWX7ut7cEsAM4SznumFkc
gvQd3WeaSUsfJG2wzsEa
=1ORa
-----END PGP SIGNATURE-----

--aVD9QWMuhilNxW9f--
