Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab2HTLiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:38:51 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:32849 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479Ab2HTLir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:38:47 -0400
Date: Mon, 20 Aug 2012 14:34:49 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Poddar, Sourav" <sourav.poddar@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCHv7] arm/dts: omap4-sdp: Add keypad data
Message-ID: <20120820113448.GO17455@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1344942937-4685-1-git-send-email-sourav.poddar@ti.com>
 <CAKdam57n1jA5_7EOLcsB=u5X4wX6hPVXoZ2HLrnpEKS3kLZ=OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GYaKytDE8aa4+VVK"
Content-Disposition: inline
In-Reply-To: <CAKdam57n1jA5_7EOLcsB=u5X4wX6hPVXoZ2HLrnpEKS3kLZ=OQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GYaKytDE8aa4+VVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 20, 2012 at 04:49:36PM +0530, Poddar, Sourav wrote:
> Hi All,
>=20
> On Tue, Aug 14, 2012 at 4:45 PM, Sourav Poddar <sourav.poddar@ti.com> wro=
te:
> > Add keypad data node in omap4 device tree file.
> > Also fill the device tree binding parameters
> > with the required value in "omap4-sdp" dts file.
> >
> > Tested on omap4430 sdp.
> >
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Benoit Cousson <b-cousson@ti.com>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Felipe Balbi <balbi@ti.com>

to me it looks good. you've even added comments on each key for easy
human parsing.

Acked-by: Felipe Balbi <balbi@ti.com>

> > Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> > ---
> > v6->v7
> > Add key name as a comment.
> >  arch/arm/boot/dts/omap4-sdp.dts |   70 +++++++++++++++++++++++++++++++=
++++++++
> >  arch/arm/boot/dts/omap4.dtsi    |    5 +++
> >  2 files changed, 75 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-=
sdp.dts
> > index 72216e9..8e200f4 100644
> > --- a/arch/arm/boot/dts/omap4-sdp.dts
> > +++ b/arch/arm/boot/dts/omap4-sdp.dts
> > @@ -113,6 +113,76 @@
> >                         "DMic", "Digital Mic",
> >                         "Digital Mic", "Digital Mic1 Bias";
> >         };
> > +
> > +       keypad {
> > +               keypad,num-rows =3D <8>;
> > +               keypad,num-columns =3D <8>;
> > +               linux,keymap =3D < 0x00000012 /* KEY_E */
> > +                       0x00010013 /* KEY_R */
> > +                       0x00020014 /* KEY_T */
> > +                       0x00030066 /* KEY_HOME */
> > +                       0x0004003f /* KEY_F5 */
> > +                       0x000500f0 /* KEY_UNKNOWN */
> > +                       0x00060017 /* KEY_I */
> > +                       0x0007002a /* KEY_LEFTSHIFT */
> > +                       0x01000020 /* KEY_D*/
> > +                       0x01010021 /* KEY_F */
> > +                       0x01020022 /* KEY_G */
> > +                       0x010300e7 /* KEY_SEND */
> > +                       0x01040040 /* KEY_F6 */
> > +                       0x010500f0 /* KEY_UNKNOWN */
> > +                       0x01060025 /* KEY_K */
> > +                       0x0107001c /* KEY_ENTER */
> > +                       0x0200002d /* KEY_X */
> > +                       0x0201002e /* KEY_C */
> > +                       0x0202002f /* KEY_V */
> > +                       0x0203006b /* KEY_END */
> > +                       0x02040041 /* KEY_F7 */
> > +                       0x020500f0 /* KEY_UNKNOWN */
> > +                       0x02060034 /* KEY_DOT */
> > +                       0x0207003a /* KEY_CAPSLOCK */
> > +                       0x0300002c /* KEY_Z */
> > +                       0x0301004e /* KEY_KPLUS */
> > +                       0x03020030 /* KEY_B */
> > +                       0x0303003b /* KEY_F1 */
> > +                       0x03040042 /* KEY_F8 */
> > +                       0x030500f0 /* KEY_UNKNOWN */
> > +                       0x03060018 /* KEY_O */
> > +                       0x03070039 /* KEY_SPACE */
> > +                       0x04000011 /* KEY_W */
> > +                       0x04010015 /* KEY_Y */
> > +                       0x04020016 /* KEY_U */
> > +                       0x0403003c /* KEY_F2 */
> > +                       0x04040073 /* KEY_VOLUMEUP */
> > +                       0x040500f0 /* KEY_UNKNOWN */
> > +                       0x04060026 /* KEY_L */
> > +                       0x04070069 /* KEY_LEFT */
> > +                       0x0500001f /* KEY_S */
> > +                       0x05010023 /* KEY_H */
> > +                       0x05020024 /* KEY_J */
> > +                       0x0503003d /* KEY_F3 */
> > +                       0x05040043 /* KEY_F9 */
> > +                       0x05050072 /* KEY_VOLUMEDOWN */
> > +                       0x05060032 /* KEY_M */
> > +                       0x0507006a /* KEY_RIGHT */
> > +                       0x06000010 /* KEY_Q */
> > +                       0x0601001e /* KEY_A */
> > +                       0x06020031 /* KEY_N */
> > +                       0x0603009e /* KEY_BACK */
> > +                       0x0604000e /* KEY_BACKSPACE */
> > +                       0x060500f0 /* KEY_UNKNOWN */
> > +                       0x06060019 /* KEY_P */
> > +                       0x06070067 /* KEY_UP */
> > +                       0x07000094 /* KEY_PROG1 */
> > +                       0x07010095 /* KEY_PROG2 */
> > +                       0x070200ca /* KEY_PROG3 */
> > +                       0x070300cb /* KEY_PROG4 */
> > +                       0x0704003e /* KEY_F4 */
> > +                       0x070500f0 /* KEY_UNKNOWN */
> > +                       0x07060160 /* KEY_OK */
> > +                       0x0707006c >; /* KEY_DOWN */
> > +               linux,input-no-autorepeat;
> > +       };
> >  };
> >
> >  &i2c1 {
> > diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> > index 04cbbcb..e78a1f1 100644
> > --- a/arch/arm/boot/dts/omap4.dtsi
> > +++ b/arch/arm/boot/dts/omap4.dtsi
> > @@ -296,4 +296,9 @@
> >                         ti,hwmods =3D "dmic";
> >                 };
> >         };
> > +
> > +       keypad {
> > +               compatible =3D "ti,omap4-keypad";
> > +               ti,hwmods =3D "kbd";
> > +       };
> >  };
> > --
> > 1.7.1
> >
> Any more comments on this?
>=20
> ~Sourav

--=20
balbi

--GYaKytDE8aa4+VVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQMiDYAAoJEIaOsuA1yqRE0aEP/0aTYNCZg3CzZQ8MbmzV6N5I
TjZsGxUnKVovMnJCkWZMvoXeQrcbWACOtmV2lmKaWflAe1+8OC8VsFTzBqlP4cLP
+ZJc/aa1uem0UcMrbDZa1EQjJoELvu790uoMxdUXEWM4zMNuBZu2RXMFdc9xaU6x
DmQ+T76bRyUpNAb8AulrGvqLcHkzPyeS4s8247ZpESvq68cg9P6GiH2RyxNUoyq0
KPGDGLlZD3y61HL+lyii8gqJ5naqLgQU2TYUDpUK+Y9CDkDvVfR6t10ILt8t/qtj
Pch1YX1DV0Eswd0gqFp/fMjs0iZajZ3E5mXfl4HfWAPHNtJ3X1ElyMhhKd9dTzpO
cRjoCPOKpVNGYh+Ka1oXbCL5jYRh1vEPVC/83ZtGr7rhAeIQ6w2kXzVmdsZ57WBV
VwyoHfrfkITj+N0zBndFZzCYI/RYgF8SRkWy4gJ3NcoMvNjNlha0bBqeXHue4ZWQ
bAWAKVyvpMNptgtc2LPeYmrgoV4mggrI5zwxNda5aLMuScovaQ1WrdwQAnZ66Ml+
wFcdIbZvckoBZt/gNNtLoWotTzfAtPXLRVi+wmYphhMv7cjTpbQ6bAeQ6cQJHt+I
Zu5XGqctBgI5c4mwuUj1fWugzzMi2dSHG9u1MhpKJxlQn0UkhAnFKPtJYKxzBW3z
eLrnP1om3yHFOl+wz6tO
=r4cn
-----END PGP SIGNATURE-----

--GYaKytDE8aa4+VVK--
