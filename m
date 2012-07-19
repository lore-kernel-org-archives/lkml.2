Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab2GSJP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:15:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38912 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597Ab2GSJPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:15:23 -0400
Date: Thu, 19 Jul 2012 10:15:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regmap-irq: support different type of irq register
Message-ID: <20120719091520.GJ4495@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FD9A7@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ou9v+QBCNysIXaH"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FD9A7@DQHE02.ent.ti.com>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1ou9v+QBCNysIXaH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 19, 2012 at 09:04:44AM +0000, Kim, Milo wrote:

> + * @irq_type:    Interrupt register type. masked or enabled
>   */
>  struct regmap_irq_chip {
>  	const char *name;
> @@ -304,6 +311,8 @@ struct regmap_irq_chip {
> =20
>  	const struct regmap_irq *irqs;
>  	int num_irqs;
> +
> +	enum regirq_type irq_type;

This naming is very unclear - it's not about the interrupt itself, it's
about the mask for the interrupt.  This would more normally be covered
by marking the masks as being inverted rather than something like this.

--1ou9v+QBCNysIXaH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQB9AiAAoJEBus8iNuMP3d6XkP/2SXCGSBvc2DjBw39sVf9AVl
edAnXHzVRhopZaD5AW5IbDguAhrknFZP8xIOGH0K+a/JL/qhZwKyOJBPI+MnRDh+
6VeRwrUpNpSfyHg1mabOu0Jrvvph4n5sqABOj1qieOViFOmnU+XWCqE4bCvutlnV
MEM3YNb0XZOLyqVssB5HRB5xlgJM8RBvacE3apLAuyZCCTHE6Dm+1XpZE2IhDboz
IQXvmMnT65m5KEX5dZ7TuXiQM2oDU9MEaJy+92a53E6jOQDOi9Vin21GG0OYJDAa
MjHYALZ3PQbeV/NDLEQVAjUNhJJv+yIcxzXQTILW3IXOYdUzPakAhHW9fXvjvgYT
Gcqm4iCjlbt/3N1cYS/Rw82iWeVr2mkTRfj02gaw+mhmve83xrfMBfF8myhMS01R
KbJinzMMbo1e65Lo+pPx6YmTxCN+8FbVPcIRyOQ95AJkgCJm4nR7atPWEpzo0Yw3
BOotnq4YNa0gYiupkIgiiBNWrAHqWs8ukoYsUBTqYqgaFaDi0zFS5fekwoubvycP
oC7ZagPmDHSVRSaUDrvlWSik0ENe9r7TQc66tc3gdIbjobZN9Y6frvPeYmNuOGqr
4UcwbVa4YfCrCw0KLjQFEICgcZA4LpktKBES6HTPhaJ968F/f8IOXRujuC3RnfJa
GkemHPFrzDIOX2RTeKIl
=K9D1
-----END PGP SIGNATURE-----

--1ou9v+QBCNysIXaH--
