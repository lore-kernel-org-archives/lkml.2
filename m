Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2GBUrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:47:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55251 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2GBUrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:47:09 -0400
Date: Mon, 2 Jul 2012 22:47:00 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pwm: pwm-bfin: Return proper error if
 pwmchip_remove() fails
Message-ID: <20120702204700.GA16305@avionic-0098.mockup.avionic-design.de>
References: <1341118620.8998.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <1341118620.8998.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:VioXpw0qbgpxXNlqsow32U6+AV/cBVqCHNNjrpi8Qee
 cvlyANRlULhrtP6lmh7SHLsAcgZDgKwKhFp8DQjyoW3Ds7Pjrr
 mQxDrmalmmu7gOEkB3NelGRRPTK5aPyMQVmt50Cc5GsXYZuIjm
 FGaRDI312BIcHK/v5vy1Q3wVQKqFYDYkSPYoSn5WlnJqBrCPGT
 tyy5uA+HIQPqitbX6D+dzlZF6It+gcym7o3MBKGPaDxCSXz75D
 lkb+4idwdmiuKKx6EsPtpWkTu3yr6YTHG2AeE08PmkdfB6aT8l
 GMth9ofAqDqxm6XCjw+615Hh8A22Cjq8o1MuCdIH/8wFLR2mpL
 ZlSR4wJ+zT38eXf4buAfAun2a+xP7qSYCEsanJSg0xfC5CR414
 IY9c67RY4RkhEIYF4NwPabMSn++U5oqGkOtemCNPUKe10OKVIF
 I6+vb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 01, 2012 at 12:57:00PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/pwm/pwm-bfin.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Applied, thanks.

Thierry

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP8gjEAAoJEN0jrNd/PrOhds8QAJ4e84t0yvJu5iho09LOAo7B
f+y3myQDjDXvmv3MB/uiE0Y9Oh5ZZyRakNlkTAosvYb/V9RKIaXOFqeDRg49EWed
uM6vrchnjzKn9ORouIcGL81yf21x7bEFp3WfXPyglP9cWhApNm4ge9SGR99CWOGy
Eb6F3FsfdFrLpmJDbWHsy9u8uSAeTiCVlACzWooFKvoShDQpKT5KmMY+RTt6QsEt
+uDX05LMfo1Vr6/B28M0FGiE1hqK/P+m3tlSk1PeK5wyKV2wAVmGZi4IWv+dXIRK
imH7ZlLIQLNiQO5eXsUhBuyqBZJfeQ4WkYAjBJXpggcHMEn673I/TqL/I3A5IfhR
yKIMKK4Hqod7dG5YvrQr+vzxzUNaqTdWuGPkVG7hGpSyRBFTNrGoRo/tH71kagce
FqQm4WRxzDw082/zVngm36CmSUmLHXOeYeNjVSHUL3uEnY/fPIrvNHL3bLHDSInN
VsoOIPzAYCR60aHxAxDbku+kTnkGsZNPF/nHZGBvUaz/A8jQsBwj7MoQCvKDRlpA
ZoSXNf/UH8Rxe5p7FhERETaLd8sgttQyPkjqXCXKQkaykmyVnbwLYKVEZSBsLxXy
qe2xwxjPHZ+/bXpE36/hmXCttk5rnZiamfCYAQlCEV2Lc3P3gpJHpdc+s7175fYr
bKZlqnOGGDf5ZUAkQrfl
=8cLM
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
