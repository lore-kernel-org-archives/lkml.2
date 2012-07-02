Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019Ab2GBUps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:45:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:65039 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267Ab2GBUpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:45:46 -0400
Date: Mon, 2 Jul 2012 22:45:37 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH v3] pwm: Convert pwm-pxa to use devm_* APIs
Message-ID: <20120702204537.GA16287@avionic-0098.mockup.avionic-design.de>
References: <1341136934.3061.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <1341136934.3061.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:mAqWDLL9YBAFx6WSJPeKyJBW8xE82ZQTCoYzmZSk4yW
 OxVbr0OG4TvvslhiFlllSYJ8L1w4v/n6z//RGoaTXpquC4L7SO
 kema7ohEZCdF4UcSsPAIEeT8KD3jKv/ysDul7nPhMZxtq2HuUY
 T79mF6LSc1QL+OZWvmwG8wXvdaw9jHdcJvwRbnu7uLshsIUiYk
 XPA1J7AuX2mAmEyic2EwkTrSk8qR6nKsedifrK0wVqTwpirF2K
 AI/TchIvBwa32zCUTIF1tcu2H4IEzV/p95B081krstBulZU0hd
 fGUTPtxT6beqXEKp5TaS9vsU28gjh8up9/ytuou1UuOMMhzh5w
 tT+iRMnBJSsuuBErtcH94AypDZYh9bvPYHEb9we7suRqaJxbco
 zQngbkQtsD31GqJH69xIHSNmIQUsHA9+IQzTQu0DnRmBTENLhy
 Y7ecr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 01, 2012 at 06:02:14PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/pwm/pwm-pxa.c |   49 ++++++++++---------------------------------------
>  1 file changed, 10 insertions(+), 39 deletions(-)

Applied, thanks.

Thierry

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP8ghxAAoJEN0jrNd/PrOh3A0QAKd71JiyVcWnIlbDSsEwvGdy
s/fUKJKvJihjq52P/UnI1KLyfmUPsi0bP6NLoigYQyh/C5fMtOlkIaq7+NZnzC/C
2IhEHlVroeNK9oszVGqVO4mVvL7vH6wW7F7WocnRqJhdbRyJyDL+E4j2IPixwhrm
agB0Na4SpNxlSJiqwM+frETEcHnrbtZZdjxIybyXxwo5SsKxWJgA9K8N5NSUnPcx
6SENy+Z3sLvjIc/nm88X76dcBvWNeXp5bywEi7SvS5VQJIgB4x98teXu87qvxlRS
FchPaw1ctloduotZFW4WTJ3AGQxM8l5rrduR3D3cZ68RkgQyxKNF2CknhvKFI8a1
Jql2aoewq/n0QKBKqq7B+CcjAenHJACmaHfoU/wuOday1AXpzJzBGzU4p6twXMEa
N1D7uj3CsAV2oiD7LmzVH9wrLXwVHhgAVWnOo0riaIC7vRG5KcVQQn+d9gI+tPhz
Gz6wOpvQ+LvOW3+SDN/w9g+I5sHyjc5oH0gScmwUcPmzYUbhtyNMi5wYTK/jCFdh
e3WzNWJdcl22B6L1xPW/yq2SE8W5yRNfvZQ/RkpY3DXBzY2tJB1Lzcyw3OrrFwJC
zgl2au7HsZrWaRHFdsc14TFC1+5TYECzDosH0+p8HYAQRyFgTnvx0bHUGkwlmQPX
VRF7fh/AMFF9gjlyQdvL
=3bnP
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
