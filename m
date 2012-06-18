Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab2FRNJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 09:09:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39660 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828Ab2FRNJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:09:14 -0400
Date: Mon, 18 Jun 2012 14:09:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Message-ID: <20120618130911.GP3974@opensource.wolfsonmicro.com>
References: <1339558031.26190.4.camel@phoenix>
 <331ABD5ECB02734CA317220B2BBEABC13E9D83E7@DBDE01.ent.ti.com>
 <CAF+7xWkh6CHvcur2iDs0Nwp_nO8i=6tYyTVauL6qtyrrMctjjA@mail.gmail.com>
 <331ABD5ECB02734CA317220B2BBEABC13E9D84D9@DBDE01.ent.ti.com>
 <20120618124513.GM3974@opensource.wolfsonmicro.com>
 <331ABD5ECB02734CA317220B2BBEABC13E9D8516@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r/w8vo2lxBmCPGjQ"
Content-Disposition: inline
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13E9D8516@DBDE01.ent.ti.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r/w8vo2lxBmCPGjQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 12:56:40PM +0000, AnilKumar, Chimata wrote:

Please fix the word wrapping in your mailer, it looks like it's wrapping
at 81 characters or something.

> I think it is better to set in regulator it-self instead of these checks + calls,
> this adds extra burden. So, regmap pointer set should be added if we are adding
> regulator_[is_enabled|get_voltage_sel]_regmap API support to the driver.

Yeah, the goal here is to ensure that the common case can be (as far as
possible) data rather than code so if there's lots of drivers doing the
same thing the core should do it for them.

--r/w8vo2lxBmCPGjQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3yhwAAoJEBus8iNuMP3dBBAP/237LVuWGtijGByK739c7k9G
Ctn69TFHklOLY7uGOSSaUZM8rTlURgkIyljRLe6bas++kYkSctHT+v3b50T0Ks08
D8F4Oz38ORfWAkqFRL+zdQziw1lDGC63LdheSnO6YhxnPpQ8tzX2nNYTR1raKTSL
+XWe6RUBdxGD6nNtPAfwiLX6qgMsWT7pvV+TOOChAe2qGoFsbYtsEsSLgvXqVkCC
B8W9mV4rSYvCwOfYog4yPmqh77zawjS9im+WH8feJ7eAvRCiRBCnDaWE8fW7IO9X
URnlo2XH61DWW3g3kkCAGfMZn11aOEZZgB6r8kSKWw3FKsQC5y/+1Tl2L2rJ1QI2
H67AOUEVjTahs1bj3mDOszPe/FmXX+sawKWNt6G3g7WpApZBxLdOZModsdcM/cr8
7wNCC2CBDygWgEpvrzyD4ZdU0E9LUd8WR83VwcDrecQX5lnDIqSjZPzMXRasNoWk
HdzfZvx1ThFfhJdOSsMLVdR74Td8UBaQlZk7RMhr6eqYGaTgYdtW9aINgNw768fr
bFYI1+3TFhZhtjI/Tr1wZ63b2Qg/mjgAymDXKNVKDNp2KfaiXgqk8X5Mw2h+0C8P
9F0YNI9iX6bR92eJHCx7mhYLo1C0pHqf1QhLtI4D4iJBECd/T6tvke0tGDz7vunl
fdvfpMzsXP12Xww4S7OK
=E6tr
-----END PGP SIGNATURE-----

--r/w8vo2lxBmCPGjQ--
