Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab2D3VrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 17:47:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55960 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756712Ab2D3VrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 17:47:22 -0400
Date: Mon, 30 Apr 2012 22:47:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dd diasemi <dd.diasemi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anthony Olech <Anthony.Olech@diasemi.com>
Subject: Re: Linux 3.4-rc2 register mapping and paging on I2C device.
Message-ID: <20120430214718.GB4414@opensource.wolfsonmicro.com>
References: <CAEqHmAstczdi2seTHFE0-jLK9fJaKosHjJyo4AJ7E9UKYBrVsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
In-Reply-To: <CAEqHmAstczdi2seTHFE0-jLK9fJaKosHjJyo4AJ7E9UKYBrVsg@mail.gmail.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 30, 2012 at 06:31:37PM +0100, dd diasemi wrote:

> 3. Update regmap API to enable support for register page switching.

Clearly this is the most sensible option.  Open coding this in all the
drivers that need it is going to lead to a lot of duplicated effort.

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPnwhfAAoJEBus8iNuMP3d3tcP/3cu3b7NYlOhxcJSq9+wWubq
z1MvJn30oBR+8+9JYmIIBM2H/hYr4YkKgEVeRWE7G1NQiWpeNvuK9cPdPmiRzzBc
yqy88W08u5e1PjFoV81RtyPBzAd1Hyo3lFXNjsLpSk/R40utY4ErWpGXAz9e67Qc
gH/hb7HKJYaBEthuIe07mNAwwn+wnf4YcIW4250Iaal1euyG4OGZLdXdDJKhZSbN
eRGWayhcqE+RFZ6RGORYravwqTEvZ+l3+wESnYvXCNjxHAPrbmtIxo3POtQzAV4V
An8ThmfUsCtz+eBnewJ8uNyPSn66IIO0AMZQI5GT1jZKu7pJnS/HP3WqX38fILG4
h9ix1jdioYxnXpD31C7t/b8zGsUSGOT2qCFYmj0npVisIzFF/wjRJCdX26Iuj5W3
CTWAvFLD25ulEZJh4pKqcN/SNlAVOtODxms4Y7GizJ6xatARYk+1BY3iekSd7BLo
XoHHO2tL8UR0TiE04lC+rAdc9M+WSS5mQjCI7W9gQ6fpo3jPLZK7LFYpPC4Z8/p9
lltqb3rC4opXtUH2OwxHtREA+cesWqlrLeaGYz/Mll5bEzavhNBx+Lyx0DdhZOjl
L6W2PGq5v58HpYSVMFY7mQPJa2Kvmj5AILxRnYlrBDCDu7dfCgoSFAOafUBqm9gf
G8Lp9rrx+RZcfvhSSiZ8
=k0m+
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--
