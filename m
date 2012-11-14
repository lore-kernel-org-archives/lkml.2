Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab2KNBZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:25:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51487 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932362Ab2KNBYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:24:48 -0500
Date: Wed, 14 Nov 2012 10:24:41 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 RESEND 0/4] mfd: tps65910: use regmap irq framework
 for interrupt
Message-ID: <20121114012439.GF4415@opensource.wolfsonmicro.com>
References: <1352815439-26040-1-git-send-email-ldewangan@nvidia.com>
 <20121113195637.GQ27828@sortiz-mobl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6v9BRtpmy+umdQlo"
Content-Disposition: inline
In-Reply-To: <20121113195637.GQ27828@sortiz-mobl>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6v9BRtpmy+umdQlo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 13, 2012 at 08:56:37PM +0100, Samuel Ortiz wrote:

> The patchset looks fine, but it should either go through Mark's tree or I
> should merge Mark's regmap_irq_get_domain patch to my for-next branch.
> Mark, any preference ?

I don't mind that much, there's a tag in my regmap tree you can pull in
to integrate or I can apply things just as easily.

--6v9BRtpmy+umdQlo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQovKwAAoJELSic+t+oim9/GwP/ihPrLFR8LNQNwklIWGPVFBk
idVfrU/6DQ/mcOXV111n5/dck5F7J9Mwt8kix4aY/5QvBdohGzMGVW+Mvth/Nl9a
TJrtpr5uQfoNdr2wiKOVaykNlAjFIPJJfIld1m8Rdh0WTNWMkD2FsFWR5fjkvNsV
/8taqb+YYMMXPY4unneRJXX5FJLiV6ZDV9ZNXPUubqdLIB92VNz34CuALtlySN+k
RHfAEDzjHcrjTrpx10adg7vIhxuakeFRDlqouOPgSXgHFTzdSA9w69N5IdwwwoSA
W1nqDqpDrLzE5SdbHQFSOIk2jKQ649NqbgxVq8kKifz2YOcbLyOQVG3zNJ0bTf2G
jUw9ioRtht0X97P/o6iSSxh/78QtVdZWxFOFtJmnL3vNpC3Iu4CSeD8Cp7t40BZk
o2d7PYdBZzbVW31yY/BGpDdGZuIsGA/NXkhy0CzhUKwHYRVD2aPISVQFai6TbOv+
qwoyjwm0uF2C86jIvu1SVwcTJpJ2GiEk7M+mFjw/pLPjQ6LD5oaxWFnLSzhGI4gv
lxKSZhlNcR3UquHgip80J0mp4sGqWzFDGmqSlgdU63aktR7BKViavFV/7XK7bddu
CRh/mbGqcUE5BGGCqbbZr1Y54Q8BMmCE1Gmcg1IyOI/7UQdZHWXKeNfQKPJf1wRo
v+rxkHPP3Qg8E+9eG92Y
=9XPl
-----END PGP SIGNATURE-----

--6v9BRtpmy+umdQlo--
