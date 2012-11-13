Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab2KMGsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 01:48:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44586 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564Ab2KMGsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 01:48:16 -0500
Date: Tue, 13 Nov 2012 15:48:09 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, philipspatches@gmail.com, patches@linaro.org
Subject: Re: [PATCH] regulator: core: Update regulator_is_supported_voltage
 for fixed voltages
Message-ID: <20121113064808.GH18224@opensource.wolfsonmicro.com>
References: <1352458309-18141-1-git-send-email-tushar.behera@linaro.org>
 <20121109170918.GW23807@opensource.wolfsonmicro.com>
 <50A07E8B.20902@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="64j1qyTOoGvYcHb1"
Content-Disposition: inline
In-Reply-To: <50A07E8B.20902@linaro.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--64j1qyTOoGvYcHb1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 12, 2012 at 10:13:55AM +0530, Tushar Behera wrote:

> In that case, we should modify the test condition as following.
> Currently it passes success when the regulator voltage is less than both
> min_uV and max_uV. If ok, I will send another patch for this.

Documentation/SubmittingPatches...

--64j1qyTOoGvYcHb1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQoe0fAAoJELSic+t+oim9olIP/iI0fGZWiBsRYx3k8j1VsCQD
gS6rrvckneVY8h2Q/Nuk/yL3tRb1CU+8/m1IR06ruuk6ulFuOn/vU6JlHJwlN1Y7
DyGUf0ogHFQH+ddAmxSzLxgjvY+ZWEwc9fZpGQN5Yaxe/9s3nfC+zK7v3byZu744
BsAF1hjlS1fQ99ya1u/WDPfSO+yPffB88k+Y91+ncc4Ju3s6XlBtCuHIPjA7CpN1
9VosxnpmQnkhGnwgWKtIa4Fce8eNh74AGH09jZsGXKiMME1sS/PDJEVEoHCSEBcM
a0G7BxQBmJCw1eMV69Qd8PY/UcFzI15pDoV3Pi1uQSUggV2m+WmEJxxWEBg9zvWQ
juFA61ey5ESUtSyhdLUsO1UROD5zWiu9ygVO5Y/UZVLMKZF2C5+VcazVBG6DM1NY
zElmZX/CMAQ8TEWWtUTILJGhu1t8x6O43+FK5gyMcHyWNP9awwn2DYD/LircdqKA
9Bbr+V9Ayz58MdK2uTvohxRJGZL8d/ZONVKg6jDj0HV41F56b1KmEqrvhMxbHkWd
/Wswg13MMo7vAOiGGCLoKhRrmQ1GMabGAKWz32xVR24dmKMH8gTvawk2rZSWFzV0
m0+wjXAnoYdA5h+aDNLDSDOYqHEFisLP51RaBUzrOsM1sTglk41fTBnVd2Rq6xvF
shvgsN1rbQjH9Y2zTOkY
=KBn3
-----END PGP SIGNATURE-----

--64j1qyTOoGvYcHb1--
