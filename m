Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab1DNQ7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 12:59:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57315 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503Ab1DNQ7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 12:59:37 -0400
Date: Thu, 14 Apr 2011 18:59:31 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Michal Simek <monstr@monstr.eu>
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, arnd@arndb.de
Subject: Re: [PATCH v2] uio/pdrv_genirq: Add OF support
Message-ID: <20110414165931.GA19228@pengutronix.de>
References: <1302774106-32764-1-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <1302774106-32764-1-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Thu, Apr 14, 2011 at 11:41:46AM +0200, Michal Simek wrote:
> Support OF support. "generic-uio" compatible property is used.

This description is not true anymore. Please also add a short paragrpah how=
 it
is intended to be used now.

> Signed-off-by: Michal Simek <monstr@monstr.eu>

> +		uioinfo->version =3D "dt";

Minor nit: "devicetree" is probably more descriptive.

> +
> +		/* Multiple IRQs are not supported */
> +		if (pdev->num_resources > 1) {
> +			struct resource *r =3D &pdev->resource[1];

Are you sure the irq-ressource is always [1]? (Similar question for the
if()-block above). Try platform_get_irq().

> +#ifdef CONFIG_OF
> +/*
> + * Empty match table for of_platform binding

While it probably doesn't make change to put every supported device in
upstream, it still deosn't technically have to be empty. So, mabye drop this
comment and add something like "/* empty for now */" to the table?

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk2nJ/MACgkQD27XaX1/VRsuNgCfdS6fQTSKO9qBpXWJbYmCa7fA
wxEAoLsL3ta1bfx6AjjcOvBsUkOWJkLu
=0VEc
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
