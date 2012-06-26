Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab2FZKtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:49:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47758 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931Ab2FZKtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:49:19 -0400
Date: Tue, 26 Jun 2012 11:49:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT] regulator: s5m8767: Convert ot
 regulator_list_voltage_linear
Message-ID: <20120626104917.GQ30406@opensource.wolfsonmicro.com>
References: <1340000727.18659.7.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHmdSDY+kY2au76U"
Content-Disposition: inline
In-Reply-To: <1340000727.18659.7.camel@phoenix>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eHmdSDY+kY2au76U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 02:25:27PM +0800, Axel Lin wrote:
> In current code, .list_voltage and .set_voltage_sel callbacks for BUCK7 and
> BUCK8 return -EINVAL.

Applied, thanks.

--eHmdSDY+kY2au76U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP6ZOlAAoJEBus8iNuMP3dojAP/A7McCw7yPSNkjVjbuCGNSgX
h9G/LWHOi+Mp2sQajRxndC+ft1iGaEXFdnSO3aK1dHMNvvYcdBQSnfqFh24wOytU
ZYfW9tGKRW+GekW9/7PYlafRilSFWxDWiOzx0AxANZk9A95z4EoIvaAO86okk1Bl
c55Tp/5Qzv2S0O4zWUhOOJHMf4qtJwqjQgkF5rJIZo2gtmuaPN+aUwOZwlDZoFoI
W0iMTnd9ulJ2/ONuvXYlGU3z94pkR/eThrm+8b11czvfo7YuliFJydbu8YqUhH4Z
cWI+Tn6D47R8+mNFsC9pk2PLmBJWn6wVzOEWY6nVFer7bjS9q+Lfs0EdccpgzzSS
VStLV4gZnbcnmgdJ2IKP7DROTmR6/6l2VAXfMI87oq0o+fAYNwMWJ9tEaUajuqzC
ijxzmxO2KyBYKrw640Fh9OZpzOfz+YF6+Ib2LoB4JZlqQLjHK+WYBbiwjwH98pYh
z/68eax6vw4afdxfM3/XExVShRwrmR2PpQofHiREnRVjhQx/e8+6jUCzAToYfpS/
M1dh7NsE++1VKRVInOkJkRoooZuyIR/SodKZjaHA4ILVlbP18D93KfG7/TFlAYqW
ljgsUBUighcxgdCP6hKfmH2LyPT4uTwsBOk2+WeoiPKDHErKIqi9Aw2w+uX+xgRJ
gEZGwZstrSrw+AvRw3aW
=+W/D
-----END PGP SIGNATURE-----

--eHmdSDY+kY2au76U--
