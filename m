Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab3AHKg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:36:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32991 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755550Ab3AHKg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:36:56 -0500
Date: Tue, 8 Jan 2013 10:36:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, patches@linaro.org
Subject: Re: [PATCH 1/1] mfd: wm8994: Use devm_regulator_bulk_get API
Message-ID: <20130108103653.GH4544@opensource.wolfsonmicro.com>
References: <1357633882-5191-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17/8oYur5Y32USnW"
Content-Disposition: inline
In-Reply-To: <1357633882-5191-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17/8oYur5Y32USnW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 08, 2013 at 02:01:22PM +0530, Sachin Kamat wrote:
> devm_regulator_bulk_get is device managed and saves some cleanup
> and exit code.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--17/8oYur5Y32USnW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ6/a+AAoJELSic+t+oim9YpAP/27SrJCgXwkrs6le0O816gWW
pXBgYxBgUU8VFW0n0OubXHqJQ47KpT9/mInspRT5KNx9OZnk9NL9bQhCjqKLfFLj
uA8k+5M+amdfLBW8OYu+fm7ZO89d06mI+1gAx7j4Rt6hsWx/uOOtCtBQJVfxRfcJ
Q62md5POwMeDwQc557XAkDd9Gn8d44Fwkf2CG9NDSzRRNusEQZs1ErNqYqkq7PhS
0islZB/kvfA0AAZF4Q00//0s92AQBPgAo5gjxYEMk+pr2+zt61rvqo78q4NeMqET
CZ3Jh1oamTP4Mow4EhRjVmbihietLer1dnUEAQ2rxA2BwfS652YyNkELagq8WthQ
mrr7h1kpmpcQiHND/FHiwQSExfZ/Df32Jjx5I1ZF6SnQ0iG4qIMYJ1JfV4Xr61au
7yG11zelT5iICZNGwRXbxECJjb+tTkdTn8NUPGYG5DEA/Ijr+sFqlYOyUKHbIM66
X8srmSVbwQRL0NtUp7TkYoC3L/cGITUg6b2j1XqyIdy12FEgTFJgouypYUBK9dzT
zuYYKl7w0DPv/B2ySo85kNt8X9puK9y+K2qbFVElXLpONSgw7QNQd5tauOWMFjRB
4nbr/OGvwbfhoB1QY5MN9GTJRTccO524IF+3XRULxRGffSX+CpGZSuRmyi41D+je
JxlTP3L03gld7Gzgsz9l
=gjCB
-----END PGP SIGNATURE-----

--17/8oYur5Y32USnW--
