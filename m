Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab3AHLQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:16:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55942 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755777Ab3AHLQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:16:01 -0500
Date: Tue, 8 Jan 2013 11:16:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] regulator: max8998: Use uV in voltage_map_desc
Message-ID: <20130108111600.GQ4544@opensource.wolfsonmicro.com>
References: <1356685743.27172.2.camel@phoenix>
 <1356685820.27172.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/YnR2r17TIEndSCI"
Content-Disposition: inline
In-Reply-To: <1356685820.27172.4.camel@phoenix>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/YnR2r17TIEndSCI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 28, 2012 at 05:10:20PM +0800, Axel Lin wrote:
> Integer division may truncate.
> This happens when pdata->buckx_voltagex setting is not align with 1000 uV.
> Thus use uV in voltage_map_desc, this ensures the selected voltage won't less
> than pdata buckx_voltagex settings.

Applied, thanks.

--/YnR2r17TIEndSCI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ6//hAAoJELSic+t+oim9dCoP/2N8Ib9wtiPuwf2UJp5+YLxs
XluOJyKubH9CWSGt0W9JrLtx/5e8bX+s8MNYuMTcIH5fhDmUymG+gmRK+AdPv46e
OINI+W8u5tq3lnybqKiw99YNPaZcFuMv1C8dODyrBzTWTWpmXPYXqGwmpF4jKMQJ
SvDLwvqvPueyE52rT3+iyHVqCL/il5kaylfz5WJgUO9cPQente4uLY9OBqsebJht
inQWJoQivIGV3J43+8xwjTMDn5u4BnD2I9jBDyhPL6agOIfEjMaPEfihz98uFou9
CsrV5cqquUMADz1OF6O9BCkfK+YG1m/qljU4Pa5iEXPtIl4/bcHv5t+3BEkuVMV+
K05xYuGiLWDmHa2nLeLDZYs9qZlI0qzgPq8+W2lfwo1O6HWC3LSEgVNgero3ZtO3
FqmvjzsxWqrMCR8d4Tzx7P0yA1YtF+IQUhvAxI5icrUZYOf1qUtRoQJOFhcE6jHe
9dfQSPU94Ywc6XxYryQRybzpCaT/ZNoEdK8v8mDKV/si37XO5+DoA03PWw6Kfi4q
S/Wz1cD5Z2qxEkhUAfK0/9VHhhgvBRjWZ689eOxT4Hsj5/TjmOrAA/unWi/0TLlv
w/VwvfL9B0C5skrujZlOE2/1RTngWNglL0C5k7SyG/RmXZSJfttu5qproIYO9Tej
aCzq1LRcfHmetqYVa8tS
=aNB2
-----END PGP SIGNATURE-----

--/YnR2r17TIEndSCI--
