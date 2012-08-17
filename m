Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2HQGLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 02:11:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49902 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2HQGLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 02:11:08 -0400
Date: Fri, 17 Aug 2012 08:11:02 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Borislav Petkov <bp@alien8.de>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: awful kconfig help texts.
Message-ID: <20120817061102.GA6003@avionic-0098.adnet.avionic-design.de>
References: <20120731151600.GA19412@redhat.com>
 <20120731170741.GA4735@x1.osrc.amd.com>
 <20120816095439.GA30794@avionic-0098.mockup.avionic-design.de>
 <20120816111044.GA12029@x1.osrc.amd.com>
 <20120816120541.GA10154@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <20120816120541.GA10154@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:2CXUrl//piGutbh0l3uoLV6VzrBrO9eAdIuAdnCNYv4
 QARt30PMn25DYxy+Yas/HpvvT+I8kZyWOLQJW3U5WYcI6Z5sPn
 cpaObLB5nkBrhnAMuo6uIlbEzwF69gpWaWbH3DcAffaGx9uGRI
 UxAhvxto6I7LfqKQlvsXoGa3pOjzF1njR0hlIMx8VywMu/0/kk
 yQJNYMW1KaUKrBXLDC+IriwkcGSGvJQqm8pOUk0Bhqsvjpwm4C
 N1jDw06FZKh0Gk1BmVQXAW4skv87a1LS2i2j/tzG8tcTJwszgn
 zPrzUodVUEtYb3YD7shA0jz/oo9c6ERXaPmEgwd8nsZtWrt1FM
 Jx57f20NZ0UbjTBM4xVrLp/EPTe9kRwGXKej9O1nPp0X9y13RH
 v43Z9r/4hukXG0ucH5QmZpRINPdYTm780M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 16, 2012 at 02:05:41PM +0200, Thierry Reding wrote:
> On Thu, Aug 16, 2012 at 01:10:44PM +0200, Borislav Petkov wrote:
> > On Thu, Aug 16, 2012 at 11:54:39AM +0200, Thierry Reding wrote:
> > > How does the attached patch look?
> > >=20
> > > Thierry
> >=20
> > > From cd3199b94e697cccd38766b4a60d2e91474d0539 Mon Sep 17 00:00:00 2001
> > > From: Thierry Reding <thierry.reding@avionic-design.de>
> > > Date: Thu, 16 Aug 2012 08:01:21 +0200
> > > Subject: [PATCH] pwm: Improve Kconfig help text
> > >=20
> > > The Kconfig help text should help the user understand what functional=
ity
> > > is provided by an option. This is especially true for new subsystems.=
 An
> > > improved help text is provided by this commit in the hopes of clarify=
ing
> > > the usefulness of the PWM framework.
> > >=20
> > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > > ---
> > >  drivers/pwm/Kconfig | 24 ++++++++++++++++++------
> > >  1 file changed, 18 insertions(+), 6 deletions(-)
> > >=20
> > > diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> > > index 8fc3808..88ddb9e 100644
> > > --- a/drivers/pwm/Kconfig
> > > +++ b/drivers/pwm/Kconfig
> > > @@ -1,12 +1,24 @@
> > >  menuconfig PWM
> > > -	bool "PWM Support"
> > > +	bool "Pulse-Width Modulation (PWM) Support"
> > >  	depends on !MACH_JZ4740 && !PUV3_PWM
> > >  	help
> > > -	  This enables PWM support through the generic PWM framework.
> > > -	  You only need to enable this, if you also want to enable
> > > -	  one or more of the PWM drivers below.
> > > -
> > > -	  If unsure, say N.
> > > +	  Generic Pulse-Width Modulation (PWM) support.
> > > +
> > > +	  This framework provides a generic interface to PWM devices
> > > +	  within the Linux kernel. On the driver side it provides an API
> > > +	  to register and unregister a PWM chip, an abstraction of a PWM
> > > +	  controller, that supports one or more PWM devices. Client
> > > +	  drivers can request PWM devices and use the generic framework
> > > +	  to configure as well as enable and disable them.
> > > +
> > > +	  The new generic framework replaces the legacy PWM framework
> > > +	  which allows only a single driver implementing the required
> > > +	  API. Not all legacy implementations have been ported to the
> > > +	  new framework yet. The new framework provides an API that is
> > > +	  backward compatible with the legacy framework so that existing
> > > +	  client drivers continue to work as expected.
> > > +
> > > +	  If unsure, say no.
> >=20
> > Yes, this is much better than what we had before. I'd suggest though,
> > that instead of describing the high-level software design of the PWM
> > subsystem, the text should be more addressed to the simple user like me
> > who would like to know what this thing is and why do I want to enable
> > it. Basically summarize what PWN devices are and what they're used for.
> > I.e., https://en.wikipedia.org/wiki/Pulse-width_modulation#Applications
> > but in 4-5 lines of text.
> >=20
> > IMHO, of course.
>=20
> Okay, I'll add something along those lines in addition to the above.
> That way everybody should find something useful in it.

How about the patch below?

Thierry

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0001-pwm-Improve-Kconfig-help-text.patch"
Content-Transfer-Encoding: quoted-printable

=46rom deb6852dc5e9da365a33c744f2dc107ae11b407a Mon Sep 17 00:00:00 2001
=46rom: Thierry Reding <thierry.reding@avionic-design.de>
Date: Thu, 16 Aug 2012 08:01:21 +0200
Subject: [PATCH v2] pwm: Improve Kconfig help text

The Kconfig help text should help the user understand what functionality
is provided by an option. This is especially true for new subsystems. An
improved help text is provided by this commit in the hopes of clarifying
the usefulness of the PWM framework.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/pwm/Kconfig | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 8fc3808..cd602e7 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -1,12 +1,31 @@
 menuconfig PWM
-	bool "PWM Support"
+	bool "Pulse-Width Modulation (PWM) Support"
 	depends on !MACH_JZ4740 && !PUV3_PWM
 	help
-	  This enables PWM support through the generic PWM framework.
-	  You only need to enable this, if you also want to enable
-	  one or more of the PWM drivers below.
-
-	  If unsure, say N.
+	  Generic Pulse-Width Modulation (PWM) support.
+
+	  In Pulse-Width Modulation, a variation of the width of pulses
+	  in a rectangular pulse signal is used as a means to alter the
+	  average power of the signal. Applications include efficient
+	  power delivery and voltage regulation. In computer systems,
+	  PWMs are commonly used to control fans or the brightness of
+	  display backlights.
+
+	  This framework provides a generic interface to PWM devices
+	  within the Linux kernel. On the driver side it provides an API
+	  to register and unregister a PWM chip, an abstraction of a PWM
+	  controller, that supports one or more PWM devices. Client
+	  drivers can request PWM devices and use the generic framework
+	  to configure as well as enable and disable them.
+
+	  The new generic framework replaces the legacy PWM framework
+	  which allows only a single driver implementing the required
+	  API. Not all legacy implementations have been ported to the
+	  new framework yet. The new framework provides an API that is
+	  backward compatible with the legacy framework so that existing
+	  client drivers continue to work as expected.
+
+	  If unsure, say no.
=20
 if PWM
=20
--=20
1.7.11.5


--n8g4imXOkfNTN/H1--

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQLeB2AAoJEN0jrNd/PrOhuAkP/0kJ/K55IyjxSZPevWlwmPlu
K409fGkm+YVYQDuSxRVNzVr1OBy9t1u4MdLaBLbLNB7FfWb0R3lzgM1zbuObGfXv
G6UUxFXrCpc60kOSCrjJLtf7L/bG5PZh16vzFpLVBMiJb7FIjBXH2TywRzn/uu8n
e1QzBGn8BqfLNdeACQQGG1pi5MAvg9uyqnGCEtTlUAZmlM7prpzEdZ3keRk7Vn3X
J2ljrVnouQs695uFsC3s3IcF6U3Q82AEwMlqheNWynDunBZ5iqf2wY1nXOmqHLCg
M3f15oD6yOqU65uovupLE/63YQSaNTdwdWFvVYekGg0g9280WgOJb2MAMt6IsLk9
2fM9uFzRbAx9W70NCpLHcMy2Ba7BbB/106LrpWkWP/4nlZQbWtXM8YEB1MyP1F20
nvyJgQnepZVlAvZ18iP200dO7yWCDPULZTvd6WQAy1Kc+BYUgW//V4VAOCs8p3cU
L/Qwd+GqpWBltPRAF8iG9KN4k6mrIw7XBnHRk03vGH1SEbeXdT3KgswVNdvhzvDq
KMx/xDeNDu3he/5x0JumuC8AvjMuFNrixm3KexVz7O8V0VnbUHU+Mk0powJrIKF3
HdlvoieY3Vbfg8Bj1ivG8vBpM9gPoCCiJ8Cng3GlQxpoeH6GEYjQ+EOEdI7ZQa4i
Ls4Itsn8RQDddFbe6yMs
=aJ1F
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
