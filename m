Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2L0W6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 17:58:04 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56431 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab2L0W6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 17:58:00 -0500
Date: Fri, 28 Dec 2012 00:57:25 +0200
From: Felipe Balbi <balbi@ti.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-i2c@vger.kernel.org>,
        <naveenkrishna.ch@gmail.com>, <kgene.kim@samsung.com>,
        <grant.likely@secretlab.ca>, <w.sang@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <taeggyun.ko@samsung.com>,
        <balbi@ti.com>, <thomas.abraham@linaro.org>
Subject: Re: [PATCH 2/2] i2c-exynos5: add debugfs support for registers
Message-ID: <20121227225725.GB12665@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
 <1356434755-13702-1-git-send-email-ch.naveen@samsung.com>
 <1356434755-13702-2-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <1356434755-13702-2-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 25, 2012 at 04:55:55PM +0530, Naveen Krishna Chatradhi wrote:
> This patch replaces the dev_vdbg with debugfs function calls
> in i2c-exynos5.c driver.
>=20
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

merge with previous

--=20
balbi

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ3NJVAAoJEIaOsuA1yqRESSoP/iATZQfzkhMqXfVI807r2hMH
1DrbdCTDI7rblYCMx65dv1oaa+FkAiwug9kgCIwDSIMVnm4hkxpMkjBPXRhkFYLy
kLuVbe9ciEfs9CpWD/EJvkyDJX+xyk1hTNpeMiokUYHR5FrBC5iuWZE9Ei1Kq095
GjamTGKHrDHLqJGwfrJ6IAPVOY4eWbVQtF1lz8oTJruVQQ0o1nU9eQB09t1YhgsU
fNJoJbFn1lREF/C9P/At2wY4/aJ/zw+yPIyr//HjmJx338TgVqW8E1Vpey3i+Ha/
xIzzN+pzNO5qHDZfMIp28JgKKXWyoA7SofxWgaZr3zMtZbGlRwYxXtIVfcsTeFyy
l/5HlFtkVEjTQPrAXVs8ZDCLDEwlmh6AsbyFgnT/MCNGX3G4ZFmtADnM88hDFi77
8sP1W8BNnrpoCJ5rv8cJPVTFXffYfiFXY1Ftm0J0SVW/vMZ8t2l9GikVnImugFr+
NvHJDaLD1vgl7eSlOORwpgn/XEgJC3+fd4hEkq28e1a6K6N2If65m6JrFOxI/e8T
eEqBwt6coZjXYCuxCaqkdjW6duTumWEJk/2zPX27oFglgVvR0tJ2cjbSBqcwDdl2
Zoa03PCYRSRVwA9gEdnDCzkFoGzfOEhqRVx7CPwymBWKptlCHj2akiVe8/NVO+uv
kTLMvNlZA/rsUEC1kYEF
=JCHj
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
