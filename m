Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab2LBPPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 10:15:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43821 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484Ab2LBPPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 10:15:37 -0500
Date: Mon, 3 Dec 2012 00:15:32 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps51632: Ensure [base|max]_voltage_uV pdata
 settings are valid
Message-ID: <20121202151531.GA17981@opensource.wolfsonmicro.com>
References: <1354265569.3859.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HENu/cXyPKFN4XCQ"
Content-Disposition: inline
In-Reply-To: <1354265569.3859.1.camel@phoenix>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HENu/cXyPKFN4XCQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 30, 2012 at 04:52:49PM +0800, Axel Lin wrote:
> If pdata->base_voltage_uV is missing or the settings of pdata->base_voltage_uV
> and pdata->max_voltage_uV are out of range, TPS51632_VOLT_VSEL macro
> returns wrong vsel.

Applied, thanks.

--HENu/cXyPKFN4XCQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQu3CMAAoJELSic+t+oim9sUYP/0XuGQMubLOmQLl/PMfPK/Xf
Q49zaGx2tjq164qTe6PpzY8hZBLkPF2HNqhPiIaFd3mhTiY7RJtlHMouS80Rrvho
c+VuLbjsJk9V0FrYczo8+UzApw7tZ9sQ3VXAcv57SdkO8SQUwifrl8mq+DfO8wM3
FKtUaQedBQqaiHC8l9FWvDhPm8uMhvYahEVCACO+RPzMAHIzO8WBs5k8ZJ8BlmE7
bryYFgI3XRTp1olTYHz4GHkSrmS+sazxaLoHhYX7WjUw6C8JgoA2GwuP+pkqALGT
A5c9+4dSey3yy8M/aZUie8Kx4kRasKLzIaWL4ynz6lEgy7aSp38fUu99HO6zf/oK
TpiAzCCgmaX3JTBTy2+9Y7zke7QuxXjqCcpShlZuUps9XalQXiaW106k02Ur+Mu0
bNhfo2vf2FB/laJajMrKtDBRXSfXdhvRiVvaJBqi8vgMu9yTr/zs6JFvVxKVp6TK
bWECPQQYQj7Nc49GzYX4bnLRPppAxUQ1Msaci9Ffh1pjkUVvYMNeyUefZtXc4cGv
cIhu+xtQQ9I4tzlrYr3RFA5b3Z6QgA1oY0NlN4ZlYbfO9rXw8IjySjprn4TUafSU
tUO3LbpyB3siWX86Ui8T8YtqpYnYflXp9DjVlI3MUO4tmRtCPvKh7ynJimOgorGd
UcwHaagqNEAsWQ4aCgNU
=/c5B
-----END PGP SIGNATURE-----

--HENu/cXyPKFN4XCQ--
