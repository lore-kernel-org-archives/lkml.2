Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1LNKET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 05:04:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59747 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab1LNKER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 05:04:17 -0500
Date: Wed, 14 Dec 2011 11:03:38 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Ryan Mallon <rmallon@gmail.com>,
        Bill Gatliff <bgat@billgatliff.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
Message-ID: <20111214100338.GA18348@avionic-0098.mockup.avionic-design.de>
References: <201106301441.24493.arnd@arndb.de>
 <4E11994B.7070103@gmail.com>
 <20110704124318.GI6069@pengutronix.de>
 <201107041607.10265.arnd@arndb.de>
 <20111207085339.GA7970@avionic-0098.mockup.avionic-design.de>
 <20111207090734.GN27267@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20111207090734.GN27267@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:fQmKwz5h7J+/r3bnY3uQGBfQhYNgQFsNzOaVUfuXALK
 wyV25ZenL1lnPZfRgsbVLyeHbMBzt1zJ0rtLbPOZlMyIigKRi0
 qMlUb1WFtFbm/rVdQePb1IyK9CeZYhefVghliOlgIWvbvysrAK
 PYxbX4vihu2/gcUvqymE0NCJPk/K8m2qn5M9Gnsrex53fY5Kbp
 QSG1tSgLQCVxhXw/aSkxxacJovsD9vax1Q4aZDgunnwvkc1qat
 x+k8TIncM5SwSHf0x82ELWGRiTMj2pixKTMA90f/3bJYfyNIgL
 XKa/REkwwSNGnW5vQ4ttDXM1wrcOXfkP4Xk/Mm/S4jdezkjMPy
 dV9OFH8wU51Y5/vhXuPRKpH0s2tOn+Ixvmd9aiYRVVANLPvDjp
 N7PlilkliLwzmnQD/Nk6GrPEbs2LzCDvXI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Sascha Hauer wrote:
> I have a branch which adds a basic PWM framework. It doesn't change the
> pwm API at all, but only adds support for registering multiple PWM
> drivers. All in Kernel drivers are converted to this new framework, but
> except the i.MX driver all of them are untested. I'm quite confident
> that the drivers itself work, but there will probably be some Kconfig
> related issues which I wasn't able to sort out. The corresponding
> Maintainers should probably have a look over it. Feel free to post
> the patches if you are prepared to work on the comments you receive.
> Otherwise I'll see if I find some time maybe next week.
[...]

I've looked at this in more detail and one thing that irritates me is that
the current driver API requires a driver to register a pwm_chip structure for
each PWM it can control. Wouldn't it be easier in such cases to just specify
how many PWMs a chip wants to register, much like gpiolib does it?

Thierry

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7odHoACgkQZ+BJyKLjJp+iIwCfaRR8krEsdQp0ZX+lkV0ERppT
jQoAn0JrNoba47tl1mldn8lBMWImecZ+
=58q/
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
