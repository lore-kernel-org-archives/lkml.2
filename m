Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab2CZRw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:52:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32792 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932903Ab2CZRwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:52:25 -0400
Date: Mon, 26 Mar 2012 18:52:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RESEND 1/2] regulator: Fix da9052 ldo regulator names
Message-ID: <20120326175222.GK3789@opensource.wolfsonmicro.com>
References: <1331812719.2471.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DfnuYBTqzt7sVGu3"
Content-Disposition: inline
In-Reply-To: <1331812719.2471.2.camel@phoenix>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DfnuYBTqzt7sVGu3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2012 at 07:58:39PM +0800, Axel Lin wrote:
> The regulator name for LDOs are LDO4 ... LDO13 in current implementation.
> The correct regulator name for LDOs should be LDO1 ... LDO10.

Applied both, thanks.

--DfnuYBTqzt7sVGu3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcKytAAoJEBus8iNuMP3d/b4P/RNhPYfwXIdObNLD5T3vKo9I
2ADlQOaqx9z+6IGovIV7k/8o3MMM9I38lPPiS0Tp44ihDv1o9yNySuslDSQY1l1w
PkCkVI2hgicCi2VB+LblncD+kOjXbSJA3TO34hg58Z2zn5CCWfc/AyGbUKnfJaqi
9hA0bHitDB17Nu4eMpD3wSzxOUUhIFU8FfiX5sFOV2UO1QPR+xRvAEC+ozD4RZuc
ICg2U+oFjyqOgTwEcCLp0Sw03XAst3hylE8IikaUG0YivNh+puHWWprCJNWD4tE3
OcjQM5koshkEeKrYkmWPfwekJeXTEJcHpbZYAKDlHbhh6tQ6U8+jPJli93rEhrOp
4mUyXkwLlgyX1WbcgB/yNR2XShmbIsEBtPVkWCEkIOlOWbWYhECKYG0NKR4orL+x
eIRWhegj/VfD69/zXhDwOryfcpKy7twzcDpSrxcS2I/uz7ApbFlNQvvum56YYA0q
9vOfNCblz0FAQre0pk9FE/PDbR00AtAImhV3yahTsplbdXUwmulE6kYFeiPPgA5E
7YrKVhzUVmtf5xeipZpn/xw00Zv2Lu3+iXdEQZEYWq8Y+jZoVGTBPvimDXgmIaOx
UfChnJ0LfeTB0Y14q+qQqT2tNkji5a1BFhTemNBUMioC5y8/JE2l61C7Ur0zq26Y
mTscyxtKBLN6IllJbHN0
=g7SK
-----END PGP SIGNATURE-----

--DfnuYBTqzt7sVGu3--
