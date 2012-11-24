Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2KXS3x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 13:29:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63173 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2KXS3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 13:29:51 -0500
Date: Sat, 24 Nov 2012 19:29:45 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/24] MAINTAINERS: remove include/linux/of_pwm.h
Message-ID: <20121124182945.GB26154@avionic-0098.adnet.avionic-design.de>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
 <1353716808-16375-21-git-send-email-cesarb@cesarb.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
In-Reply-To: <1353716808-16375-21-git-send-email-cesarb@cesarb.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:QHcT8Hq8y8QHJKgjTWs0RoHSS2LIWxeLTWgmmAWpnUy
 K0GOML3qowMVx0QiTKdLuSO7hqWoC7w9y1KjoQkulBGhhipg5v
 yTJ9PnodqJd1PYIhZ55REhg0LqdMTId8kdkgjka6vGEZY1hBqG
 yAEKAyvRFv9tYXY8bVQUG3H7vz0nUQv2h0kVeEhadgov1frLNG
 ARc0t/G5b9wAI1rBkcYNF73O0evPQEazGC2cM3Ei0hsn+3jVg9
 n3+Vl5+8ca0EiYSeum5geT/sJTq+UQGavjobGGtKluUiGK8ve+
 yN4y7ql4d1Mfl0sWU8FPf/yvY0pvYVdplfeyjiWj0neUKEBzDc
 OTAmqrgc2x/MkAxgpCeusHL/GrNJNoOcaeBVqJ7P1ceH4ThRa1
 nTcbrnnVng8Q9CMfmLU1VBdAeFMFEco8VPVRpafzga/l7YsKEQ
 4HC/R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 23, 2012 at 10:26:44PM -0200, Cesar Eduardo Barros wrote:
> Added by commit 200efed (pwm: Take over maintainership of the PWM
> subsystem), but I could not find any trace of that file being ever added
> to the repository.
>=20
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3a3a57a..331b3a2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5946,7 +5946,6 @@ T:	git git://gitorious.org/linux-pwm/linux-pwm.git
>  F:	Documentation/pwm.txt
>  F:	Documentation/devicetree/bindings/pwm/
>  F:	include/linux/pwm.h
> -F:	include/linux/of_pwm.h
>  F:	drivers/pwm/
>  F:	drivers/video/backlight/pwm_bl.c
>  F:	include/linux/pwm_backlight.h

Yes, that file never made it into the final patch series and I must have
forgotten to remove the entry from MAINTAINERS. Thanks for spotting:

Acked-by: Thierry Reding <thierry.reding@avionic-design.de>

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQsRIZAAoJEN0jrNd/PrOhm14P/iTg4j6Gh27xMoFrUzo0M3Jg
e+ldkCAytXia9ERBmhTJkVXUWpLKlinKwWacfqHh6/TJ2cUrdcwkEzONFxK/ZQ1p
e3iNPr+UfOB+cUHV9sUOswz77KRkuLV8unslckPHfItokUSkKqsKa3SoZcrhmngB
Qa+N1p96BgLgLA1wLN9zmSX6hRhTETwjCPINdnuXTiRfbV8WxClfbGj6mLOFXk3u
pmdY3gaVAOh5LeTJrzVIaW/EIyAbYlegNNB6JnkBOMXJYl/kf3Am1Qg5ILGiol64
3eXnpjrmne1DGeBxBMnn4sizWy2UIkon/yB1XejnxLscK9hv7NQFNV+114o3ypxZ
ujhGUlQoxmOJTjekbHDwuFa3BZf2y2wV7oOW0ylO0wiH/JNNyPR1LHtMYhd0vf3M
5FTK2x/hwrGBvBRQCqySsdPRs2j97g1xays+/O5JdxFo2vNNUAhINEkqdSRQu+XB
2xQm4C3WwHdhAu3bCdJk/m337Y06dr+6B1z3Y5n5RGuEayuXZAwsJBwg2feZVuEI
pd9ZQvxBpXv3r4ShxqyUluOSDt4MZzvfpwr7K+svrFISgiIrKSP1Ye2rigJxRQcm
A+Lqep7bb6EQBkIQLjHk5iCGRJgZ3SMJaa+nTmUKLoHKYZv8CBy5tmOJ4Mu16i+v
KT403497XdnWkdCWDopr
=0cTS
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
