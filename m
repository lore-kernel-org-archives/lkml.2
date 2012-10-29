Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036Ab2J2QOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:14:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42818 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759961Ab2J2QOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:14:18 -0400
Date: Mon, 29 Oct 2012 16:14:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator: core: Move regulator release to avoid deadlock
Message-ID: <20121029161416.GE4511@opensource.wolfsonmicro.com>
References: <20121029093333.GA17941@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JBi0ZxuS5uaEhkUZ"
Content-Disposition: inline
In-Reply-To: <20121029093333.GA17941@opensource.wolfsonmicro.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JBi0ZxuS5uaEhkUZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 29, 2012 at 09:33:33AM +0000, Charles Keepax wrote:
> regulator_put function was called whilst holding the
> regulator_list_mutex, which is also locked from regulator_put. This
> causes deadlock when failing to register a regulator.

Applied, thanks.

--JBi0ZxuS5uaEhkUZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjqtRAAoJELSic+t+oim99xUP/jyfX6uu6MxXXbnqp0hwIdjQ
1ercrJKJva057IaMeB/JiDLzEFP5uh8/TzseBpINLOOniivXLIUP/+pv4hMHrf+m
0D2Nt4gmh+9sUbIhXsZ5saxYBhAaW3nqY+CTJ0hrD6WckCscsrwY0U4JwGexPOp+
pZFH3Sgzp2NEVtRyEpFU7Wp6tljTSO90q1DCB1R/2sssUGk5p7KVUg06e0E8MAAG
51ukarkxwdWO98R9+Sc5c7TTxFCzwkmQi9NOXA+y0Ndwrab+eYTTSPg20oOF5jsD
NqH8JEIAsL4yxELLODdM9EsogdDdQHMKk9A3ecep8WQ8+l0a1yPeJXYp4UdzUzly
4PkZKUwf7NHH+X63e0CkJsxjJWdBm25m52b8PN+xTVj/r5Kk9QEl2xYd7CYH8U6r
2KcULw45B286mtmeAcl4L64ozoZUiI9Yj0yqFtV2X0e5WE2Pcp/xRvQMvzEI0OP/
5z80xE/TW9ywR1k68W0hWSY4/nLzPWHFh1Volk3Kg+x/E1pkr4P8FZpucNxwZkJl
nJjnGmSOZtgJrZ9iP//YtgVwa8rfc1DkHV2UCuLHICgzNd1w6S/iHfEpQHHQ9M7y
GYwTIriOEgA0cmgDauQomOI3y041zHOXiuQyTbrsPK3Oq47tUXXK9xs2SIOlAKJ7
nGo5It+CzzNZWAQ9DJxP
=s9QZ
-----END PGP SIGNATURE-----

--JBi0ZxuS5uaEhkUZ--
