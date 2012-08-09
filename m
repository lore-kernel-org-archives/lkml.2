Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab2HIFrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 01:47:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62312 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab2HIFrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 01:47:15 -0400
Date: Thu, 9 Aug 2012 07:47:08 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: linux-kernel@vger.kernel.org, nsekhar@ti.com
Subject: Re: [PATCH v2] pwm: Add support for configuring the PWM polarity
Message-ID: <20120809054708.GD29806@avionic-0098.mockup.avionic-design.de>
References: <1343138732-12972-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wLAMOaPNJ0fu1fTG"
Content-Disposition: inline
In-Reply-To: <1343138732-12972-1-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:C0SFeS1f3oEasqlC7ALjg1HoSjKqM7QZjWGzEpYGIA8
 3mqv6VAHt8KJ96OlEzL7lbzV5gLcL6RXZ0oCD+qyBP8wp/GN+b
 ApHzsE+f05SX57V+ZHSho/+CVEj4vob++DK+LCowwYlWcLMmg7
 0w9T3ipJLtD8j63+qwecbd/L/8pVFom1jzVRf3UfiTgaKGA/By
 CYX697vVrPUcaRbw+CS0nWnUXtuWNhaKwKDBEdqN46dBBZNxqw
 Lh/EV5vBR4sD/V2O/kiwwNKSugPs8UY7lMgb1Amix8Qz50mql4
 HRO+0HnGhneBKuC+SANTno3llLb6xXomh4jWGbZ9UOIRmWqwYp
 QJurm6ifa4Ug95ZYfsVP5TsW71Aq/coKJ+lcTR/5gFSVcFef5e
 49Iw2JPcapRjMpyTpgqzWE1fZhYMr7xSY0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wLAMOaPNJ0fu1fTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 24, 2012 at 07:35:32PM +0530, Philip, Avinash wrote:
> Some hardware supports inverting the polarity of the PWM signal. This
> commit adds support to the PWM framework to allow users of the PWM API
> to configure the polarity. Note that in order to reduce complexity,
> changing the polarity of a PWM signal is only allowed while the PWM is
> disabled.
>=20
> A practical example where this can prove useful is to simulate inversion
> of the duty cycle. While inversion of polarity and duty cycle are not
> exactly the same, the differences for most use-cases are negligible.
>=20
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> ---
> changes in  V2:
> 	- Updates commit message
> 	- Provides proper comments
> 	- Removes usage of polarity variable.
> 	- Removes encoding of polarity in flags
>=20
> Configuring polarity to be done with PWM device disabled, if not failure
> reported.
>=20
> If PWM device is enabled while configuring polarity, disabling and
> re_enabling make it complex. Whoever uses this API has to taken care of
> the basic rules.
>=20
> Discussions related to this can found at
> http://www.spinics.net/lists/kernel/msg1372110.html
>=20
> :100644 100644 ecb7690... f0a1db3... M	drivers/pwm/core.c
> :100644 100644 21d076c... 354764c... M	include/linux/pwm.h
>  drivers/pwm/core.c  |   22 ++++++++++++++++++++++
>  include/linux/pwm.h |   23 +++++++++++++++++++++++
>  2 files changed, 45 insertions(+), 0 deletions(-)

Applied, thanks.

Thierry

--wLAMOaPNJ0fu1fTG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQI07cAAoJEN0jrNd/PrOhYv0P/js/+ysf0ZSVVoCNPXMQHcZt
zjnqCO3kA8d0GOG7fvc5T2RBAXFKa8XgKQfl3N3jXn4Uq1cH4116T1sRcOlPsDRV
J+r1j+UGyB3RjErME3FK5tsFDfK+at5x0St6lFtlNS1g/DVu6y+epRdYPB7cNskI
W9CMRgU9Z/6g8ax9/UQCnCZ6DTgFdLw9JMKV9dHRwsbD+L62ZlNXhsrjw2EqW4IF
+uxZrcn0QYzKFtLkVZKFD8NU7kNWkpXt1gtTgZMuUVkf88b64uezN9fCx7SZnPPW
zPd3G6fh+jeoAYL1khZrs70J9FpA6bp68FVOueYSXqedm/GHpxBh+/6Hxtg3YLGX
7PI7ZKGkNP4EhnNGaz4yB77yuqzo8iC7IW4LdRPDnTpGY6FQz/IJWCxmN7XQkLXC
orq5lIlTH53nzZG/XWVnh40oqAWPw3Rp83qu7Tend284QEIl1EuO0AOWt47HbUZi
odiEIK+oot6aU0Z7Tz3Y876MIfzZ+CaiNHCdgQg6Mp5YdHMLPsePfviH9tW1GZpJ
GJAG4c8mtJSWgMbKXEsgaEOLK9h5ng32HyKXFsC7NVXi7PULzgvjfeTeZVMs32+f
3zIWxgTBaBSqI285SzOnlifr0Xp7qn+NJgSda1XX0D43X1x8VgV5vj7jApHLjPoo
nJ4lAYk+DDu5Afe0cd4N
=1WHH
-----END PGP SIGNATURE-----

--wLAMOaPNJ0fu1fTG--
