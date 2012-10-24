Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab2JXFlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:41:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55275 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab2JXFlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:41:19 -0400
Date: Wed, 24 Oct 2012 07:41:14 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] pwm: vt8500: Update vt8500 PWM driver support
Message-ID: <20121024054114.GA9787@avionic-0098.mockup.avionic-design.de>
References: <20121023221419.GA8501@avionic-0098.mockup.avionic-design.de>
 <1351050418-23981-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <1351050418-23981-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:OgD8q/dRC4Xv0R7v073YDQ7kgLYri7c+DkhGJdRNnVy
 nmnAQP+9xaFdanp3ukGQBflIwulS0ek+8Y7Hq+6hg0AxgldWmk
 pw0mxjtQdqhm2btI/+vNa3JxYSQFGvY6ebDyMMGgheLCGzW5CL
 3LHWOGYvX6/0Hthp8isuKA1TcdkkbVQgJrdvmmT0t+kc9EeNBv
 VZpNlLmsXaomESwRAqTmiMqSJ3AZp9Intwv1eJY2jWzCzW+yRY
 BSu/HwkU08A0dzu54f7Ue+YrMkjdP9bpaVLxIk60LZxEQsG7ps
 TqbV8WuwvhD/ti0kfXkvrX+VJNz7TamFwfl5N0mH8NIzbbiyoI
 A72ZFWxckJkwYXHcsF+Y0KDo9PHI1cfW3Gj97b3wJmv2zi/6PZ
 WfIxM/Z6P9SVMAznC1H9ZJE5dcSI/oa0HHH6dlYJcuSNhtxZkr
 IJdCo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 24, 2012 at 04:46:58PM +1300, Tony Prisk wrote:
> This patch updates pwm-vt8500.c to support devicetree probing and
> make use of the common clock subsystem.
>=20
> A binding document describing the PWM controller found on
> arch-vt8500 is also included.
>=20
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
> v2/v3:
> Fix errors/coding style as pointed out by Thierry Reding.
>=20
>  .../devicetree/bindings/pwm/vt8500-pwm.txt         |   17 ++++
>  drivers/pwm/pwm-vt8500.c                           |   86 ++++++++++++++=
------
>  2 files changed, 80 insertions(+), 23 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pwm/vt8500-pwm.txt

Looking real good now. One last comment though and I think I'm ready to
take this...

> +	err =3D clk_enable(vt8500->clk);
> +	if (err < 0)
> +		dev_err(chip->dev, "failed to enable clock\n");
> +		return -EBUSY;
> +	};

Why do you return EBUSY instead of err?

Thierry

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQh396AAoJEN0jrNd/PrOhubEP/iHI7DiFitkKygmOv0Cnx7fp
hVcTfGtznZofSj2yENf6RTUNpNT77LL1QBHr+0M+mPgcbddDJABq6TPrFgtTXJhy
KRTTcsLHPaoBGWUnyWYtUZJh5R2ekt7kPguZJxGyYDrinjyZ9lTrY+bQdLbWh2ZX
8TotGqcWLh5wX/4tvUOHcPweFpeq5pR8x/MDcXdGYqkF13Yr5OutdF6tRJgvWdyL
WK/hTtimKe0LCgnuqHsvUQ6aL3aMFvzOvMZqyvlgGBu8o+Ohg/VivBR0y1314Jl/
V+DB7V8x7kdhVVKFtWchrKrD802ciqPFNhtpeR4MZRhAH7B2u1E0HOVMecoLsWDM
G6H5hRrG8ty+eX9DBnV+cKX3JQkxYIULvs4W+hKMIDWpJ4ep6qfsqHJQgKjt9JIQ
4aAh75Y1jGpEV9ZrIuNPiYBproFPdSmm3hI/+0tIhqAVwcjxbolu9LbRlhgQ98O7
YDkfbTatlLXngCPMwic3zoSiGg1nWEbhGl0Kv4EZRPtfca08mzJETXZq9T+vvyQg
QHtuyCF5OIivNZDJVePGV4d0UAIF8Aogl7JfoJrOJjmjb3X2tdSXQ519b8wuuAC6
mrpVq1en0Esj5jb8BMBXrjCx7/s7ejj/T4/2Ge52GRD58LQLa3fSeQVRDqVs5Ii6
3CTpgmd+n+QQe0pZFx9p
=e66U
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
