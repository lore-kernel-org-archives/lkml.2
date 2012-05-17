Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967336Ab2EQWBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:01:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50689 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965954Ab2EQWBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:01:47 -0400
Date: Thu, 17 May 2012 23:01:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jonghwan Choi <jhbird.choi@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: max8649: Remove unused check_range() function
Message-ID: <20120517220144.GN26337@opensource.wolfsonmicro.com>
References: <1337216562.5759.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+278g007AL/ykmV8"
Content-Disposition: inline
In-Reply-To: <1337216562.5759.5.camel@phoenix>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+278g007AL/ykmV8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 17, 2012 at 09:02:42AM +0800, Axel Lin wrote:
> This driver has been converted to use regulator_map_voltage_linear and
> set_voltage_sel now. regulator_map_voltage_linear will check the the voltage
> falls within specified range. The check_range() function is not used, remove it.

Applied, thanks.

--+278g007AL/ykmV8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPtXVBAAoJEBus8iNuMP3dc+wQAJVrxRZ5iwwuAYmCi/OPq74s
Cs7gXTGL6fyw1aQwippRb8hPhpelDQkqXS3AMZy78kklrjYlY4mDwe5uUDVs/fOA
AzJHiLixTREQ6xZorp3SZokUrv+Q4pUrioCaVogj8GmkFMNORDzvjb+x6GrFmTi4
AaAoRJj//a0tve9qU9JlMzici2+bvwirO7dmiAEF9HGGX/xig0dW74oxr14RCcUv
eRoJWN7v8wN1mQIsnBOb/3tBJ2Wul6iMCwqXXGvt5c9oiQxNnrmzd5jgcNwqiD/P
+qRmglrm8OnPMxu6aJSqRr/wt/pe5PrFCBs8LATguG0pFoMFFDbGQhuYYwwugN9Z
1TIV1PjGWPmRb7cUJs2hoYZiNqN1+xpdKfLN0AFBDRK4/CM0DszF1v5IwG7fZZrj
CnXl4ysTmZqg0aWWcCGHZYUC9KrmlqhdfI9jSkB3E6//igIEZcBKN9OL1o3G630B
HdZlZDyx1/wvolysIYNIYx60TspVf/ebikQQhnsTuZWJ96cGAAmqzfuFjJ0nfNvu
rMIOeCe0qfhEByt4gDa4CDbP+ivc+xPrPRZbGSpJATLjsBE+aTIUinkXGKINQEsP
yp42zPXd9DViBXRgYDh36nYNFpIg5G2VBxJBStw3V3KO3HrtZOe7BNUgNXccGnwe
bmy2jxIJAKol9puOfAzJ
=nDXK
-----END PGP SIGNATURE-----

--+278g007AL/ykmV8--
