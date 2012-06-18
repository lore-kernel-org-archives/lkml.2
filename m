Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab2FRMCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:02:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40854 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738Ab2FRMB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:01:59 -0400
Date: Mon, 18 Jun 2012 13:01:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Message-ID: <20120618120158.GJ3974@opensource.wolfsonmicro.com>
References: <1339558031.26190.4.camel@phoenix>
 <331ABD5ECB02734CA317220B2BBEABC13E9D83E7@DBDE01.ent.ti.com>
 <CAF+7xWkh6CHvcur2iDs0Nwp_nO8i=6tYyTVauL6qtyrrMctjjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7PTD44AewjTsiSV"
Content-Disposition: inline
In-Reply-To: <CAF+7xWkh6CHvcur2iDs0Nwp_nO8i=6tYyTVauL6qtyrrMctjjA@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7PTD44AewjTsiSV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 07:55:59PM +0800, Axel Lin wrote:

> Since this patch is target for 3.6, this is not required.
> The regulator core will set it automatically.

Do we need to fix it for 3.5?

--C7PTD44AewjTsiSV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3xirAAoJEBus8iNuMP3doTwP/jmP6zH3lxuLmQucIevQikl2
cYPepIJ9aFLBZXqo2CwE+Qiot4cwjQgXVHadujzclxAHaQ8mk5R2YfF5amlPoPmX
SZbjHeD2CCeYdcevB5nvWkFexssdi66YBwSILURqcYX8gVHZFjOveOgEVTbA0ULl
Kludmvh6kXzW+Jy9yiD406I1LnJhLRTgj4ZPVTjQdbqMnbvdsevx8KHrlusWpDoF
wk2C7J3PPDnl4jiceVYhL99zLF4k07lgO6rIMDBiBr5Lryc6xh8k+Pib+k8VoelU
m8TfN6boq9aB3dWnUi+InC3X1ewQoQy3+gt1kjW4j0m0kQe4qF1QGiI5zlvy4Ko6
omVZO4pMUpCDmXIbVL+i011z1CqW8KsJETbBlcbnGRlIkPlEHMRJY2/R/lt9ZdLQ
bOUra74fPFE51GpjyZXvviR5drEzU4w8qn0Pl/VvBpv4bL+8w9lw26AUBKZjwwVr
W+yF202rcHnxNQF+2yi1+cfewGV4nD/mpgO26EdSmQSMa9G85a5qBe0YOu3ejyb8
zZraZXmW+KcfhsOJ2IS0NMttV2JnArWIgFtlWC1nYw1cbETJgy50ma6z0P2xcNKl
P67x29byfqtbDZtdQs96B7GDWbSwdBc2FWfG4yBJbxynczQ9SQh0aamDRSScvUv7
HvvkZ+jH3XNiCw76yCq/
=AkeI
-----END PGP SIGNATURE-----

--C7PTD44AewjTsiSV--
