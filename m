Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab2IGUKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 16:10:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56200 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2IGUK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 16:10:28 -0400
Date: Fri, 7 Sep 2012 22:10:17 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>,
        linux-kernel@vger.kernel.org,
        =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>
Subject: Re: [PATCH 8/9] ARM i.MX53: Add pwms to dtsi
Message-ID: <20120907201017.GA17043@avionic-0098.mockup.avionic-design.de>
References: <1346154504-5623-1-git-send-email-s.hauer@pengutronix.de>
 <1346154504-5623-9-git-send-email-s.hauer@pengutronix.de>
 <20120830223219.GF3613@r65073-Latitude-D630>
 <20120831130723.GS26594@pengutronix.de>
 <20120907132955.GH29340@avionic-0098.mockup.avionic-design.de>
 <20120907172612.GU26594@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20120907172612.GU26594@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:1JB79sel6Bz+pm5ZdOtcjmIM+kJApPMvzFhaRdTbAE6
 V/uNI3y00VXWMuaMZsM7dbvycvoYPGJ474XnkvrJjbQneVIEGz
 yrt+WikZHCQ58VcBrhZ6mofZuumSupjcQ6/DZbISRA4skxgnVE
 GsLEg40IVGMUfENjiYDsxTluL0sAaiqVQZOsrVPOcZ+rk9WOFo
 pMzR97IyG2Q3tG7XjljPKELxlHmWfUxT6v4KSIKkxyQVCMr0RA
 bo/M/GE9wbZMAQzVuMM0WBMLT9vkvwAT/UwRjW9JQZt6kaNndk
 edt3f617PNvLDdxlj4cqKpIVdY9NWwVkrUZ5tVW6UONxdEIVAg
 Zlz81RN+T/0Xw+ctI0fM7nGPyqjZ/SC2T1zxkGep9QkPlPs8Sq
 t2M/rSFCGKO3EfRbgMlFD9riRcjBjLMKDA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 07, 2012 at 07:26:12PM +0200, Sascha Hauer wrote:
> On Fri, Sep 07, 2012 at 03:29:55PM +0200, Thierry Reding wrote:
> > On Fri, Aug 31, 2012 at 03:07:23PM +0200, Sascha Hauer wrote:
> > > On Fri, Aug 31, 2012 at 06:32:20AM +0800, Shawn Guo wrote:
> > > > On Tue, Aug 28, 2012 at 01:48:23PM +0200, Sascha Hauer wrote:
> > [...]
> > > > >  arch/arm/boot/dts/imx53.dtsi        |   14 ++++++++++++++
> > > > >  arch/arm/mach-imx/clk-imx51-imx53.c |    4 ++++
> > > > >  2 files changed, 18 insertions(+)
> > > > >=20
> > > > > diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx=
53.dtsi
> > > > > index cd37165..7ec17e4 100644
> > > > > --- a/arch/arm/boot/dts/imx53.dtsi
> > > > > +++ b/arch/arm/boot/dts/imx53.dtsi
> > > > > @@ -189,6 +189,20 @@
> > > > >  				status =3D "disabled";
> > > > >  			};
> > > > > =20
> > > > > +			pwm1: pwm@53fb4000 {
> > > > > +				#pwm-cells =3D <3>;
> > > >=20
> > > > pwm-cells should be 2?
> > >=20
> > > Yes, right. We have a patch internally that allows us to pass a
> > > 'inverted' flag to the pwm, hence I accidently have 3 here.
> >=20
> > There are patches in for-next that add support for setting the PWM
> > polarity, though there's currently no support for specifying it via a
> > third cell in the specifier. Would you mind sharing the patches that add
> > this?
>=20
> Yes, will do. I was afraid this leads to some discussion, so I skipped
> them so far.
>=20
> The basic idea was that the third cell is for flags from which bit0 set
> means 'inverted'. We currently implemented this i.MX specific, but if
> you think this is acceptable it's propably a good idea to implement this
> in a generic manner.

Absolutely. That's exactly what I had in mind as well, so if you have
the code ready I don't have to write it myself.

Thierry

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQSlSpAAoJEN0jrNd/PrOhUIwQAIgniiWuxzKwnNQnzpkOzt2l
LP0OOVWtt0xztPSVfCWhtkK3RaT8TdsDfKmvVGpKyW6V2FoEqupfjKoooU48BbES
SPQC4nNBzFEASOpE+5MJOnBA1vYEcNisKvQuXfH+mmRZ45HbCyDzWlPyAlHGXByo
brox811njMdy4E6hIUT9aD8vEOWxGFC43K3dup26Z+SZyBTPWdYtkoThDDAPbn8G
9qjfYpaWi5nXBAkjMZa+bCLy30qo/o8IhIR1/FME86UvpuUmsDQhwqvbrlhshncD
m/LjOA0TqguxXE0eJVgeuLh7546m9UUAo/m42cGYlK5/TJC02qBs3oWcvD54xOAP
2YmmqW4iWAR37WNX720Bp9kvTzjraiwx+zZyg5g5BkM6HLVmz4wVk82ytPtRByvv
gimHREa5BE50Wcy1RsO2jHVYQ28R5NncCIBb31bzQdi17Rc2RhpwO/z0qxxV8kaI
vb3oq+IXa1qHnSg6lKtiK3jpeTl0ConpBQNSvMqnnuCZKU7ed/3YcgzeF9Q0TKtx
61egS2tKHbv8sQPA9RNnDiJ4yhBriG7kZogkptMlzecUon3uiwySbPVCfwmNYU8D
rIEra1UmjHhaz5pIwZNzHh4r/9+8w4FkzIHleG/VAabzO1JpRjuPyd+/Utu4OU5b
ATzkwZ+LYFCKyu3GobEf
=JiTG
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
