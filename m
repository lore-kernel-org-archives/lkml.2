Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab2C1LBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:01:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41185 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757771Ab2C1LBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:01:52 -0400
Date: Wed, 28 Mar 2012 12:01:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: ad5398: show changing current in uA
Message-ID: <20120328110125.GJ3232@opensource.wolfsonmicro.com>
References: <1332814105.21855.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6iqOn7HZPWKXx18"
Content-Disposition: inline
In-Reply-To: <1332814105.21855.1.camel@phoenix>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6iqOn7HZPWKXx18
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 27, 2012 at 10:08:25AM +0800, Axel Lin wrote:
> Integer division may truncate the result.
> Current code shows changing current is 0mA when selector is 1 ... 8.

Applied both, thanks.

--d6iqOn7HZPWKXx18
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcu9cAAoJEBus8iNuMP3dwAcP+wW2RclanD1ng6XGVf6q5wgU
t8P17y+auH9yMhK5wkvloUzSpCtWlUwJ87zx/R4K694paH+8yjrrUnMyFkigE4C2
OYm2ZpSNf554u76d89FUpoaA9SKmWL2yMD/KTPMJNPjJ5tGHHTJcTZC6H3HKcEfc
IZmku7Pkv3y+stKRfsOoGhjMIIgddFq55u3C8HxMMMGnhkw4dS6X6meFGsRPMcx7
dnQFAQ9j2kax7JDIBiDzLz8aNerHgta3Brx1cA6aycOYC3MAgwUUgNF4x5kGqeDK
Sh4wtwvuPpURYGYm8jAmR+mGw6qSwe8EcEW1uZ2WDfgsBPNCSe/viIHX+UhI6kbP
MO2aXHA6ObKW/iu0irXqajuAYOgkPjFF/xAvAAdPF3jYQUIO2yxZmlYutuVgJS/9
vKEoJpSf9h1foSyXdnNNY6N4O2dsoPCXYbQPlZvw7ZMuxQwpMSrcg5F10O+sn9uX
CLwzZXyXhMmnVqkMcg46B0kvYSiIlvyY3DMccPFjUIm0ohZI68RfVGRZqG2ylKPz
Yn/FVMWXbkm5rA3y3mEQyIYwVTqFtzN8OzwFHGuVc5UkzGTdOaua2D1GZ3X9vJ4X
eodm60IVZPYfEaAmaVO0YMkynyUYfiGwpyGQg0Ke5/3clDIK+ERCxDE2f9sgyf+j
KtNS57IByhgds2+hK5MB
=39n/
-----END PGP SIGNATURE-----

--d6iqOn7HZPWKXx18--
