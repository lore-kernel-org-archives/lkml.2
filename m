Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1KCWQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:16:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58152 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab1KCWQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:16:37 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH 0/3] Change ARCH_NR_GPIO into a Kconfig variable
Date: Thu, 3 Nov 2011 18:16:33 -0400
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc4; KDE/4.6.5; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        David Brown <davidb@codeaurora.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
References: <1320339647-30255-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1320339647-30255-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1352260.e85GnhUaYO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111031816.37427.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1352260.e85GnhUaYO
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 03 November 2011 13:00:44 Peter De Schrijver wrote:
> This patchset converts ARCH_NR_GPIO to a Kconfig variable as suggested by
> Russel King. It also converts some platforms to the new model.
>=20
> Peter De Schrijver (3):
>   ARM: ARCH_NR_GPIO: Make ARCH_NR_GPIO a Kconfig variable
>   ARM: mach-shmobile: Use CONFIG_ARCH_NR_GPIO
>   ARM: mach-ux500 Use CONFIG_ARCH_NR_GPIO
>=20
>  arch/arm/Kconfig                           |   10 ++++++++++
>  arch/arm/include/asm/gpio.h                |    4 ++++
>  arch/arm/mach-shmobile/include/mach/gpio.h |    2 --
>  arch/arm/mach-ux500/include/mach/gpio.h    |    5 -----
>  4 files changed, 14 insertions(+), 7 deletions(-)

i'm not sure how this is an improvement.  we go from declaring the define i=
n=20
the right mach-specific subdir (arch/arm/mach-xxx/include/mach/gpio.h) to a=
n=20
arm-global file (arm/Kconfig).  i'd think the ideal would be to keep all th=
e=20
mach cruft in the mach-xxx/ subdir.
=2Dmike

--nextPart1352260.e85GnhUaYO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOsxLFAAoJEEFjO5/oN/WB2zwP/3uuVpB9LiRaJ9gITTAeERDf
jIDMGt5Lrfpqt9hUJbVSP5/kDUAUbisT/eUxi8Tg/Cs9utsi4GvkCbgQoXNWR3Cb
F5QWtSXu7KNoUlfPJck/kh/iqa7bGgiuiA3DDeXAsVQjRESlQSKj4JsZ2LXvq8/B
M9qnOAUdHRHkEhaM6rx/ZG07EtbJjd0NaYcSEB81pAiYmdVHxSIneCouVqRklg/9
mXX4pviian23NN5k/tK7iehwVWhjcuXgOb0teWXi9+C+IYlOxFlwWEnURx8SxY4F
aTGcD5geb/TaWWJI0m1rKkwK0P5SpoZonp+C0Yd+DE/xlLJCeh34r3z9l+aGAAQD
zaML2wGuUiBBUev57S93uUUQtLhZQAoyc7/mYmfu0vzS2xCHN0P7s1vgx/pfW/RX
WZOYBMc+pToxIyKg1nGmSoVgchwMQJFSSXXA6g4kykvFWxCnyAz2cc+SYBMZ0WKk
wtD4rOt313lEwQPcFyuf5N6rGLcx49Pt9c3OK5UQ7k9eQ+7pFEfcSKxnAow8xkky
a4pK7QHZJ2PA+qF6u6Vv1Atge1zlP5hQ+9SPFqi6WUoR7JeUmAmRSkABn78nrfip
iLXiRVgsD7Gk2QIWUBAZRZTZPtvMe6BeiEQpw2iHmiYuq6nwuUlWfKK3NMGfmAkQ
xJnqYYRWNnl45gH+DlbT
=4so7
-----END PGP SIGNATURE-----

--nextPart1352260.e85GnhUaYO--
