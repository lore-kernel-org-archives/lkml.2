Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab2ENRDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:03:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46442 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757140Ab2ENRDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:03:22 -0400
Date: Mon, 14 May 2012 18:03:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps62360: support force PWM mode via
 regulator mode
Message-ID: <20120514170320.GG25668@opensource.wolfsonmicro.com>
References: <1336997811-32207-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m972NQjnE83KvVa/"
Content-Disposition: inline
In-Reply-To: <1336997811-32207-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m972NQjnE83KvVa/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2012 at 05:46:51PM +0530, Laxman Dewangan wrote:
> Change the mechanism of enabling the force PWM mode through
> regulator set mode. This can be dynamically configured now.
> In the REGULATOR_MODE_FAST the force PWM is enabled and in
> REGULATOR_MODE_NORMAL the force PWM is disabled.

Applied, thanks.

--m972NQjnE83KvVa/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsTrPAAoJEBus8iNuMP3dKREP/1GvLEVprgTMt82Vogu8xvDS
p5JdSHgXKnnEWqg8QeAMdn8LZqtUgvZetuopDTCfCS1fDs0L+sfVAAFF0hHmJ5TB
Fpog+qM2h9+Wutn2ig/H3cq8raZhwxrW6MjCGeMkcMJ4YhE3JQfJvnwNjsgsvRZF
o0NIxwBOxUoljpmhZHA3Ijt7lFrR6YZg2FCWAIVZtDruzgHr8rrZl/Xuh03tS4M/
9NiISjfNZhgRIalrw6OGBnYMybEZ6+DPAddclMACOn31ADsuKPG3UYINWuTkVWX2
imtndFp8GEyi/oS0ueP0fbsKEcigrWck5CGxhT2sd/BCkkVuq6+YqxW6li8FBlEC
EbR8lvJTzaJDnagLNKe2WVZDKja0j5TXc+wwOujLg7U1RIrCj20ptm0JiZcW/dBd
DzjwtXtLHifRk/dURtjossmNPcCO4iQZcPza8kT44wGqA9NZPOlkIh/SUVNlyFq0
otGr+tKAqYQbLKMpoxCwRXqLPRBhCxRfSCI5agnrhz24JzUuqQDwmLoZPs86mbnU
RlBMuAC5Remf64LP+OmjX0UjmKmAhJfCGjIyeOmKwOoJqPzN24oxs2no9MMXoncT
LzKockPP5RQWleMQFp6BZX7eVpUMf0axmMSfR78KIVYTSTzA90YQadRa4UUeNC6a
pgBKP1S81fjb44f/gM41
=GKUd
-----END PGP SIGNATURE-----

--m972NQjnE83KvVa/--
