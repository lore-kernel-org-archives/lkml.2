Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2GBUr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:47:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54031 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2GBUr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:47:26 -0400
Date: Mon, 2 Jul 2012 22:47:16 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 2/2] pwm: pwm-mxs: Return proper error if
 pwmchip_remove() fails
Message-ID: <20120702204716.GB16305@avionic-0098.mockup.avionic-design.de>
References: <1341118620.8998.1.camel@phoenix>
 <1341118680.8998.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
In-Reply-To: <1341118680.8998.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:H19zrTkWm7l7YV6wTquktO6NTnmEb062qYScY8JaD0+
 /yDgBhXem3j81c16sPNa+ODvLUwyOCcrdO/97sDG8Lm0/+iRxI
 M8hIlBMFlecueuo/RjTIpCfOKcfNRA5zqT5ypRw36mn58TvvCs
 J6t/+v1us4HMUlO7+cxiBCvUrvz8WlAXPiUPdH/FsjP1O6FoFs
 fe60CeT/9Qk007N6bnBe8UwXIDwrhP74SkrkDW4kK5YmkmEj8E
 7dzOs8FlaHonD8Phw8WWvFmaReAwoIoSMy5lxlw3s9sehXX6Xl
 7WYytJ4Mx/z4cey1tk34ESYcMNjY9Giqympmb5H5pRxXM60stJ
 bR1ZgOiZ6Zqh6Cr89/gt+TOCD6TxoqlnhUHLk50YWUE8Bt4H/A
 tWoSl7sU3+Wab17rKcQi/P1N8lykB0ORww=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 01, 2012 at 12:58:00PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/pwm/pwm-mxs.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Applied, thanks.

Thierry

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP8gjUAAoJEN0jrNd/PrOhRmMP/iwwI2Tj6XF5U9RV5vjhBj/g
9ZVUMmDXt3KQ+frS+n26s6TuCVhtUY8bYA6nSUjYGNkjc3hNwNicRC8eYSOmM+RZ
KwdQ/QXSbcO3FM3RMhPS1+NwnlV+gvYYpg6c9U/2CM77nTq56akPS+IikiIuGjUU
2PNDNBC4wLbAWdnGh/oPTlLEeC3CwRt/W8DOVZN/JXV+WcvkLs76QGyNSneB4BwN
h2VgcV97NLnd7MKURz84wB9ny9ri3njxMcz+rWe918CfjMYIUuYqVNdeu8qMqgXB
chKh+3Y+dXixHoJh2fFhn2m2Aj8L+tI0QLZEmnTtI8vfHIX4QD8Ye/1yCmumU1E3
zEV0g/rIQf3hDxCRSYSROqafWQ/VCcx01zqXmsf1iigQLqIcjEtEb2LVMG7o/2bn
PxCBMS2xa1w42Lqti2lw2ShNjUgEc/iulB20GqMSfRi+qMHU8iu1LaCe7tBP9Vav
7SEQNIoyPWyQ0GIe/kBUOlK11ZKWCgge8eMTRJqmP3vTCklPcLxMu0ufRa9nnFcH
5Wa+dIcagkRViH5+I5Y+zxcNuXojOEY6twJrGUsvGNpbI3hbcUfZiX9+j//jyZeI
a7LfO7QjoK+EnpxPXJ/n2KpJSI2HRoGLwBDWAB3348n9Y7R44hv8b1ZkQIA4Lgus
AqZrEKKTdldGw6UplE1N
=YXs4
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
