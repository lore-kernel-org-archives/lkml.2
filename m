Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab2EKPJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:09:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35008 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754237Ab2EKPJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:09:11 -0400
Date: Fri, 11 May 2012 16:09:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, linux@arm.linux.org.uk,
        lrg@ti.com, swarren@nvidia.com, olof@lixom.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V3 1/4] regulator: tps62360: make init_data of platform
 data to pointer.
Message-ID: <20120511150908.GJ3960@opensource.wolfsonmicro.com>
References: <1336718325-8372-1-git-send-email-ldewangan@nvidia.com>
 <1336718325-8372-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W13SgbpmD6bhZUTM"
Content-Disposition: inline
In-Reply-To: <1336718325-8372-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W13SgbpmD6bhZUTM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 11, 2012 at 12:08:42PM +0530, Laxman Dewangan wrote:
> Convert platform data member regulator_init_data to pointer type.
> This will avoid the copy of entire regualator init data into
> platform data member when adding dt support and it can be achieve
> by simple assignment:
> pdata->init_data = of_get_regulator_init_data(dev, dev->of_node);

Applied, thanks.

--W13SgbpmD6bhZUTM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPrSuOAAoJEBus8iNuMP3dYGQP/AhY7sgQoJ+xqtrcIam98jPl
BbwRakm3ymbWyimAsZlTGeFnI6uILRmOA6VJQu83p/PZuEshRy4Ro4osLU/20QIJ
kai28N3XFqAm+nBGn4vz6dDVC4ehK8bfnqUpnY+rAIGl12q4/uft19apT1CSVSdP
dUcwu2qP5/lewvA8EK9UTTcU/jz7uY2+LK23us2fiTx6Mf4yv1xN3CEJgbaww+rN
o3LEn1G8XOAktH97zRyXrcoimnuX8reN4HAQjHS4k5IvxZnK8dgkt5lIhBAtHVeH
OUf2EXHTujyKIvuR3ZmCgjDKNFAa7aC3BdqK8v7vUg2k0GnW9Y474t066d+F04YF
vSc94DGKz0w7/OCy1Ussvi8xh8D2N2dHLvXt29eYv6pus1UPBjITtdLtb89as6KF
Ltuncytzl6yvxpZBQtMoNgG/FBQUMAzLV0jLxlig/GeG2Xjtytri1NgScEHoNShC
vIWUPrg3ZZPnwMXXaLd7fiVlJDOJ6a87XGZSDLrOxpu2Ef4pz3MHPnzlqvFFmpyN
PZRZxfNlisHhiL74QpwQ1httWW2DnSsK9LH0c4XA2sOv0gUrxeHnL1mXW2yBY2lO
v7cOKuOcwj8rIPqHkTIICOmfM5zLtyHioogp2HJszKs8IM9rh704gXGhfskvvt33
tTURC8nsiU5B9VnzOObT
=Xzmp
-----END PGP SIGNATURE-----

--W13SgbpmD6bhZUTM--
