Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2KINXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:23:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54059 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2KINXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:23:03 -0500
Date: Fri, 9 Nov 2012 14:22:57 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: harmony: Add ADT7641 temperature sensor
Message-ID: <20121109132257.GA29183@avionic-0098.mockup.avionic-design.de>
References: <1352465815-26984-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <1352465815-26984-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:UNYr3YPcHnaTB2mcju2ke8EX+1I+1731U0jdc8nVab+
 NJ8nZfv5/OK3WsyDYRrS9VFWRQ8AllpJSXb2GrJh0TR/q91oss
 1tFAopBzkf82uJG2y+P0LzO/dEd8kj6dFN6nQ/GnAgsKZRg0r2
 sUvNKmcRAAbhKBV/fZU/0eg2KmmzTvIux0RnpnZmXBT9TgNFPC
 GHT1qL56yYu5tN0oDGShidzWjNFt5znLRVOFfckTj29rVi+/1G
 T8yv4H2Nz/NXaKkivNjvLPDkD+P6Z+LAZujkDZaZzSfXfOQwZV
 nYP5dsxcfqusojaz9D4trMfxHKM0t6/yG9m8hN8mAxyvf/GwcK
 L7uxL7BRYnqeKNxRbsjIo1tUZlkWoxdJKdB/WZ1ku/+JSd8JaC
 T33dCjxuGa/5sYJjES7mFlPYJC7D4TLsRQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 01:56:55PM +0100, Thierry Reding wrote:
> The Harmony board has an Analog Devices ADT7461 temperature sensor
> connected to the DVC bus. It can be used to monitor the ambient (local)
> and on-die (remote) temperatures.

Note that I haven't actually tested this, as I no longer have access to
Harmony hardware. Testing can easily be done either by reading the files
=66rom sysfs directly or by running the sensors utility from the
lm-sensors package.

Thierry

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnQOxAAoJEN0jrNd/PrOh/QQP/jUdnU0wVCfwCyhyXw0Fh+2h
PmPwDkW4ZDqO6DfbyXzJ2DjcPcRtYab8trdlzWP3ggNPXpA/LsRYrM9S1YzmFutp
lFYi8ifoygBQMBl1WCff4Qvp3ykzcLkZXjdxDIdx1RwKCUhLqkj8jYTpAr0/FucN
41IGiInGBwuEeiNE3rW2ZPVvSHgRRATRElYlwMH/jXUfgH34vMvp5nCJ/DioA+E/
BPCqS9MFDFTDb199S3KIxW4qdJo0my/Rn+feN+8HVD9/+uhMYPMTYO4GfPkatv71
o2HixCnbs1weBvbtqwE4Jyg2vptZ+VtclkH8euldhCnTUv4HBqjvmLG0B2Bj39Q1
cND7kEDtYJnKrOiEgY6MFoXy5+UpZBp4N15nP/WyUJfgoxFoBHWaVC3bjWJZjH54
51B2F0NnX0dRjPS/gIgv3ttCbFDBdwWkg9y6rn+jaU4ci6JQf6tWvas29nPY/qXv
WKNckgLtphvbtgToXO/I/xRoU6MmYGT+RctRoTC2ZXu5A7edfLWN1MwHNRQGRmBa
+CQV4kl6kaWAQ4iYpDNbJk+MsEGcZ79sjHgNmZOt1LKYycMQKTpld0Yd06WEHXxM
Rix0KsaOt2b/thKaKgG2en33gmd7TDTRR7X2wlAbG1VXUsTdY4KjYWaiKf6/buJo
YEJ9SdB9vFEBdTrySB/f
=GaKy
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
