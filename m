Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab2GBUqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:46:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267Ab2GBUqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:46:09 -0400
Date: Mon, 2 Jul 2012 22:46:00 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pwm: Convert pwm-tegra to use devm_clk_get()
Message-ID: <20120702204600.GB16287@avionic-0098.mockup.avionic-design.de>
References: <1341118851.8998.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
In-Reply-To: <1341118851.8998.4.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Z7drSwE4NaB6BqpYXKs14zAydIx4DFZ9Q02H8rbhyTg
 U+uUAkJ1goVtCjCY+q1SUi1t3k4V5JPQaFODA7uZKjtdAYv78p
 5UL9LgxJCQ+loA9XicMVe5Zc5oBzdrY7ODdcfw17Kn7BT4ivzb
 5ZGF0edvG333li7rDTgGK4o/S425jF78byaBdBoIiJrVuL+vw3
 5chqyR/vSTxU3AxXVms3lZtsAM71oTep3Dtl3QX8JMQkKGLZ/J
 uJfM5GGRmaF1/FjKwC3W2EF2pDyxac/y1QWilOsb7z+mQ6Wy2Z
 5d+WgaMjQp8yCWHSeQkkb1nDF7Z4dhz+lm8nQ5bNTbSKtOWjuc
 wV6JqvESSjkYZLIbp42jsD7DYSpHh3xkqQ5a/F27PqtI4yYpju
 r480DS9xvExVR5lSHwlt7bN5lAhxJzRG4w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 01, 2012 at 01:00:51PM +0800, Axel Lin wrote:
> Also return proper error in tegra_pwm_remove() if pwmchip_remove() fails.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/pwm/pwm-tegra.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

Applied, thanks.

Thierry

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP8giIAAoJEN0jrNd/PrOhIbEP/iWOKFk1g1J1BQ8wzs9Nurks
IhNNMlOF3f9FkUiQ9rG3/htR1GSz9Fhy6m60/rKICUu64btUJ3diIvg4WQeqKf4T
L7kiPFQwEK8CHiAhAjCC15CkgxvTOqmxaBcj3wkoGJOCWTkgHlAoouAKnmHokE+A
rLXQb0amlUr8iMR9f16Ox2kvmHw0OB12Ci4ZzS5IuIyUW+UEqOvfCdgO/6xqyzfT
dgvs630hHg8hv2Rh5n7TDNkS3HdbI+I7+i2cvw5r3aSryemiY19SGNBLbZA5FGyM
2nucpZPgQhX8UC5Vq/unbDxcEO4wwAc59/3TqYQ+DsCFhuuj8HRNPiVBP2dm+Y1K
PebswSIlCd5v08C3NAEztP7hHaDTvVDLFJ9ewxNRAbbEpidO6GMLqjBRWAaIRDrH
R20fTGOfuoGx3rLOGLbMUkudrZeypsWdXqngRipj7vwI2CVbvVJz9cp2MfGajy5N
iV3Hwi/zrYXSrSD9/MzgvAWZOvDtOVbk2sf8i5YWJtuUjQZjEojQSETOUHdOUIV5
JWMgdwVKHKK9F+ZM2DSvz3As41HvLvoA1rdPBhYczCDPWgPjkUOVegb+KBh6hwXA
7+WteFpRz19zJYwZiuMz/9O8kS24AlyPjFZxekrwP1cfiC7p/qLntNJAwv2sAcH9
lr2r0jjxQQA2NEQTdGX4
=VwMQ
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
