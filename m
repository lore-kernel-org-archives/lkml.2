Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab2HLGs0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 02:48:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54059 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2HLGsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 02:48:24 -0400
Date: Sun, 12 Aug 2012 08:48:03 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Grant Likely <grant.likely@secretlab.ca>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/dt: use linear irq domain for ioapic(s).
Message-ID: <20120812064803.GA5950@avionic-0098.mockup.avionic-design.de>
References: <1343890270-13007-1-git-send-email-thierry.reding@avionic-design.de>
 <20120806073811.GA3261@breakpoint.cc>
 <20120808104629.GA20296@avionic-0098.mockup.avionic-design.de>
 <502252C8.3090600@linutronix.de>
 <20120808120737.GA5433@avionic-0098.mockup.avionic-design.de>
 <20120811172638.GA9440@kibibi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20120811172638.GA9440@kibibi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:rFa5i8afzeVJFLJnN8kCSizDh46Fp44hG7AiZk82NXY
 weLkrdBJ75OJnsnPx7uQ+qDhL3ss7HaFDRBWKiWgKckLgmoY7b
 GVoWPMnXfNZrx1ue6Eoz9ZrJdmmASQz3fPrTwTeEKsImbzsWBu
 i44/JG1nwbnrcavA0BJIK84JZZVQHUPSLmNvAz0ZmJUXqwmMHd
 v0vPqfQ6cAC+Ls3bsap49yPF3Cz6iKWTI9XqRDg2HgDkjyWN3L
 sI+TjwqYZmTJA2cM0oBY52bWOssL7eBWd0MpI1kL0fOt8Sw+GZ
 hAfiXhe3KJq4Wc2tyVVRQczJMkijq/OHkVHeTMPPjRHxK8CBzC
 t1bSgl0LZyHw5J7bp+JJNbFTKLN0x2ON6unb5xzNxBrGTG4mJO
 0m3T4g3xNBjlk1qoLA5HFvP6elfYI6EwEX0+tjbwn1wcdFJQ/I
 hKUA+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 11, 2012 at 07:26:38PM +0200, Sebastian Andrzej Siewior wrote:
> * Thierry Reding | 2012-08-08 14:07:37 [+0200]:
>=20
> >With that in place, the driver code can match on "intel,hpet" to catch
> >all implementations and use the more specific entries if quirks are
> >required for the specific hardware.
>=20
> from http://lkml.org/lkml/2011/2/16/350:
>=20
> |"intel,ioapic" is probably too generic and can be dropped.  Newer
> |devices can claim compatibility with "intel,ioapic-ce4100" if they are
> |indeed compatible so that device drivers don't need to be modified.
> |It is better to anchor compatible values to real implementations that
> |try to come up with 'generic' or wildcard strings.  Ditto through the
> |rest of the file.

Oh well. I've seen just the opposite used on ARM, where you start from a
generic implementation and compatible value and use more specific
compatible values for device-specific quirks.

But okay, the hardware that I use seems to work fine anyway, so I'll
just leave it as-is.

Thierry

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQJ1GjAAoJEN0jrNd/PrOhY4wQAKQubcakcaZktIAZDMcCMDRX
SPuFigfnE9O2L6HQ7P9qlKT/SAh8/dkK1mK8dviJc4B0hD+HB0cYynmOdSGY2XYj
e9oN6jeRD/KCZu5ZEGD/hG5/mHiJM16FTbHZiKkZ+cMM+Bnr2TkD34XQ6BUs7o5m
h5TC0cL+hRU5OFkWetGca+c9fmD9yhiSc3ygG15T898r3zwo5QiDxklgCYUi2QWw
xt+b323PIDd0yQ+bunT8dr0ngL+X1irp3UxkjWbes8e4X1utKuCwEvBna7RnJuT3
lng6i2+hwr2sUA4C/f0AkwN4lzVy4prCJBaPxmfI0Oj76oCXx1kiOZYRmnVGNnBd
Ri5viPs9qaEC4bXgsmKk96eE0ITAh/cRBVLo8iF5Lx+Oh0l62wYeMa/AterbbxT7
BWeUCPn5Yll8t9vrOdMJlSMLAz8LrT2nuB/WNfL8rc3vkUnBo4NQZk3SRv1L2Vux
tu5CAE0vNvyKp9Ce7MqJ2y/vmLZi1FUD8li9Qf6KtfBD2T2gM1JiR/BSDAO6K/Yg
xak0TWz5Idl7yKGHd1EmNId9E3uHg3mklv25lSMCaQp0OmW31n6YlRWro05Ppfg4
fQ+FakxDGDnfaszf2GBbtwG6N6FWgsONYQHVkHgAtT+/HaDOopsA2jjUE5+YHDID
S5DwvcHbUXwOiIZ6R57F
=VnBZ
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
