Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab2DDRsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 13:48:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53172 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab2DDRsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 13:48:39 -0400
Date: Wed, 4 Apr 2012 19:48:28 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clkdev: Implement managed clk_get()
Message-ID: <20120404174828.GA27171@avionic-0098.adnet.avionic-design.de>
References: <1333403385-24133-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120402215341.GL24211@n2100.arm.linux.org.uk>
 <20120402215927.GG3160@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20120402215927.GG3160@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:BxIVKSVua2EHqeZ1zKhvY8FQiDDnUleEbT3CgShVaNc
 WED9SJbhfsvL2IVZ4HAUkCvoMkd9LCayD1lrXvSaWs7bhdpun0
 eyksrHNTP7E9QikMuTt+qS22KRfyZLT1iV3i02LPXP1UZNs3f5
 mKSIR4cn5TmYveUDzmsbd0y040dqFLN/PlhFOyonT/qgLjtOJo
 nBXjFSMBbdoFIMBj1TeD+qDttwVIirB09m6HeNV7b16iLbgSQA
 cHFk/XK9+sbe2IJ7p4yo6bZfcnMuXxx8UUJsmjaaT52T0qZ3q2
 UIFyryCCGB7RSLbH67AGhXj3ePRpAI1rpItYHds9IEDTMF5PoM
 lAstuKLX7dfDB5aIuQzKiF1ug6k9Y+tsr2MJjXOu8kyQviUjNs
 5riqQ5QZA0DUGs7GaqZIMOrBxwdC7Q+MEc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Mark Brown wrote:
> On Mon, Apr 02, 2012 at 10:53:41PM +0100, Russell King - ARM Linux wrote:
> > On Mon, Apr 02, 2012 at 10:49:45PM +0100, Mark Brown wrote:
>=20
> > > +CLOCK
> > > +  devm_clk_get()
>=20
> > devm_clk_put() ?
>=20
> Yeah, I noticed that immediately after I sent when it turned up in my
> inbox and have already fixed locally - it'll be in any future version
> I send out.

The kerneldoc comment for devm_clk_put() also needs updating in case you
haven't fixed it already.

Thierry

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk98iWwACgkQZ+BJyKLjJp/QrgCdGFMGQBfIE4Lt+Zs88yCr3R80
/EoAnR7Ft7MCSlTZDMFKHqAZQv9/sytl
=+iSK
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
