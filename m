Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab2CBLXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 06:23:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59773 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932307Ab2CBLXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 06:23:52 -0500
Date: Fri, 2 Mar 2012 11:23:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jin Park <jinyoungp@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Add a pointer to aat2870_data in struct
 aat2870_regulator
Message-ID: <20120302112350.GB3230@opensource.wolfsonmicro.com>
References: <1330651724.6247.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Content-Disposition: inline
In-Reply-To: <1330651724.6247.3.camel@phoenix>
X-Cookie: Chicken Little was right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 02, 2012 at 09:28:44AM +0800, Axel Lin wrote:
> The reason we add *pdev in struct aat2870_regulator is to use it
> to get a pointer to struct aat2870_data.
> Save a pointer to struct aat2870_data instead of pdev in struct
> aat2870_regulator, this change makes the intention more clear.

Applied, thanks.

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPUK2/AAoJEBus8iNuMP3daWwP/3DZNg7TqIVVl6onXx4jaQtN
XCZ/ZOT6/UmcrcSaoHNogd/Lr96px1xnlI/4JjweeqSc/tN2Ui45pELR0Lhxgrzg
SuArBhfikHZdKS2Kfi+zk5/EJKqSox5UsXRdpaqkjE29ZT/rzA7E4h57TxEowUlR
L6sV6U/+KgoldUZJ+jKNBmi2NuaGcInWww55b7Q3Iu5Q+I54nozpM8DDQUyi0Bqo
zKunadIZo9df2hAuCUEAfjSMfBDcwJmpuq9qiSjLeCHP8fFfKKLvlbb1saUUEUe5
/lNLLe6v9K0XHy28u6PdwxhHiATFQj75JxFYjb9YGu8uK8QLEosQSr4Z0vdfUmQt
5HJB11mEVy3XyUmd8XGHPmHqASb8kTweCi/HqfOz+V2rVLKN0hw/m9l49Fzcaxh1
U6h6aIbEmh9wRx48E9paQMX0UA0Mg2YgAq4YrrAtjLYxEAei3jkDWdjMUkucBBxu
0LISyUG2xb19aY4yyImMD57hi8ZX5jEx881x/t00pDWdBgv6RmJJ987PM0abBTR6
PcL1B37YwJD5BG363KjOUIOk7mvf4dwierl/hgj/79GilMPsrPPqVsQkqL+DKR6G
h+neq6H6tPvzP04NTyTJhdDcDPknpDFX6n8Ge94HlSf0L8CZg9bkshlSIO0Eiym2
UjNGulp1EfKMmAORiuzr
=Xfih
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
