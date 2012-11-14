Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab2KNDFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 22:05:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57682 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932478Ab2KNDFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 22:05:14 -0500
Date: Wed, 14 Nov 2012 12:04:14 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] mfd: add TI TPS80031 mfd core driver
Message-ID: <20121114030412.GO4415@opensource.wolfsonmicro.com>
References: <1352646721-8350-1-git-send-email-ldewangan@nvidia.com>
 <1352646721-8350-2-git-send-email-ldewangan@nvidia.com>
 <20121113074623.GL18224@opensource.wolfsonmicro.com>
 <50A287F2.4070008@nvidia.com>
 <20121114012217.GE4415@opensource.wolfsonmicro.com>
 <50A30381.3000609@nvidia.com>
 <20121114024529.GN4415@opensource.wolfsonmicro.com>
 <50A30986.1000507@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s9kDAZ2EyO0AcRYa"
Content-Disposition: inline
In-Reply-To: <50A30986.1000507@nvidia.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s9kDAZ2EyO0AcRYa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 13, 2012 at 10:01:26PM -0500, Laxman Dewangan wrote:

> >This does not seem sensible.  Why would this be optional if it is
> >useful?  In any case, what you're doing in the driver here is clearly
> >not the way forward.

> I was thinking  of adding wake_enable in struct regmap_irq_chip and
> decide the wake support based on the value if wake_enable true or
> wake_base is non-zero. then wake support should be enable.
> The wake register write will happen only when wake_base is non-zero.

But to repeat my question why would this be optional?

--s9kDAZ2EyO0AcRYa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQownUAAoJELSic+t+oim9F+kP/A/DluaSXB7s46B6MVZ7Wv4F
FZFgS7ql1HVsTpfI88p5pvqM+q5RUG2bXpkmNUWe/sPz87Y+T5CPQdsMtwqwaJwf
LUj01rL/UZpiEJb8ESmEty5xxAcHIJ2AKiteN7IEHUnRTtC4wvMcnmU6dQycgv2j
YjIi9SFQxjfHOawPMJHN6qFkt0kBXwboKE5WPRhQX0jU6dQH1od2BfIj0RxqLlHQ
h7qWE760Bd7pB1TYwPazP9hKGNS++zsw0HtrSnCqtToAsecSaNgtCwLKnKzJefsj
Uk3xEsya942WVc0DjZVCnHP34okSkgZ0i5iOdjr07glS2d9la3z1QtkTcFHtRvOq
EApX7UQrt1KqeO62TcNgNhMXOffW520/VSPJuxJ9bb2sln8m0Oh3VlH+46cMCH1Z
QZ6tbAJxAyWTjHeBpZvHS92MnRbogMc1QaY/OVyNGvr3+xb9vYCYlkzkMdxoxCAN
I4tM7DxE5nNIsjvSgFWLLpXLLagdVcwLLRpDrfBWlrjo4WOzPdySj1sDBV2/OnaB
q5bfC/cp+y2gNgJjihxVJe+33aJc6j7r48AWUyrh2ROVmAR2yjs9kEnFaK1bUzLC
OAZAwKAQeQtRPfxsVklh9sB8UgenfokIVCy2xQg7fPn8p9YQ/AyjrdT/GAeHbfUw
IdxFx38Vt2dwseS5oVHG
=B9yn
-----END PGP SIGNATURE-----

--s9kDAZ2EyO0AcRYa--
