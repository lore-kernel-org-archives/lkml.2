Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab2HTT6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:58:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53693 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326Ab2HTT57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:57:59 -0400
Date: Mon, 20 Aug 2012 20:57:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@gmail.com>, Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regulator: max8907: fix compile error when !CONFIG_OF
Message-ID: <20120820195756.GP26991@opensource.wolfsonmicro.com>
References: <1345477150-25933-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/DkgDsqJFFamjKX0"
Content-Disposition: inline
In-Reply-To: <1345477150-25933-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/DkgDsqJFFamjKX0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 20, 2012 at 09:39:10AM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> Fix the following:

Applied, thanks.

> Note: It's possible that the MAX8907 PMIC is only used with Tegra; there
> certainly is a reference to AP15 (an old Tegra version) in the MAX8907
> documentation. If so, Tegra implies CONFIG_OF, so we could just make
> MAX8907 depend on CONFIG_OF and remove all the ifdefs from the driver.
> That said, I'm not at all sure whether the MAX8907 is Tegra-specific.

I think this would be a step backwards, if it's that hard to make DT
optional we ought to look at the DT infrastructure.  Otherwise build
coverage is good.

--/DkgDsqJFFamjKX0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQMpa9AAoJEFJkBDiqVpZ4G2wP/RuqgBYSIiwusoIRlHk3Qf3L
AEN4a5Eo9hgTZWBM79X4OG8vCgHr5DergtUB7S0y4dxSqvetQST9T7wRqdMINC25
sTHZa+239DrraWkBt78/heDwqmtku4T4tKm4lpMOgosNZNsOmQRbLmlbt0lv2l5U
S8/3otYAFyir4x22KOPWXtdqkTTz+RB76ZLu9CcKLLn/8FYCGD5OFPlpOXPOHOSp
mVCi/khGuYmMDsk2N499daNZ89+kbvFOxGwj0tqiE/X1/i4LcURnZzcbctq+X+GL
YloBL8DoyLY75Q6kdx0jlAx7QnwKnCNNIWFZXLUKPMFqxIKo3u85rvXE1tCUCJBW
NDIGxk548bm4+vxoYUfLn0K10avmkBYaQVqD2ik1dmE80fak68xOz88W6oTkWjkw
HjWvCihUgamnDrMg6Kf8AGX+GE2VYRAcFIECXE+otNI9vK3HgfDmbFQ3tdK08g+k
M7BTYeSJq6BnKTHGIfQPA/JF+jzNBPuRoJkBeM0jaeGxLF6VEL7GMcgrh5hcT34N
oEavU1LUfvoySuNfI05kz3tigeBHRj0UzvTGMk+JJd/Hri3RLMTcHdr3fbwkl7hD
uqFbGSdxxpAyXlhAygtJHcpBjjYFUkZXsPiZq7GRAeUDzWFXeQrJF0FEfHhelWDM
QvY+9nKrMqn3nT3YNByT
=9J4v
-----END PGP SIGNATURE-----

--/DkgDsqJFFamjKX0--
