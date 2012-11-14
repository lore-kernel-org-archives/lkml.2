Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab2KNEMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 23:12:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48487 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932268Ab2KNEMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 23:12:21 -0500
Date: Wed, 14 Nov 2012 13:12:15 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v2] regulator: core: Update
 regulator_is_supported_voltage for fixed voltages
Message-ID: <20121114041213.GR4415@opensource.wolfsonmicro.com>
References: <1352865266-25286-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EguBBKnZWdUQS9Kz"
Content-Disposition: inline
In-Reply-To: <1352865266-25286-1-git-send-email-tushar.behera@linaro.org>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EguBBKnZWdUQS9Kz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 09:24:26AM +0530, Tushar Behera wrote:
> Commit c5f3939b8fe0 ("regulator: core: Support fixed voltages in
> regulator_is_supported_voltage()") returns success when the regulator
> voltage is less than both min_uV and max_uV. Modify this to return
> success only when the regulator voltage is within the specified range.

I applied a version of this from Marek yesterday.

--EguBBKnZWdUQS9Kz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQoxfRAAoJELSic+t+oim99jcP/1h+bI/DIbsX15eEj6U+0v+n
fT8xL/HpP2X2P76nZxspfRXcakUwQHu33mG0S9HmKAwrfxRlfAJsMVXLndcIvzCR
+RY4A3Kjh7hM4mtL6koChwvIPKd1BsAapTxw8xdMvat6nHGmBid2y76pjKKSF/Ea
6BkLbT9Q67y6asFn+ydh5AA57J/+F255V0nIuF3vFq/41jhU5jEmdY/RRI4VtH6K
Hzs/NeOrzhi6Sv+JeAh555A3cWzawE0KCCAFAg9UGt4jOtXJjInMgP6+iDwE2BSv
xZndtVf+HghoLMCh0eWsxai2F6/kORik1tcbBWxPXswOs2BerKdcA9aeKy92fTgS
KvC6U1XkcNLYLv7AufoDmm4gIvavLdsxlZBd51Vd3RoWqGkn8UZK6xgv+hby3IiK
jVhZ8hcr4LTtkW7tvTZWkjJ8R+OZpfZHs5KALfU6OzDJer1gGfhOgG0T2pPhT1Fo
NaITKczWil/AYgBjmR6kfV2mQaXQU1M6O2C3FZcY6V4EDvbRtgVZUVyOtIZNSLg+
d70NustBssUciN0KnkXM8kvanofaScWpFD1qO2El7xrwFOWvj2Fq1EZ56gHyGjxy
EOHChpQmWkfGX8x47bG2+J7oW2PIbZPlUOHradoYVu+IPksTZZlvv2+m+PaqWbt4
qwH1y6Qq+1x1Tl3keXNT
=5B6f
-----END PGP SIGNATURE-----

--EguBBKnZWdUQS9Kz--
