Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2GQS54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:57:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45778 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274Ab2GQS5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:57:51 -0400
Date: Tue, 17 Jul 2012 19:57:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Boot breaks in -next from LEGACY to LINEAR conversion
Message-ID: <20120717185749.GJ4477@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tSiBuZsJmMXpnp7T"
Content-Disposition: inline
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tSiBuZsJmMXpnp7T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-next fails to boot for me today on my s3c64xx based systems.  Walking
back to the last time I tried and bisecting likely branches I find that
commit 910139 (irqdomain: Replace LEGACY mapping with LINEAR) is the one
that introduces the build break.  Unfortunately the boot fails before I
get a console which makes diagnosis somewhat more tricky than would be
ideal.  Any ideas?

--tSiBuZsJmMXpnp7T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBbVYAAoJEBus8iNuMP3dXCwP/1biIJ60713f1fjWBP5L7O24
sWsEhLzZTOIvAf90FBBUqJlkKacKg/o3WpSldhALXkpp9cwpm7tJ+hbH8jhWdcE/
lu9B/0XLCft+frmwwL2cQaBw12X9pB/C+wrGDkirYzQTc8JkMzK4C5QK467A5Jzm
+y/K2wSPa15mufglADY1ATVoNcTJ36FrR80yPkEYY4cYzTaDeKreb/2lk9QMhl0N
nHE0VMC4RxV8B/Y0G0t7zCLke6M/vvV2+KRq/DTlHUs9Gl+CqKUeGs5bmulBodRV
OuMvJ4RlzvWC1NJNfuaJHyT85Nlq4XfqSWm/b64SkaQdQCD1d2UKF8rmFrTezC95
aW6Nm/VbgiJ8DzLOzM1sg1Uo5lgUPCxAOAXJf7WwkP3PW7sZdpoVz8BdoavA47bJ
E8pKt5E77PXuNpoEkg2WHWM7jjbi6Cs0eLWvZeZElsi5Snyc/aj1Ch/PWYtl6Eek
c1EP7vxMJvFfHk1QwLuwF56vhzSP2YCT0WsA605gLUcpY+hpsGE+IQkr/W+kMoI6
ypQ9Ajq4ncw72cFPrH/YSZlzz+vcGOC2QaaqA+qXL7MsxPZwZcfaeA4unxP6cOI0
D3m6Ia9YQHMU35VKhmitUWdijDq3BWL4OO12f8beU4b1gFWsVVzm4oVG1Rbakw35
aCMqDi24IBYiy2ZAnUVu
=O1un
-----END PGP SIGNATURE-----

--tSiBuZsJmMXpnp7T--
