Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422669Ab2GMOWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 10:22:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44776 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687Ab2GMOWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:22:32 -0400
Date: Fri, 13 Jul 2012 15:22:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: ccross@android.com, olof@lixom.net, swarren@wwwdotorg.org, lrg@ti.com,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca
Subject: Re: [PATCH 2/2] regulator: tps6586x: add support for input supply
Message-ID: <20120713142229.GM4215@opensource.wolfsonmicro.com>
References: <1342187432-18668-1-git-send-email-ldewangan@nvidia.com>
 <1342187432-18668-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VIOdPewhitSMo36n"
Content-Disposition: inline
In-Reply-To: <1342187432-18668-3-git-send-email-ldewangan@nvidia.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VIOdPewhitSMo36n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 13, 2012 at 07:20:32PM +0530, Laxman Dewangan wrote:
> There is multiple voltage input pins on device which
> takes the voltage input for different voltage regulator.
> Support to configure the voltage input supplied by
> different regulator for each regulators.

Applied, thanks.

--VIOdPewhitSMo36n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQAC8DAAoJEBus8iNuMP3d6vEP/3WoHqW4W3x1iLzifEMyf2te
lH8dIT7igfEemLOMyZGyWd2uIrtvliGKTs16r5uM/KL76CRXPTLiM2ExqUrVDNDb
l40YJ5U02ymf0qk2qp+3k0Xyd20PZOaUVV0vzOR3Gua6kycpzZBZ8Mno0qKp6U/B
XHY/FPZXiEFeRpL+OBIPxdDo+166ZjOzpbLLpRxtjU/K1W1lUr8Iglnw6pgo6f5T
FPF9HfRdj4fDUR8C+ly1VeTENzFgfY24dLD0HvzgryAZXSWJA7bi4FdyK86x862v
0b1uCLLThlgPJENSUxvYXVAmbPD+Fu9oeTfBgN9qy983fBNADIBFudVprGxsOBTu
tc6lqgX4m6hPHHTRGxQyWpOYUZxMKCNR2o3Mpk1ZE4ejDkGBCEsWgYxPyQVliUKY
d8MGG8vzY5Ks/URbiU3r8fVHf2xipF8c4I1hewvAkXstur0oGCdWmDMiXCz0e5uh
i1MpnPtM2jGR6s/V+y8AvdKIL64cfIvICZopJVJ/wioltCslUsR0oAyMnrr8WEJv
Ouq5fS6APFnUKT7mv7bSfQxBNURB0+Ez9m+YSgUbJyIicMWystE6Rmne9d4HPc3O
6FZmwcBjPoZHfqflT625FBDUnBPIqNm/u+Pbs6xP4XbWPFz08aZ7QZEu23lDHHi9
eJlcnszTMcXaIwfX5FQt
=4y1h
-----END PGP SIGNATURE-----

--VIOdPewhitSMo36n--
