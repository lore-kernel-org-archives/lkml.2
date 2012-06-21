Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab2FUJMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:12:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44388 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932316Ab2FUJMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:12:06 -0400
Date: Thu, 21 Jun 2012 10:12:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: boot_on regulator constraint vs. regulator-boot-on DT property
Message-ID: <20120621091202.GF4037@opensource.wolfsonmicro.com>
References: <4FE238C9.3010408@wwwdotorg.org>
 <20120620234648.GE4037@opensource.wolfsonmicro.com>
 <4FE27835.5070705@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hK8Uo4Yp55NZU70L"
Content-Disposition: inline
In-Reply-To: <4FE27835.5070705@wwwdotorg.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hK8Uo4Yp55NZU70L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 20, 2012 at 07:26:13PM -0600, Stephen Warren wrote:
> On 06/20/2012 05:46 PM, Mark Brown wrote:

> > There's no great inconsistency between the two, this is only
> > supposed to be used for supplies which are already enabled on boot

> Hmm. Perhaps I was misreading machine.h, and "when the system is
> initially started" refers to the first firmware start, rather than
> when /Linux/ starts. If so, then yes I can see it isn't really
> inconsistent.

Yes, that's the idea - it's for telling the core that everything has
been done on the basis that the initial power up state of the system
(possibly after some intervention by the bootloader) should be whatever,
it's not supposed to be an instruction to Linux itself.  Linux should be
using consumers or always on.

--hK8Uo4Yp55NZU70L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4uVcAAoJEBus8iNuMP3d1h8P/Ak7IjZVQ1VIU2nizLdNQEaH
1kQ9Be1fqMNceBBRB5Sgp9VutFCg9MQYgXIQFgzJedwgwl4BOvWuPNQYNHt+7azi
x8ivflCdsTFiKfMsr3UrtJhBY4rCGt5lwpnnxUJL/s1wfBtTFo6NYJsKzFscUwrJ
gMmk2MuUGiaPnj3ODIOK2AvQWGya9BIBHgtwCxVF/jZsXn+dGb417PpI1vtAnMOS
rs0dDvtdoMXH31ciIqSSPcsFyRb2cCgOlMn79r5RGwj3zhFHbqmNfyouqlPx/MF2
ewolUjlefF9badKQhsRh5KatvXNz3fnYhmlRh+NVWXl3ygfDCGqNon2hneARAkNS
X2GVWSxNCGta0NBkRhluJrfbFrBq9t4g+M6z5nNGmvwtUANSqU7g2WGZSMfUVOQ8
QMW7nGFeosLk+NHpGTKbut9AKSEi8nKX0csGvd9Gp+WuaAbds5MdCOyjjb7TMEhc
dBnjTsyRG2/XU+mzEbYzXqTwp+Rgp95iGtB03OtCy/XsRdG+GsAngnxx2Zz6F9h7
FPwOsSPk7MQvbwYqqRzhSPJKQHzILS9TpDu0J4eEe6UE8XsrpHge4Z5Rk96yruIP
Q86LCR5z0aG/be2JhBBUu5+0kWQ03URvrwtwRbqEMDF/xzUrRgCT6gtZY0pD07Qq
Tgv/JcyWGZ1dGaYdGwTO
=VECD
-----END PGP SIGNATURE-----

--hK8Uo4Yp55NZU70L--
