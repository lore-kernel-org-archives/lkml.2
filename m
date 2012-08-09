Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab2HIFtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 01:49:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63645 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab2HIFtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 01:49:11 -0400
Date: Thu, 9 Aug 2012 07:49:06 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH] pwm: Add missing static storage class specifiers in
 core.c file
Message-ID: <20120809054906.GE29806@avionic-0098.mockup.avionic-design.de>
References: <1343890962-25467-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/2994txjAzEdQwm5"
Content-Disposition: inline
In-Reply-To: <1343890962-25467-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:foFz1WptfWMYOba38YflwAvuVS6w6a+Vz85by6qCpQx
 Odyazf0E0qvoXmLOP9TK7ijZauHwfhJKfyJx+oan9DUx/xWogq
 NneBBtkESFfqtEAIhkVzfuKoL8bRfZv5yysezisl4q4nc/+Vn0
 rfUtriq08B7ybjGF+stmgl12kvYPqKvaOFDpeo9jYSuqyq/NQg
 7a7M9MqfZvX0sMqWHNHtiQF+DtFGcns/kPo7gLhSQSZWIeDoJh
 nJ07ch4uiQmo4811cFQU3IUtLKbqKCC4tT62GteMD93AWE7u+4
 sJrJ+hNzWAACvsEJL21x5e0qkSFSwftyXklhNLJN9agar5CJy5
 A7cG/OlDS/LfgHhmX8BVBrIUQ9A/y5TOFOaNwZAqIQZOUBkBhQ
 vJCfJRLfQJkH/1jTB3cMT9kR2AL+DFTCNtz1pJsUr8QFQpqSP9
 ukO02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/2994txjAzEdQwm5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 02, 2012 at 12:32:42PM +0530, Sachin Kamat wrote:
> Fixes the following sparse warnings:
> drivers/pwm/core.c:152:6: warning:
> symbol 'of_pwmchip_add' was not declared. Should it be static?
> drivers/pwm/core.c:165:6: warning:
> symbol 'of_pwmchip_remove' was not declared. Should it be static?
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/pwm/core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.

Thierry

--/2994txjAzEdQwm5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQI09SAAoJEN0jrNd/PrOh0hkQAKWnMW3LScCs7z0apXGrPGdc
6FnWlnKmbI95QrESyEzsW3Cbt4O7dKp93wtRPOQKx/5skQD17FfsgqouSZK6qJWO
n3iFFTpBilblqZ4WQnLtVUhgcve8F7CR7fJxrB2XrDKokYfYwbgEFEdwQM7ynesD
2s+Mvxitt96ZTNmIEO9WD+3stDlC3CJ4vIPUd1cjBepRdt8YQWljteFtCylortOl
ay6n4TdaELkje7b/0cypmuHgjGy3z7GtquO1xfbIBbwlh//vyyXKgmqb5NJSA4bN
0BQ9KWZ5FhkOX6Lt9kDM8eWU6xF/yeXIB9qZbu8VlXj5kVSjPL3jDkpkxiwiHdjb
8jRQXsfvCV6f5xmBcsQjC0bRLDl+kp9A9ubPM6EwpYUCCFOGm/JdHwS+5ntXzh5R
IAQp2Iv8G+zkwBy/FdcxEITKCADGlStHvNW9ig33+5JWcvVEq5iuQDvRKxJbN9YH
/gDtew9Uttv+uk57sT6LYS1e/M4TZoUKUOrf8f1zcMSdcOkvVYIXFALoUC9Lzsy5
TmIQHWOvk2UjhqZh8Iuicg3NP0VRnnBnGnbWid6hJ3pfSp9e5AfslswMTDaGE4rM
AO27IkUgmQP0CUlvr1gx8WaqtOAj2hRdVEKn4wHCYcXu9rJ5Vm+iKXQTX3n+bmoZ
gOoqULxQsIMDJ8vmdYKD
=+DIm
-----END PGP SIGNATURE-----

--/2994txjAzEdQwm5--
