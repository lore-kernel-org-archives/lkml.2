Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2CLKvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 06:51:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47191 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147Ab2CLKvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 06:51:50 -0400
Date: Mon, 12 Mar 2012 10:51:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, AnilKumar Ch <anilkumar@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Merge tps65217_pmic_ldo234_ops and
 tps65217_pmic_dcdc_ops to tps65217_pmic_ops
Message-ID: <20120312105148.GC3110@opensource.wolfsonmicro.com>
References: <1331525506.8110.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V88s5gaDVPzZ0KCq"
Content-Disposition: inline
In-Reply-To: <1331525506.8110.2.camel@phoenix>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 12, 2012 at 12:11:46PM +0800, Axel Lin wrote:
> Most callback functions implementation for tps65217_pmic_ldo234_ops and
> tps65217_pmic_dcdc_ops are the same except the rid range checking.

Applied, thanks.

--V88s5gaDVPzZ0KCq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPXdUNAAoJEBus8iNuMP3dBF0P/i7IFedvpEj2lkGr0DSq7M/h
WbdIJASgyWyFGh8b3Ya0QwSZHFUB0jtyDNy40DEhtn7ZhglLOvcvl2GOaClOmH/N
VIITmkP5Mg1w9vwJ9NU5nsKbZWzYlm5OgV9P9OpFuqsbIPeWT4sO/d1SxSxVVhSY
Lq9uUGaan7FCn19LOoxprysBqp1HlekBsAtj3NGudeke6iQKb2jhKyuvu/8cjXFE
2oROGJTy6LjdTbx3JzlYbGXgVwrGKWK94663E3QMeS8zLL+QjMYOxnVWM3FJfs6S
yWrSWo7PT9MEnf7zimN4OfUKS/5t9wuhqhutFCEeSc+h3NUoL/4W6ep0cQju+fus
19LwtG8Xs1b61fQ9nv11Uu+6VbttDIb1IHlTvpQB9ZK17pAdOi9kdLu2OUa6nIqy
fkuqVfyVN525opgTWzuYHvdakOYsDtG8aWiUNsJzE5Pks5K8geOaxQkbAPNCV7hU
lIqIlCQ+R28a47q3R2NyEA0hWW2IacXjulTBZAMj34mI4MMpTjtk1OQSoLFGQjWg
/FCxG0vbCF6rDHyrs8/iXQ5uKcWunRxoAfExZ3oJc8LCAHMlI1NwPgxL3INowNQS
T6pMUV3pfpxGov16Sd/MD77Gs4vqHwTqT5Mr27m6+qZrFdHw4EsXlaM9UV8yQutI
EVajfKOh0MUldQ2sZeaD
=XmV0
-----END PGP SIGNATURE-----

--V88s5gaDVPzZ0KCq--
