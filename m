Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3ABNhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 08:37:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58698 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752691Ab3ABNh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 08:37:28 -0500
Date: Wed, 2 Jan 2013 13:37:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] drivers/pinctrl: grab default handles from device core
Message-ID: <20130102133726.GD4627@opensource.wolfsonmicro.com>
References: <1355343907-11535-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P+33d92oIH25kiaB"
Content-Disposition: inline
In-Reply-To: <1355343907-11535-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P+33d92oIH25kiaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 12, 2012 at 09:25:07PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>=20
> This makes the device core auto-grab the pinctrl handle and set
> the "default" (PINCTRL_STATE_DEFAULT) state for every device
> that is present in the device model right before probe. This will
> account for the lion's share of embedded silicon devcies.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks for doing this - sorry it took me a while to get round to reading
this properly, the end of last year was very hectic.

--P+33d92oIH25kiaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ5DgPAAoJELSic+t+oim9C90P/2wLSI24Qu16IUUFQBAElRVz
cOZlMBmTQzEFHhStKaXXVlrzweC8cDHFznHd8hkOcmAqcQqRNdHRt2GkL0hd2yIg
0zVTEa/WJN57ZXte+VoJlQ4iyoFL+MKVY7GaP1kJYRpSuji8PWG39GxMNBcDEyow
2mTANKf21PqQ20ZCosEiOQZfVc8JCyl9JuXgMI8cJM5s8Wc84dxCc3z3LMo0UPRS
DON5PKfFnkoivclQMIjJnMqUMqhakAQesGY95VOGxaHf4UBUcFyHpmryeII5+WWS
SV3540cB1CFcPP/5NN1ykjaFWmzsrO3FRkjzT5u5lQr7182YrrA7BqY3XEVB1VAq
FqBTZLY61U+0XsQKYfOtqmO2i1wsinLQeATAVj09mSgAjjLkpcyA0OLPvqpiLRwa
9PLvyMWpmOipOaQFeWWtrxdH2wg6n/fueF9bRxLgsiyVn6HGYEr2vESGr/FHjQUd
o94y01u4sqvq7YEufYDZLthSD7Ap4OwexyHKRdhDRL1ZR9aT1luJcs5YhjLTjPTy
XOIEk2ZDlhG+CTO2ohEJu8IMT6eJVc0R+9daYCwrCA5/phhdTttuqQsHynVCR/SG
RHd9V97uzQFDp5/+KbSbL6Na2EFtYrt3ChbqBDr5P3IJR93bAU7HzSat2evAX386
gihOndSlJZT4hmMWIDx6
=EUym
-----END PGP SIGNATURE-----

--P+33d92oIH25kiaB--
