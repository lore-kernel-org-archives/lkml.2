Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259Ab2ERHgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:36:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45250 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753584Ab2ERHgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:36:53 -0400
Date: Fri, 18 May 2012 08:36:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] regulator: Enable the ab8500 for Device Tree
Message-ID: <20120518073648.GD4073@opensource.wolfsonmicro.com>
References: <1337262323-27692-1-git-send-email-lee.jones@linaro.org>
 <1337262323-27692-12-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lMM8JwqTlfDpEaS6"
Content-Disposition: inline
In-Reply-To: <1337262323-27692-12-git-send-email-lee.jones@linaro.org>
X-Cookie: The time is right to make new friends.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 17, 2012 at 02:45:16PM +0100, Lee Jones wrote:
> Here we setup the ab8500 regulator driver for DT. We first do
> this in the normal way, by providing a match structure during
> initialisation, but then we provide information so that
> whilst probing we can use existing data structures to do DT
> look-ups.

Applied, thanks.  This and your previous patch look really good now!

--lMM8JwqTlfDpEaS6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPtfwCAAoJEBus8iNuMP3dMFMQAJ4rj+qT4pLKPVEllN6c2+G7
thkH8gisWBGIb7jfImxPxO5EGUHazZNQgzjskvrNfZ4MPS147z/fT/82R4KJEGFk
q6+0LvGozNAnHbs6YDmzSChWZGFO/xC1W0wmcZmqoicW6Gnk7D9Ze9FCfE0/jgK2
7WDwcA9neKdbFLEReHkDbX2u12f3kcBtQMHBfzYUMh8a7LoYGJu6Jlr7u+5baoK/
0/e9KfiJriQ6sPK9nN6DgNHCxg0iglQbzkIQi3MbLWesKZb940oVwdnjIC7xgxfZ
i6bcpsx56xTUZOJEbnrZhFCajMGpe0MYe/dbSS2x7ArG+NnIwjpCkCyVZjyVDHbs
+kuUd0TgbJkPsnQIK9MG+Xnw3KFBVk/+bUcyyS+kyOcZur/t3BokzHP9GluwDMaC
VM17wru2ALm9NTIK1iHaRbjXc90nAygucuSSNT8DWCu6cag8UZZIyvtCV8Jy2jFR
Ve9U7qtchGAXPk6AyUtMjZhvk70Zf9RPQ/ebwK3k79iMKN3LhAMZ4DSG6vxPc2mc
KBcpZVd1kdm8NjkLf8ovy0hO6cjTn4jBZcAAOylekBOIw9RD7wu0AYOLY49Hf+g6
4RLKeGHiaqIpE/D3qafhX/KzIfJg24+ikt96CR1MG2mRec0Tng0RdPcpJM5v9ba+
HeqU9aotJeuqUH0c5jtF
=4hhs
-----END PGP SIGNATURE-----

--lMM8JwqTlfDpEaS6--
