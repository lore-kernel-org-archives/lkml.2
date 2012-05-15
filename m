Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab2EOSTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:19:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42169 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754402Ab2EOSTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:19:41 -0400
Date: Tue, 15 May 2012 19:19:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lrg@ti.com,
        b-cousson@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCHv2 3/4] REGULATOR: regulator driver for Palmas series chips
Message-ID: <20120515181921.GE19592@opensource.wolfsonmicro.com>
References: <1337064539-3014-1-git-send-email-gg@slimlogic.co.uk>
 <1337064539-3014-4-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6e7ZaeXHKrTJCxdu"
Content-Disposition: inline
In-Reply-To: <1337064539-3014-4-git-send-email-gg@slimlogic.co.uk>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6e7ZaeXHKrTJCxdu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 15, 2012 at 03:48:58PM +0900, Graeme Gregory wrote:
> Palmas has both Switched Mode (SMPS) and Linear (LDO) regulators in it.
> This regulator driver allows software control of these regulators.
>=20
> The regulators available on Palmas series chips vary depending on the mux=
ing.
> This is handled automatically in the driver by reading the mux info from =
OTP.

This all looks good modulo the thing with is_enabled() that I mentioned
which I think we can deal with incrementally - I'd apply but it depends
on the MFD header :/ If Samuel is OK with me applying the MFD I'll work
it out in my trees (probably by squashing the pdata into the mfd commit.

--6e7ZaeXHKrTJCxdu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsp4eAAoJEBus8iNuMP3deS0P/jtPrNzvPB9QvteLN6uCkRa2
Z6tevX0nLvS+wnazv3YZvb25vB9ipq5+kWqF4cAq0Bk/fElmyG6nqucYZXOBlb/r
ZpOSGnbVMKfmbLh9UfBUVBwnYd2+JQmuB20rXmcTE15IYj7Mlq2GWJ89jTnqfO3V
qSIEjZjm8m3ZMoCbAZ1xA4i0cH1WbXE9gDePMaNm7T4Hcdafc/e1xBMSC0v+dNnS
oQ05zLo9wQZLesa3bgr0r0JM+EwGULhAaFjHYOyRZ8rg/OBUFCNDclRDa9MeMMEQ
0L3EqpEG2iRhfD9Fl5z4v/7rqOZN/dS1dSSIAKja4GzpJw9y5iN83dK4sWFctBQO
EZ3ZBozhpMg34Z54nThLHQ1ccSq9tuFStWFqSbp8kf8/UlxvA6W0NPVdCenzZq1a
N4gCDQ9abrW5qakNmgB6yK53eXt9weJQRnJ60SBsl+3pwZOhTZGYTeF2KVbZeliL
stc3XlgfJ4xE9WIPo7ryXOLLiYLRArdFCDNAtqsi6ewd419E4aJJ/XnyZ8/Eectm
8EGZIt8Ir+RgCXBFwLgVLv+bWmnhVokA4R3grta8O2liRaIeQIoL2lxa9k/2l/eI
bRChIMVZi3wuUwzWCljbluQskfguY/A0lCFEy3lHpgu8ghGQhwvRu8tGwNCM+Nhc
ryiHrVcnzcT6EhW9hMNz
=YGc3
-----END PGP SIGNATURE-----

--6e7ZaeXHKrTJCxdu--
