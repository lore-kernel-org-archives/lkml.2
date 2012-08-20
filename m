Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2HTFGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 01:06:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64954 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2HTFGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 01:06:52 -0400
Date: Mon, 20 Aug 2012 07:06:47 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <bryan.wu@canonical.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leds-lm3530: replace pwm platform functions with generic
 pwm functions
Message-ID: <20120820050647.GB16729@avionic-0098.adnet.avionic-design.de>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0095@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF0095@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:bI5zGOvujfgVSRXGIPf+RjKjUAZJoBzTsIZsQYaGRwn
 uxfcEP69hF46NImSvC1hNA+IxAjZ42g2XrzQPBl52+9kphTWxm
 iWR1BS5ciYI6WXtIJcWpepQL2TdkulO/wBzRLH0ybSNHwba/Zp
 7MRzYmx7PxyMKnuL2D0EHOYCf+G21babKodtFbA0mrLYdsR6aj
 apmTxZp2VdFh88cznhRj90dnlOxQucjQtlxTl9o73fvSgMdQPB
 mmabpmaK0dCiT2683dzxqJnd07UnBdwiaq2ve2iQX9N4D3Jbej
 jeceQ5CVrywV8DRu6Ei3eTLWhFkaLrSyP1GDee4Y3JOe3chrgI
 MQnQqNqQzWiAWD9hpVh8i8TnfHRBQW9rq3OGBsKq3x0x9TMwL8
 kN/M8tI7eBisXY9T5io5qOkxJb3aDhvV7Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 20, 2012 at 04:02:05AM +0000, Kim, Milo wrote:
[...]
> diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
[...]
> @@ -111,6 +114,8 @@ struct lm3530_data {
>  	struct regulator *regulator;
>  	enum led_brightness brightness;
>  	bool enable;
> +	struct pwm_device *pwm;
> +	int period_ns;

I forgot: maybe this should be an "unsigned int"?

Thierry

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQMcXnAAoJEN0jrNd/PrOh0gwP/AvfUClXoht2bv/JFHZYVkwF
nWLC7jiMnsdnzIfy/1XMgF05v9ymg3J68swhNwNu1g2JKLCbRU7QI0OXlmAT5zEX
PG7DAdd5M2itF4ped6p4zyB0BDB5p53sqgkclwhJHbFLxRcQBfvoSqSKUfcNpbBd
Ocjoq7u8c6HdTBsRW6nPzDqQaU2wHdL2ni7/F71bNVM3czMsGLDT1clBf0x62UvW
5dA/Aw83/dJ7dsGFY7+CiJ2U3EEjgxVnlrcTQiJoMavj8KeXfpiTmeN76IrhNGdy
SLQkBVlnCh6RoG8iN/I6pKC3gMZnHQX83SyFPbhNa8iDUErx+O8upHK6b08qKQLy
3PYmtzp2q/9qdARS2tJ/4IZAOjZuzj/92UPQOKlRomrJAjyfX/9q473fXxRObdGD
1gyMkNNPmvsgMXaBKBJa5nbWRy9kkci9k4jKsFY5NHMVFsyozNUimfeRP5ZlcAPx
JxmYreQql+c2KEdg5zThxZn0FFbTfBZxuTb7/V1uAdH7+dn6wiU6QPIG69uoatQv
1rVQTXx75DT3EAzC+QTcuHL1gkEe8EvNmylNvbVHlbga81IaoUOaF7kEHF22ffUl
6lF8+f/kxYskV2J8yeaGSDPieTH4euozPvSu335q+z4TwsiKaLgMX3YJAzaLt4/B
S5zFnZXR3JLV3/kE+ftM
=N8a6
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
