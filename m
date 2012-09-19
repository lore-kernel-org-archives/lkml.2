Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2ISGok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 02:44:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49766 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2ISGof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 02:44:35 -0400
Date: Wed, 19 Sep 2012 08:44:25 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] pwm_backlight: Add device tree support for Low Threshold
 Brightness
Message-ID: <20120919064425.GA1506@avionic-0098.mockup.avionic-design.de>
References: <1343219042-4371-1-git-send-email-avinashphilip@ti.com>
 <20120730065805.GB15245@avionic-0098.mockup.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E97C4C9@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3E97C4C9@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:uSMsgx57H57wuhTWeJwkFmW8a+63mDd0nKd17hbxXn9
 U1ZyxZEQMvy6ptPzeqWyXvb7nLJr8mITRsENNcF6BnX8XlpgDG
 sFC3KDd19aQsL61TN/KCscT/+jjnNS6XFEYiqM273KuoXFfZ6G
 xdhPi9sKmVvrfQ7XRRy9yyYD/W8UefLzDkKEbhycUqSj+G3KJg
 TDDgsSApYJ025l2Wb8TGOtC2iGE37TkWThPCiAVXwftMjPN9Zd
 lzR6WYINCeW64pGSZG+jlPoSVa6bJ5YbdkL6ewM+MxebP1GNsu
 m7y6HLpy8PkiPOv693ZgjmajWegLS/tOhaT8gqw3pcboNSyvuQ
 9f/Yr3kq8ocvZitYFfh59SwL6KtOM4/D0LyMOVx42/HCBH3x8S
 BY0VLIY7KSzhzRPeYjIYl3YoH+ZUW2g1y7zhoA8c8TPV/iZ/rq
 jMBF+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 01, 2012 at 06:51:21AM +0000, Philip, Avinash wrote:
> On Mon, Jul 30, 2012 at 12:28:05, Thierry Reding wrote:
> > On Wed, Jul 25, 2012 at 05:54:02PM +0530, Philip, Avinash wrote:
> > > Low Threshold Brightness should be configured to have a linear relati=
on
> > > in brightness scale. This patch adds device tree support for low
> > > threshold brightness as optional one for pwm_backlight.
> >=20
> > I think this should be more explicit as to why this is required, perhaps
> > something like this:
> >=20
> > 	Some backlights perform poorly when driven by a PWM with a short
> > 	duty-cycle. For such devices, the low threshold can be used to
> > 	specify a lower bound for the duty-cycle and should be chosen to
> > 	exclude the problematic range.
> >=20
> > 	This patch adds support for an optional low-threshold-brightness
> > 	property.
>=20
> Ok I will correct it.
>=20
> >=20
> > Perhaps a similar explanation should be given somewhere else instead of
> > just the changelog. It took me some time to understand what exactly this
> > low threshold means and I think it'd make sense to write this kind of
> > information down somewhere. I'll see if I can make time to add a bit of
> > documentation somewhere below Documentation/backlight perhaps.
> >=20
> > > Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> > > ---
> > > :100644 100644 1e4fc72... 5c54380... M	Documentation/devicetree/bindi=
ngs/video/backlight/pwm-backlight.txt
> > > :100644 100644 995f016... 4965408... M	drivers/video/backlight/pwm_bl=
=2Ec
> > >  .../bindings/video/backlight/pwm-backlight.txt     |   21 ++++++++++=
++++++++++
> > >  drivers/video/backlight/pwm_bl.c                   |    5 ++++
> > >  2 files changed, 26 insertions(+), 0 deletions(-)
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-ba=
cklight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlig=
ht.txt
> > > index 1e4fc72..5c54380 100644
> > > --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight=
=2Etxt
> > > +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight=
=2Etxt
> > > @@ -14,6 +14,8 @@ Required properties:
> > >  Optional properties:
> > >    - pwm-names: a list of names for the PWM devices specified in the
> > >                 "pwms" property (see PWM binding[0])
> > > +  - low_threshold_brightness: brightness threshold low level. (get l=
inear
> > > +		 scales in brightness in low end of brightness levels)
> >=20
> > The convention is to use dashes, not underscores, in device tree
> > property names, so this should be "low-threshold-brightness". I'd also
> > omit the comment in parentheses because the DT binding document
> > shouldn't specify any particular use-case. However I think it'd make
> > sense to add some information about the number space of the low
> > threshold value.
>=20
> Ok, I will correct it.
>=20
> >=20
> > Maybe we should also rethink how the low threshold is handled in cases
> > where the brightness levels are used. I'm not sure it makes sense to
> > specify the low threshold as a value relative to the range given by the
> > levels. Perhaps it is more meaningful to specify it as relative to the
> > period/duty-cycle.
> >=20
> > > =20
> > >  [0]: Documentation/devicetree/bindings/pwm/pwm.txt
> > > =20
> > > @@ -26,3 +28,22 @@ Example:
> > >  		brightness-levels =3D <0 4 8 16 32 64 128 255>;
> > >  		default-brightness-level =3D <6>;
> > >  	};
> > > +
> > > +Example for brightness_threshold_level:
> > > +
> > > +	backlight {
> > > +		compatible	=3D "pwm-backlight";
> > > +		pwms =3D <&pwm 0 50000>;
> > > +
> > > +		brightness-levels =3D <0 4 8 16 32 64 128 255>;
> > > +		default-brightness-level =3D <6>;
> > > +		low_threshold_brightness =3D <50>;
> > > +	};
> > > +};
> >=20
> > I think you can just merge the low-threshold-brightness with the
> > previous example.
>=20
> Ok I will check and correct it.
>=20
> >=20
> > > +Note:
> > > +Low threshold support is required to have linear brightness scale fr=
om
> > > +0 to max. For some panels, backlight absent on low end of brightness
> > > +scale. So support for Low Threshold been required. So that the scale=
 of
> > > +brightness changed from Low Threshold to Max in scales defined in
> > > +brightness-levels. In this example 20% maximum brightness scale shou=
ld
> > > +be required to turn on panel backlight.
> >=20
> > I think this kind of documentation doesn't belong in the device tree
> > binding. I'll work something like that into the proper documentation.
> >=20
> > > diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlig=
ht/pwm_bl.c
> > > index 995f016..4965408 100644
> > > --- a/drivers/video/backlight/pwm_bl.c
> > > +++ b/drivers/video/backlight/pwm_bl.c
> > > @@ -143,6 +143,11 @@ static int pwm_backlight_parse_dt(struct device =
*dev,
> > > =20
> > >  		data->dft_brightness =3D value;
> > >  		data->max_brightness--;
> > > +
> > > +		ret =3D of_property_read_u32(node, "low_threshold_brightness",
> > > +					   &value);
> > > +		if (!ret)
> > > +			data->lth_brightness =3D value;
> > >  	}
> >=20
> > This obviously should also be low-threshold-brightness.
>=20
> I will change to
>=20
> ret =3D of_property_read_u32(node, " low-threshold-brightness ",
>=20
> Thanks
> Avinash

I think you never sent an updated patch or maybe I missed it. But I
noticed that this patch has now ended up in Andrew's tree without the
comments being addressed. Can you please follow up?

Andrew: Can you remove this from your tree? As you can see it has been
discussed before. I've mentioned elsewhere that I volunteer to take over
maintenance of pwm-backlight so I'll carry this patch through the PWM
tree.

Thierry

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQWWnJAAoJEN0jrNd/PrOhyEMP/21wTqwoXIebvfHKfM1VeNme
k/aAdoe26N/cJdnQN4KLh66YBZcLFR6ugxIVqjpbiPylhZAcV8kAVsncZABDLRWF
vVY6Q6gJXFoHcI3EMx78QJteCD8EcEOTbc40vjMFKyvnw+oMAyr1A+70uCcaJo33
AKVdN8n+K1Ve1L/vr2QAIathh4pKMpcyQZWgN326boDjwYTbZz0tRrzmhpmZIKw2
r9u2Qyj4dVhziAtjr98KrYhcghlcFVziKfPkvTGC+TkkqHoasjtJzsFuaNeAZSws
bDtVMGmGm2cDf/eLiyQNeG25wpEiDm2fETL9asjLFlNnHVra53SUlLf5RNDEUzZr
9boIgvFu30Gn8z12r679f7HqI4zL3Plr+LDnmDcF0Bae9tea9QR5Ylt2XAjxEb9S
aNcntE1z6E25fd7Mf0kzNiGqcG2758HoTZUc7MqbNqg7fqImwnntD7yMHdfsPG3D
OOOb8zauLt0AMmFEE5fSP4gvjeX81Yu+3CvnK2rVRL9SB60HXYQ8hYI4wZL0+AZ0
YHMzRFO0Yh7nVAvVZTt8Z9e2lm1erteYl6idDfIN1l3siQ6wnH9xDDORatTumWBl
1rWo34tKtJVczq5EGNL1bdGuA+ROx94oWp54L5GxIpfsF5ZLkUijpM0BV07O/MAw
IOT3/thOevDQcHWrclnE
=eXsV
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
