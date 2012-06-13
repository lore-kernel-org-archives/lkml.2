Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2FMLvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:51:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35605 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753952Ab2FMLvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:51:01 -0400
Date: Wed, 13 Jun 2012 12:50:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 3/4] regulator: wm831x-dcdc: Convert wm831x_buckv_ops
 to set_voltage_sel and map_voltage
Message-ID: <20120613115058.GJ4545@opensource.wolfsonmicro.com>
References: <1339467650.22991.1.camel@phoenix>
 <1339467789.22991.4.camel@phoenix>
 <20120613100342.GI4545@opensource.wolfsonmicro.com>
 <CAF+7xWnQNGL8Q0mCLMTHrUnW-cbOuNLydFW+b6Nws_Pg-ePUJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9aCKuHbn5v2q3RVc"
Content-Disposition: inline
In-Reply-To: <CAF+7xWnQNGL8Q0mCLMTHrUnW-cbOuNLydFW+b6Nws_Pg-ePUJg@mail.gmail.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9aCKuHbn5v2q3RVc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 13, 2012 at 07:41:26PM +0800, Axel Lin wrote:

> Or do you prefer I chenge the prototype to:

> static int wm831x_buckv_set_voltage_sel(struct regulator_dev *rdev,
>                                         unsigned vsel)

> Then the diff can be smaller.

Yes, this is the point.  A huge proportion of the change is a cosmetic
change for this rename which makes it much harder to read and review.

--9aCKuHbn5v2q3RVc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2H6NAAoJEBus8iNuMP3dU8wQAIbJAIElRn8vYgeA5GJ+unGA
9NZz3+I+rEAMZGxVxW10OIBFmqExr6eGQQgUWqtpp372A7TJpZyVBol131glEwuI
rXe4WNuC/D6MP+aBhnEpvW5DPoE0GlJd5JhmL7Ooa/ObmxtOV64D8kojXtsk5kj0
KwiAGsWKwNcXG0geSOxxEsyouIMtbVp+e9Up83Vk5soiKBAY7Ynu8rJY1bibbm2G
UmAUoqjXe4hP+IJXWxnYxiljYDqkwKg4RSnyXX1wik4KGW4Nfk0+hhS7SuokoDQx
V4JD2flTquz/cIWUuqn1rPwfOb5Nov9ZhBVPaYVUgdnJ2UjBCeziQ6DKDQTQL395
uPxq0Go4zoe4nlrskkZVdkWj/HNndmERN84dg/r993c5p9RJi0jW3C50brAFh1bA
I+s3K8vB8ahgAwiO62NrBSctNAda/mAjyXnLXgGppOkxmOQCzI/6wv7Zddv6CZZu
rFYTVzsrXVZxGGDXdztaDZOnlmUoGwcnVXyKQzInucmsCEUKylPGKnWtkkkWO3aW
vvsYrKNQJFfwFUX2PPZmqLKwh7WB2Js5oNZ6dKoxikBdmOLUonBp1gvbqjq4OGVA
akWZ47xAZFb5VEba4qqWXYM0Iji3PENxJJ+JBkLvhwLSaCVHMvl1yTeIQjQB/vvf
kbDIxXNP/UPj22bMqpfA
=3NB3
-----END PGP SIGNATURE-----

--9aCKuHbn5v2q3RVc--
