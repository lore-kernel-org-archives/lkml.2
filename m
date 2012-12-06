Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964925Ab2LFHxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:53:10 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63063 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2LFHxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:53:03 -0500
Date: Thu, 6 Dec 2012 08:52:57 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lothar =?utf-8?Q?Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: i.MX: eliminate build warning
Message-ID: <20121206075256.GB25316@avionic-0098.adnet.avionic-design.de>
References: <1354721681-31843-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
Content-Disposition: inline
In-Reply-To: <1354721681-31843-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:LE0plRa/7eKfKvQ83zOWG/d2I8g6tL7NG/s+FUwZitF
 GRoQ125EDYzdmNPBLY+8SsY/HITYfqvTKVEgNHrcjUAaO1Qp82
 dG0xaRxf4Qq5yTAAiADuTHva+jEf5Mx/hzOqKM9kvicIu+lmOM
 8qZQhG6Yi+FYk3DDdit0lWzMGUIoS+5gGnZ0dAEqz5cF+r3bOz
 A/4XMi2RAbYIPkD8ctW6EHBU8Oavkx9I/McU05Q73u0PUd9S0X
 2GQyoedOIGRNc4Ixw6gg/z4YUUQ1pLG1ZhfNKgLdnukNMQHx8p
 MA7BOS1Wy13IymREdZ4wf1AryOlDeAlL1q8pxh0AGimxm9B22m
 DrEpO1HZXkE/sEIbEwnu9N99qGkXw5tRyayHpevsW2d6oZh8aT
 ZXpXYKd3YXox+cq4dP1sYRcL2mtcLIJnRzoCSFywKv9vP5k701
 ffBd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 05, 2012 at 04:34:41PM +0100, Lothar Wa=C3=9Fmann wrote:
> compiling the i.MX pwm driver produces the following warning:
> |drivers/pwm/pwm-imx.c: In function 'imx_pwm_probe':
> |drivers/pwm/pwm-imx.c:281:7: warning: assignment discards qualifiers fro=
m pointer target type
>=20
> Apply a 'const' attribute to the affected variable declaration.
>=20
> Signed-off-by: Lothar Wa=C3=9Fmann <LW@KARO-electronics.de>

Applied, thanks.

Thierry

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQwE7YAAoJEN0jrNd/PrOh01QP/RO6N46VpfVeSivQclNYkbu4
nrGOORJ3WMKVT0qR1HPshNMBAapRzkPg7sjI+IB7sbOml8YCI34LdJJRQnh3SNI2
yagEZSOLVaWL3tSKQ3rHAb1LwMAlAqM6Rog/+NfeU0RmtwoKL4w7/Y+zEvYfFR0D
uXepaFTtSTaOKuDDxx8VEUbqhKuEUL5+tDDpT330qsxubkXJJB8Vyu8l1qBik8qu
YGAJLCD0u5Qxs+W8kRmgVCfU/QpWb3wJqVQKl2yWdufsGnjaPCwTqD9UpE1z1u0K
KNGAT3P0TFcsWVFnSg6M+8yU4pshPh8kUPkgydg/ttX2jK4F0IxUqA2K1mxWgcJn
h/EnW0KcCNNXzr+Y5FPUoAzMTQJ7Hu11KdQKUrHhiH/wrRBGeIPhDniS0IhV6h+x
X4SKiNafZR6Xh/hh1Ak7qiRBiWf32vrdXU+oTPejfaob83fx9z4+625FvQvSDo/H
P0fCLU7nB/9A2/xTm26XagExWvAZwrJGxGMbuu/lXTDvNTZW/S7yko4LPwhZwiFj
asyxP3drc6TrDwJV8EYCrzQJEQxr/ETlRsY2mkFM55PYR7C+RueSg0rlIO663hb5
freY/GSyLK2v9IkiQhVFj2AxpLI/tiZiwBSXUfkKjr2vQjbflN8cBgmZNNcpWoOc
9GOiAxJJN5OXNFrr/lCQ
=rAby
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
