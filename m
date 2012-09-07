Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523Ab2IGNa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:30:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51184 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab2IGNaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:30:55 -0400
Date: Fri, 7 Sep 2012 15:29:55 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>,
        linux-kernel@vger.kernel.org,
        =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>
Subject: Re: [PATCH 8/9] ARM i.MX53: Add pwms to dtsi
Message-ID: <20120907132955.GH29340@avionic-0098.mockup.avionic-design.de>
References: <1346154504-5623-1-git-send-email-s.hauer@pengutronix.de>
 <1346154504-5623-9-git-send-email-s.hauer@pengutronix.de>
 <20120830223219.GF3613@r65073-Latitude-D630>
 <20120831130723.GS26594@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MP5ln1Rcf9Bvi+ZW"
Content-Disposition: inline
In-Reply-To: <20120831130723.GS26594@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:T73jZF4tbL8LSKOED85qXPY03LUq6j0K0HpOXDv6qcG
 2qvMlsqaiuauBQe0smyGia+AzumymP8hEh3e72fsqvNCVdFEA4
 536Art68HXw4q6yGuGLaweF9/Eukc/7OWZU+7+ja+BLxWuz00s
 1YKAcQ/hhvJ/zSn7jLlbS5JNzhSZNy0G2r2gLvXbJPqdy7z9gC
 bJozo/J2Ri4CZ4jbZFo0/k4wrDfxDhoJBPydCpaGSzXOxn6UKl
 phjhLb/84z2vF5/MuH+KCS3Gb9iUHiAHEugd5pMGM2ieBT2Mey
 T1XQpoXfl50hjibG7DxhPHEfy8+7gJxJPFGGKi2e7adEFB1CIX
 wzb6N4OUCTLHpu35eHv6C61lLBACP1sDtp3CKGDyN2YTM16NFM
 tnCTXbuXnS+KcbsRJqlxIxMjh81WQgp1kyxu0QbgZj5DjtUhsE
 OvH/P
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MP5ln1Rcf9Bvi+ZW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 31, 2012 at 03:07:23PM +0200, Sascha Hauer wrote:
> On Fri, Aug 31, 2012 at 06:32:20AM +0800, Shawn Guo wrote:
> > On Tue, Aug 28, 2012 at 01:48:23PM +0200, Sascha Hauer wrote:
[...]
> > >  arch/arm/boot/dts/imx53.dtsi        |   14 ++++++++++++++
> > >  arch/arm/mach-imx/clk-imx51-imx53.c |    4 ++++
> > >  2 files changed, 18 insertions(+)
> > >=20
> > > diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.d=
tsi
> > > index cd37165..7ec17e4 100644
> > > --- a/arch/arm/boot/dts/imx53.dtsi
> > > +++ b/arch/arm/boot/dts/imx53.dtsi
> > > @@ -189,6 +189,20 @@
> > >  				status =3D "disabled";
> > >  			};
> > > =20
> > > +			pwm1: pwm@53fb4000 {
> > > +				#pwm-cells =3D <3>;
> >=20
> > pwm-cells should be 2?
>=20
> Yes, right. We have a patch internally that allows us to pass a
> 'inverted' flag to the pwm, hence I accidently have 3 here.

There are patches in for-next that add support for setting the PWM
polarity, though there's currently no support for specifying it via a
third cell in the specifier. Would you mind sharing the patches that add
this?

Thierry

--MP5ln1Rcf9Bvi+ZW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQSfbTAAoJEN0jrNd/PrOhHuAQAJ05vTJoTBnRyhVjlMO9wZxa
vM0/68+w/Wf2jF4PQCt/fbspIC3EkfEbG/9cBH5EWpuOFcbyugRsLXmA15aekdIl
m3VgQMMgy+TGoxWTGInv2/dxAGNRCGDPKXKvM2eJKdTBoLOJudORVkvB5nyxOVex
yV9hMH3cf5u6qjZnUdJvRH2kP2nuSGVpdoJq4y/UcAQRMHuKWTULshfNszSZE37E
zUye+mZ5NYfLZ0bLGvhGB6N+3JJv/2GnVlwA8H9tkefFNh7FQMk0ifFAAUIegvRx
A2nYu9Bp520AXItDx+ed2mSSnNl5UmE3EWwtEBSP4UMBYNuHnrjZKa6OmfwdE5cN
6kjK3c+eEuZSSczgFmkX41oov4+rUTcgrW1r1r8FzZ/aOFTnBk03jlxit3Q1WwnS
ToAYfzwLJAXYLj8/4HyE5mBY8SmdRzewfsackbj7Zz6Ax4FLGblnnaZ2eukoRO4u
mh1BiHnyj7MBp6P2t+Z4nfjeSXRsXZ69jh/liee14XXhl+tSGmgy1tZUGt/XRJix
c09DANx4NM8MjkSmRkvneftS6QkwFV5EVg1HkoyalUZGd1HyOdgi0VTg899RtHzM
lHYTwIdGw6B0nKZgOeFO+BhxPDOaf6+xWYG/umWLKrMmtS0wPgtc3SZQfYNt2ZpN
kb07GKzCpHopEnOKia3E
=b+sY
-----END PGP SIGNATURE-----

--MP5ln1Rcf9Bvi+ZW--
