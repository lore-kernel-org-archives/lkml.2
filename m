Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761732Ab2FEKWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:22:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45398 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761717Ab2FEKVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:21:45 -0400
Date: Tue, 5 Jun 2012 11:21:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Anuj Aggarwal <anuj.aggarwal@ti.com>
Subject: Re: [PATCH] regulator: tps6507x: Remove unused min_uV and max_uV
 from struct tps_info
Message-ID: <20120605102143.GM23408@opensource.wolfsonmicro.com>
References: <1338856792.4166.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C01fF7hLGvN0zd9s"
Content-Disposition: inline
In-Reply-To: <1338856792.4166.1.camel@phoenix>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C01fF7hLGvN0zd9s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 05, 2012 at 08:39:52AM +0800, Axel Lin wrote:
> The min_uV and max_uV are not used in this driver.
> For table based voltage mappings, we can get min_uV and max_uV by
> info->table[0] and info->table[table_len -1].
> Thus remove min_uV and max_uV from struct tps_info.

Applied, thanks.

--C01fF7hLGvN0zd9s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzd2wAAoJEBus8iNuMP3dO9YP/jP++VHcLhNisFrM9qgE/Bz5
9GdUjGpFuIBnwUe9gv+eMAThWk4KD5EB7yStZMjg/boItK/1iPS5ffw3ZkTMsLca
WZ7KbnWDRZbBAeyySAxHXGP6uuqSYOxU6GZpZRl5yV8wEt9qowNFRF25oQaSNU+C
R8KxsscCSjh7yw5+7UvAliiqCPbPqnzouHf4tQjP/8nM3o1CzUDdtGzrL50HLIuz
TJWb0W2WTuUaN2cCxBcc0L8BJGEajcNrXASbQAcRpY6yjpnd9wNr0Yq5cwl/56X8
93b4ZZwo8myNqgZesyI+27nyoZ7+KVj/rNy3wTbqN/li/3V0iHX6L16oKc+5sdXi
MnN0Lh8Ry6AJgf/s3m9XKSwd0CO2yKMdVwzoAB3kxvF7wyvrz66AJJgk3doEbDxF
BWO+McjJu+rMB5bKgjYzn4AHuYyjGe4HZlLIHEnh3YNz7mn6Cm9EnOjl82roQ65z
raMi/Qm0s838f+Ylq2LcLEYXp1PU9OCqBC7ee8Cik/NvpxBgcZ2BQMA9Te/6iKpX
L4LVUL3biQJYB0a3aYogAEDzFBK1BvR1w++sK8AXtriBIPlRbfqsCIvKZyho3Jg8
yDaXBNeNZs1uExKnToqrkCVNHATrEUG7t4VcBoq9Sr2AoL7R1I5n0cRJuRCXZMyX
ERC+kwWpRJM/2Xmr1g9a
=YWvy
-----END PGP SIGNATURE-----

--C01fF7hLGvN0zd9s--
