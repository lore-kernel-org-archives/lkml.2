Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab1GWAd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 20:33:26 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:44271 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741Ab1GWAdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 20:33:23 -0400
Date: Sat, 23 Jul 2011 03:33:19 +0300
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Hemanth V <hemanthv@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>, akpm <akpm@linux-foundation.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] mfd: twl6030-pwm.c needs MODULE_LICENSE
Message-ID: <20110723003318.GA13774@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110722171708.370b2cf5.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20110722171708.370b2cf5.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

(adding linux-omap to the loop)

On Fri, Jul 22, 2011 at 05:17:08PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>=20
> twl6030_pwm: module license 'unspecified' taints kernel.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Hemanth V <hemanthv@ti.com>

FWIW:

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/mfd/twl6030-pwm.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> --- lnx-30-rc7.orig/drivers/mfd/twl6030-pwm.c
> +++ lnx-30-rc7/drivers/mfd/twl6030-pwm.c
> @@ -161,3 +161,5 @@ void pwm_free(struct pwm_device *pwm)
>  	kfree(pwm);
>  }
>  EXPORT_SYMBOL(pwm_free);
> +
> +MODULE_LICENSE("GPL");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOKhbOAAoJEAv8Txj19kN1DywH/1kj2Z9lPnQV3n+M49odGCIY
ee6n3Best9s/KGx9ciyePgGEiLLvJ/SMPovy4VtPWaFWRqesCxoJBHbJWpLNINoL
2YWt5r97XOfNwUHU2ZCnPIH9/BaN2F9JZDtCaIb6+ZMlLltSvvYfkt2jzCGFfdNF
0nVeJVlRjmyScayLbA8D9YMfXc9b42UynfSwv9A1qJVw9LFrqbbh2MBhCvmrqWZS
Rbrf/PMyhwPi6uY/dYyBwwDk8t4R6lca5p0pPRz0w/FJixQMNCkNXVYQXtAxm/l2
o2kH5NK+g+W+4bA8SrAmbRMVxsFfQdTJvel9zzWiWjsDFeLbL/tX/lIDtagMj2g=
=G4cU
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
