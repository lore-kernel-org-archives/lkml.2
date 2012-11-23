Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab2KWMPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:15:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57674 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753452Ab2KWMPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:15:10 -0500
Date: Fri, 23 Nov 2012 21:15:06 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] regulator: add a regulator driver for the AS3711
 PMIC
Message-ID: <20121123121505.GK4529@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.64.1211221107520.28453@axis700.grange>
 <Pine.LNX.4.64.1211221110330.28453@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3hAdtgBjtgL7p0NQ"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1211221110330.28453@axis700.grange>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3hAdtgBjtgL7p0NQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 22, 2012 at 11:12:08AM +0100, Guennadi Liakhovetski wrote:
> This driver supports the 4 DCDC and 8 LDO regulators on the AS3711 PMIC.

Applied, thanks.

--3hAdtgBjtgL7p0NQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQr2i6AAoJELSic+t+oim9bkAP/3uX6bzE8IAwkkOdkfjrWagE
r4vlTs9JSepjPnqlVbs+8R8OWDmlei6Hd9nTuchbkYnbKn8wgZ2y4w3b1IpnpLqC
k5b1Gki9Wclk/ED0naCrKXmHiMcAk4hsCorfQQcctZk3a7+t2DxKSvGA8xLn2Cf1
IiSO+mPXzbYJUWysZI8d/qZyxl0DVv4hfl4MASxC6X/PXEiCBOf9AqTy3do6hOaz
IwRgpycB2SwLntFYJOOYX2gfjXm3OcPzEfaB8LDQsTOkQQckbBdA55njZgWmai/t
/b769eZ9ee9TszqR6S8REbHTRDy/ZVbDUFBtS9zxKzFQ5YvvzicoEsjzpq7QLiKW
SUpgTlWaJGcLYmQxTL+dqT01wwv5Q+kFKkyeFWo1AQcoSBs8OIihiwOyjDe1rHgC
AYZPtcCUlFa/kgTZTM7d12lAs3yezIXbSDgWlG4FIKFPkuzxnca5UEGsKmJDaI6h
eTn//Z3etSG3OkmPgj4jN0BBKMXyoaIrBlsJXGK2u7kLmNu3qYpTIWvQli+o71PB
uGgxQUVY/wyeJj3f4OsalMxuptKWJDaG//3dMgNSAQ2V5TFRVKbfd/nkn7fmXKat
/h2c8pHP48hCAuwIgd2tIwn3P7z2waHzU29WbRqwlR8ZV8b4WvgZ+YEQ+o/QpetZ
reEE5gA7x1CMHvaawN4s
=cZ6O
-----END PGP SIGNATURE-----

--3hAdtgBjtgL7p0NQ--
