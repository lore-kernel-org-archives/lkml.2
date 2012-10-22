Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab2JVSFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:05:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab2JVSFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:05:03 -0400
Date: Mon, 22 Oct 2012 20:04:56 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] spi: tegra: add spi driver for SLINK controller
Message-ID: <20121022180456.GA16735@avionic-0098.mockup.avionic-design.de>
References: <1350557233-31234-1-git-send-email-ldewangan@nvidia.com>
 <20121022122825.GD4477@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20121022122825.GD4477@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Eq8hStsRH+BMnbpsuCvlB6I5BSxXb5jxBW83WuRV97x
 /nfaEsruA98C0fouoIPFqtnZoKsiaYxhS9/SJxP1PTrFDjzIf9
 DcBQ+M/YIbJvK6NvsiNPwS3EfT4IZKE2fH6sdniHMF4KAGbV6K
 UAzLwYtVEJkKmLFY+t0QeFZRPVxOq8olOoWBSxCJqMvyKRJgRC
 gZ5CZ0zaUNjKFeoplAPptGyUIFy21xDHewmp4SzEZkLIiVy+Or
 jK3/Uq59alOsm3vVPQ3FsXSLMlEtSZp/bGbl6P0bC6tVcVZukO
 MYnEt8vLSzN3D0lbqPNeGcANSIPs8MH4eZkSP8VlpADmspDqgw
 2KvNJ2COAf6KWieApo5dRyVTdRMduJIN7+NhDCq42aAsmFxeBq
 kztMaEpnPt7Jlmv5Qtr/y77nEDymrQChGIyZqzBVMrJAsueO2G
 b+Xc/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 22, 2012 at 01:28:26PM +0100, Mark Brown wrote:
> On Thu, Oct 18, 2012 at 04:17:13PM +0530, Laxman Dewangan wrote:
[...]
> > +static struct tegra_spi_platform_data *tegra_slink_parese_dt(
> > +		struct platform_device *pdev)
> > +{
>=20
> There doens't seem to be any binding documentation; binding
> documentation is mandatory.

Also this should probably be renamed to tegra_slink_parse_dt().

Thierry

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhYrIAAoJEN0jrNd/PrOha2wQAKki4XBdCQf79grlXRu/crBA
FmtQrnLcI6Gt+EOmT19Q39XCXb48OH05jBYuDWZZV0l/NJIdg5XSkZhxfobxdQXA
wg5bHBFeiRHtUBqiC/b+Or+Jo4PVGtFETyvKVNNPBaLTj7NpyLP8ezFaJVfYDktq
suDLxlBcNzQjn6D07kyQijXiSlmMQU7Ci7yk3/Tm3BwYzReUzfg43lR9RBI+ptP2
DKnT4VdSzPxXGuarjV2CY43dABs13Gm5sNA1taNqleXsLmZbGTedqeKdo0E4sqF8
qOCzkrocX//xeIISdqmZfG8eI3LvizjAi9BIhADN883y+lJv5KX6GRxUXI6jJWeC
fMaJ1pEHhGg1R6IJJECKy2anz2D2H2NKJD7rKVLX7DAi2R8zcPq9Kr08N4tX9lJi
T4pgjgWxBhUobr2dUjX2bp8xtIqjMh7W1UFZzlahK+J1zRav2A3uEXQL1mUrkm5f
3UCmnLOadtD03tssFT2LBOc88LDe71e70Dl7DvNYLWuhCZuQRCR22YHy7EPsv+pa
l9rBHt03KfJZ9eOTV+Ig3fDFkhqJMpdU35fIZrYyLzvQJEglGs11MMJtWkodGw2Q
nYBA1k91Iw+gr5k58ePJu4aDVb5XpTc2BMDJV4OQHLtqVUwzkiGj1V87othrfT5j
jwldxaskbirg7onkRwjt
=Yv1o
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
