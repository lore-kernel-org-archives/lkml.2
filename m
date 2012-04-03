Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2DCMpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 08:45:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47782 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559Ab2DCMpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 08:45:09 -0400
Date: Tue, 3 Apr 2012 13:45:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org, Anthony.Olech@diasemi.com
Subject: Re: Regmap group read and write issue for special case of PMIC
Message-ID: <20120403124505.GG3192@opensource.wolfsonmicro.com>
References: <1333456539.24292.24.camel@dhruva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gm5TwAJMO0F2iVRz"
Content-Disposition: inline
In-Reply-To: <1333456539.24292.24.camel@dhruva>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gm5TwAJMO0F2iVRz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 03, 2012 at 06:05:39PM +0530, Ashish Jangam wrote:

> This special case of DA9052/53 like PMIC needs to be handled in the
> regmap. For this can we, in regmap introduce a new flag and its value
> determines whether to translate internally, the regmap group read and
> write call into a series of single read and write calls Or not?

Yes, a flag for this in the regmap_config seems reasonable.

--gm5TwAJMO0F2iVRz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPevC7AAoJEBus8iNuMP3d5ikQAJCo+qDY/0wKA/V92htfPP2Q
p32RJ4Cj9Yr8+JTnCNVNqvjsqMwyDoPwoyRx8ydgKnVp78boU7HqrMXwgFxXzTof
Ydp79XQqnqLxpALMj/dK+ZOfGVJrW4kiofV32ZCBaXEExptWf4eB1Ixm3a8hORhU
S+niGM97rraF6Yr0Lh8owYrl45+HB9aJ15SsdW1+RG89msF+kW1tjhL0WyPO36Us
wxaqcSkg9tR8fHrGMm+Dky6du4DDAUorjKR0OSm4Gq6i4S2fg4gb9FKdbXn2JNGV
eaqsm/5ShKwqW02+KXyuDm3Yi2YOLhNoYqZsgngUiXgx6NLk1YYL3lDaRg3RZ/l7
2jHAmIcXbY5AB7YY8GxkDvMor8iQGQ569/MA2WW9FDNSovRfn0x3G348lD3EhQPg
LbIQ2d7Jc010gynlC7TbC26ErqY1msSnXpU+3LJRZAjYpChVMrhGvQ5TlweSWNDL
ZepijFlZj4hcm4dvQWSxMr8olCoZYH2yTzxII0ZCw99rSA42ekZx0R50JGcoRPrA
amj9pAn1ZSQI7b0c3hwIZr/4y6ZU6MYw87NNO0phCCd+3kr/hTmtZh4owZreiRit
cDE18sx20BFeyCOsNjt6FHddKtTNCj//pRqJJ33fWBr0/TL6UZBMkUpspsLATkky
lccip+uMotRWYd4MoYbz
=fbvj
-----END PGP SIGNATURE-----

--gm5TwAJMO0F2iVRz--
