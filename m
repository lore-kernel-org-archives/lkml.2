Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab2I0JsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 05:48:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60483 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2I0JsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 05:48:19 -0400
Date: Thu, 27 Sep 2012 11:47:50 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
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
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: Re: [PATCH v2] pwm_backlight: Add device tree support for Low
 Threshold Brightness
Message-ID: <20120927094750.GA21304@avionic-0098.mockup.avionic-design.de>
References: <1348203080-16348-1-git-send-email-avinashphilip@ti.com>
 <505BF83D.8040201@wwwdotorg.org>
 <518397C60809E147AF5323E0420B992E3E9A685B@DBDE01.ent.ti.com>
 <505CA74B.2090405@wwwdotorg.org>
 <518397C60809E147AF5323E0420B992E3E9A8449@DBDE01.ent.ti.com>
 <50614CE2.7010301@wwwdotorg.org>
 <518397C60809E147AF5323E0420B992E3E9A8FA7@DBDE01.ent.ti.com>
 <50631EF7.6040908@wwwdotorg.org>
 <20120926164949.GA24041@avionic-0098.mockup.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E9A9B2A@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3E9A9B2A@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:P2N1Sbzrkl63bHgAGY6nhovS6imhKyvJ/eVHPT4AKtO
 ObRr7f2jTwR8CFtMIlCNoJPOnUVrbJ5ZcWgdc1hCqsi5pQlXx3
 YcXtnnmD4I3GMPi5gTnGp7q4O9Z6GrMU44QWuaNbeMcdP2H4uC
 QJQ3BqEozKD2fHkKJWCRxZ36tgXBRQX9WjpVXf9bTrgNOjHOj6
 cxcl0QtetXbk1rw/CT46rMXJ7Q07sOhUUhz5JIPVegviehDhHJ
 XASADS8KSU5YErdusaMuj6kAzi9JqIZRuJbt5ebXe3qYuvSbA3
 g3sGO/qtQppYY809x/A+GhV7f6vsNpAsXCHigFZX6AFI2vhd7g
 uW46MBHVC3OgBU15ifYfFGqSdaZpiBsv5S5A9KpgyCqdCe75w+
 JsBEsyyJQUhQCg9QQeM/OjHdU3WX2L9mAiNNN5nEwrqwn3hNsf
 jly/l
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 27, 2012 at 09:24:47AM +0000, Philip, Avinash wrote:
> On Wed, Sep 26, 2012 at 22:19:49, Thierry Reding wrote:
> > On Wed, Sep 26, 2012 at 09:27:51AM -0600, Stephen Warren wrote:
> > > On 09/25/2012 10:35 PM, Philip, Avinash wrote:
> > > > On Tue, Sep 25, 2012 at 11:49:14, Stephen Warren wrote:
> > > >> On 09/24/2012 10:29 PM, Philip, Avinash wrote:
> > > >>> On Fri, Sep 21, 2012 at 23:13:39, Stephen Warren wrote:
> > > >>>> On 09/21/2012 12:03 AM, Philip, Avinash wrote:
> > > >>>>> Hi Stephen,
> > > >>>>>
> > > >>>>> On Fri, Sep 21, 2012 at 10:46:45, Stephen Warren wrote:
> > > >>>>>> On 09/20/2012 10:51 PM, Philip, Avinash wrote:
> > > >>>>>>> Some backlights perform poorly when driven by a PWM with a sh=
ort
> > > >>>>>>> duty-cycle. For such devices, the low threshold can be used t=
o specify a
> > > >>>>>>> lower bound for the duty-cycle and should be chosen to exclud=
e the
> > > >>>>>>> problematic range.
> > > >>>>>>>
> > > >>>>>>> This patch adds support for an optional low-threshold-brightn=
ess
> > > >>>>>>> property.
> > > >>>>>>
> > > >>>>>>> diff --git a/Documentation/devicetree/bindings/video/backligh=
t/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm=
-backlight.txt
> > > >>>>>>
> > > >>>>>>>  Optional properties:
> > > >>>>>>>    - pwm-names: a list of names for the PWM devices specified=
 in the
> > > >>>>>>>                 "pwms" property (see PWM binding[0])
> > > >>>>>>> +  - low-threshold-brightness: brightness threshold low level=
=2E Low threshold
> > > >>>>>>> +    brightness set to value so that backlight present on low=
 end of
> > > >>>>>>> +    brightness.
> > > >>>>>>
> > > >>>>>> For my education, why not just specify values above this value=
 in the
> > > >>>>>> brightness-levels array; how do those two interact?
> > > >>>>>
> > > >>>>> Please find details from=20
> > > >>>>> https://lkml.org/lkml/2012/7/18/284
> > > >>>>
> > > >>>> Hmm. That still doesn't really explain what this property does.
> > > >>>>
> > > >>>> I'm going to guess that if this property is present, and values =
in the
> > > >>>> brightness-levels property get scaled between the
> > > >>>> low-threshold-brightness and 255 instead of being used directly.
> > > >>>
> > > >>> This is correct.
> > > >>>
> > > >>>> But then, in the email you linked to, what does "But brightness-=
levels won't
> > > >>>> be uniformly divided" mean?
> > > >>>
> > > >>> For some panels, backlight would absent on low end of brightness =
due to low
> > > >>> percentage in duty_cycle. Consider following example where backli=
ght absent
> > > >>> for brightness levels from 0 - 51.
> > > >>>
> > > >>> pwms =3D <&pwm 0 50000>;
> > > >>> brightness-levels =3D <0 51 53 56 62 75 101 152 255>;=20
> > > >>> default-brightness-level =3D <6>;
> > > >>>
> > > >>> So in the example, brightness-levels are set to have values for b=
acklight present.
> > > >>> Here levels are not uniformly divided.
> > > >>
> > > >> So why not just change the values so they /are/ what you want? Aft=
er
> > > >> all, it's just data and you can put whatever values you want there=
=2E What
> > > >> is preventing you from doing this?
> > > >=20
> > > > brightness_threshold_level was added to explore lth_brightness supp=
ort already
> > > > present in non-DT case.
> > >=20
> > > I understand that. Given my discussion above, I would advocate removi=
ng
> > > lth_brightness from the non-DT case rather than adding it to the DT
> > > case, since it seems entirely pointless.
> >=20
> > It is still required for the case where brightness levels are not used.
> > So we can't drop it right away. I agree however that we should plan to
> > get rid of the max_brightness and lth_brightness eventually. Since the
> > DT bindings don't use it yet we should keep only the brightness levels.
> > Once all users have been converted we can rename max_brightness to
> > something like num_levels and remove lth_brightness. dft_brightness can
> > probably be renamed to default_level.
>=20
> In non-DT case lth_brightness is required.=20
> But for DT we have options with/without lth_brightness support.=20
> In case if patch is dropped, user has to put proper brightness-levels=20
> (brightness-levels DT parameters should be specified considering the=20
> low-threshold values)
>=20
> Meanwhile I had submitted another version yesterday (with more documentat=
ion)
>=20
> [PATCH v3] pwm_backlight: Add device tree support for Low Threshold Brigh=
tness
>=20
> https://lkml.org/lkml/2012/9/26/271
>=20
> Thierry,
>=20
> Can you please confirm the acceptance/rejection of the patch? This will h=
elp me
> to submit the backlight DT blob for AM335x platform.

Let's go with the brightness levels approach. We have the upcoming power
sequence stuff that is needed to get rid of the platform data callbacks
and I'm afraid if we keep adding wildly. I think there are already too
many possible combinations right now and we should get them cleaned up
sooner rather than later.

Thierry

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQZCDGAAoJEN0jrNd/PrOhkw4QAKCJuOtWnBaMC7wc3WPhvJlW
ZVVu9rDxJ4HnlAyKEJr30pnkTu/GJpmYko7FCyOpeeULkQ8h6fQKk3sW4zn4uSuC
DdSI11lPX1MvYEv2+9I8WqEEYP6KTJyafMjqaLwDw8Gtor0yILjj+xQqeFuro6vA
ayMARqxORitNz0w7g/rMOSbv7DcCiSXQm41IcfzeltVCuwTYG3POtJXlvnKPMqOO
y8fb3W9/BJ3Ix/BumjwHKmrAhu2Y/mZ+GhL4k9xu6NLp8h796KHfSGBWi1GIvRXv
jTqglcjdEWHsTO8R/0G5OmDeqzWpGnd+wbqPJZ/GHyWSIp8CN8QCqea2QcnNvrCo
8VJgEYuB8tmeA28iSPjMO4C626oo+JXGZgOpClUUbeUm+jmy59SxUA90pjdhwn3X
EygWPwUDepyClq9iB5So2DAw7Bax5MnEk9v/nLYFUldM7vIWUwRptsBXA3/ucNws
4uq6qaYT2WAYegzy3+w2GmExyjmZo++ik6I6SlaTK8lUcg6AYcb0JXc601l+FDFi
PQppGW2pvm7JxpoSi+/k8yBMPuYfwjFRObjh5IMWkVqymYjMSdAIndVsmRuWdl46
DIJDDcUEdReTbjtgQBQqxop/yuwVbyFDEx7Mr2RYVrz+zb653c7sHHvI44aeTziy
j+i/Wz9Mc4RFp5vBqXbr
=I+o5
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
