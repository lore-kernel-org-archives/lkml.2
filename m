Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2KILTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:19:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52604 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2KILTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:19:34 -0500
Date: Fri, 9 Nov 2012 12:19:28 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: "paul@pwsan.com" <paul@pwsan.com>, "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2 04/10] pwm: pwm-tiecap: Add device-tree binding
 support for APWM driver
Message-ID: <20121109111928.GA2391@avionic-0098.mockup.avionic-design.de>
References: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
 <1352361197-27442-5-git-send-email-avinashphilip@ti.com>
 <20121109075219.GA22224@avionic-0098.mockup.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E9E44FC@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3E9E44FC@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:sm21svA4newxIfpfh+4Sy4/lrx1xdZGEUMvOwe74dTG
 o/NQZqz/OK9WwXrJuLTQgxHVNXCf4UbuKg4xR7TkF//qynp6+I
 /ciQjSNHT9pSkrDUETldJ0tfCTgSm2h8pT6HKvZuBfrCvsSahG
 jkD0jnLufY+X4DG9O3VZglbSTbtpi5Xgtt05K8ch0D1e3SNQ04
 GFlG0+rZUIVAGw4BlTTX1USLij0kw3b3HDn20P5Ib3KyYhZH4I
 7KOZGKjTpK5hXdK/uLBz1dO/acm01+GUeWcWuqyx83Hzzm30Kt
 MEaSoNPp5fy7crJHu5BDz2ATudqMsdI8LmF9yL9YyGgY/E2ISE
 hGRLWcX1JLtGdqIw9Us6RGGCKVbNjfGedJ4TBobLe7THQ0L8wd
 fSRxh8wmtcT8rA6+wMlfR9zE6gQsD2VmqhXoYVaTgFyaYT7zbE
 gGgzD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 10:59:30AM +0000, Philip, Avinash wrote:
> On Fri, Nov 09, 2012 at 13:22:19, Thierry Reding wrote:
> > On Thu, Nov 08, 2012 at 01:23:11PM +0530, Philip, Avinash wrote:
> > > +#define ECAPCLK_EN			BIT(0)
> > > +#define ECAPCLK_STOP_REQ	BIT(1)
> >=20
> > This one doesn't seem to align with the rest. Also, why is bit 0 called
> > _EN and bit 1 _STOP_REQ? Couldn't they be made more consistent, i.e.
> > _START and _STOP? Or _ENABLE and _DISABLE?
>=20
> Ok I will change to PWMSS_ECAPCLK_EN & PWMSS_ECAPCLK_STPO_REQ

While at it, maybe move these defines to the pwm-tipwmss.h header file?
After all that's the module that accesses the register that contains
these bits.


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnObAAAoJEN0jrNd/PrOh12oQALgj+/7wakFIGEHh3SWHMok5
S91TEkAovcubKqekRnN/38Bh+XcXHObKRCkhnmiJYTR0eZNSIA+rR/L5KAAgHpdQ
Lg5VHaGmm6fk5JCCNjUvqnsyquoMLVJQts/uvjSmwh0Rz+/hiZLwMBPWZAKvVoEu
PXQfjAm4m4NB3SlHbW/AtKF/QDe2RrrQYpggNiiGwjNmAkxyxQOXmgPBs13IcBG/
GIco9kEwALeJ+TVxvneWw6qxgTDylaKGD7hJFq3ItcZoTxgTLcaB+huejOtQQFJr
/4/Q6/ZpcDhjtSGK4CySjYcU4eD6aGzmRKONxKIG8qBTg3Yqyv/Ap6t3C4l9WzfT
AcIwKy9Knp46W9uf+oUHDYPQOJdQkDjdraZuhZI/cPUGXStMdd+SjU0lyKsKsc0E
eao43XmGx0GFlCiMULuV7dGfhBNLRgt1u39FgowT/DEmcgSjyHUHgZUtRTRHQGwS
QMUmX6hfDUVp7iyqJnTI9lU26/BxZw1YaFgTfqDWbhAzsetW4ARSg4YTyhqoJiSs
yKMdjjGXmGlhtqYGxr4j3+vSppPeMu4mKwtpEqwE0igUM7802DIwpJR5qHSPlpir
qUNtDAYQTup8siYt5cKSsmASmyfZguwm7fB1vhCm/Qx8WXSZEjLb29Iq5EC1Nj5T
a6eGVYJSyuswdwIWJiwl
=WQOh
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
