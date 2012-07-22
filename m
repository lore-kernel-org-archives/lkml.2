Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab2GVTQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 15:16:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60962 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416Ab2GVTQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 15:16:29 -0400
Date: Sun, 22 Jul 2012 20:16:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] spi/omap2: mark omap2_mcspi_master_setup as __devinit
Message-ID: <20120722191623.GF4557@opensource.wolfsonmicro.com>
References: <1342780303-6596-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B0nZA57HJSoPbsHY"
Content-Disposition: inline
In-Reply-To: <1342780303-6596-1-git-send-email-shubhrajyoti@ti.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B0nZA57HJSoPbsHY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 20, 2012 at 04:01:43PM +0530, Shubhrajyoti D wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> This warning recently appeared with omap2plus_defconfig:

Applied, thanks.

--B0nZA57HJSoPbsHY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQDFGAAAoJEBus8iNuMP3dA+8P/1t4Ad01JvWJaxVl1dEV48lb
RkV9D0I2G81K4sJK+cdRHlyR45NH01HVE6CxHg1X8x+dJfFtsX2WN+BbLqKyNr1t
AeRdnmuDMKSYMbndXlB8tsLR9julpzMACGUTW5yLkqGv6Km0BlVDGKxyHZoNbyCO
yIA8Xhbgew90AQqW0NsqJA8xb4txFgqeuEbaXJgG9UdcQexfHDBncOJgg5S1vgep
IFAL9Bx5AqsI/GCzpoAIQCDeoE3mmr1sRvn1Gmyi9MhFzpDeVI1L3xLoeB+rglDc
Dfy76HIHey4zOOwNsz3ovexqEvU8gYC2GsqgVEXBuvEMQOupHcexcfXbv7DmCa8V
JWQ5jGF0dnBPsIBNkN3ZIRhUIlnRpLUf7JSu/C51mLgYpixbj1c7CWQX/4EeDYHI
K6cF0RqUa6UqatRY7LvNrHqCnhteyeo7JwACRfro0BNgAKuWlyeo6kYFahed0k52
je2Fuw4uujc47EF+OSh3tMAuMQRIASqY9ViGGjuPFSaDiZ4qNUaFc9PJWp9kuQJP
8bjArjS05mdyu9nElSsBRN4a4FAFMoMtTJKrLGCSsPq5FA3iWRs9Kd2Tc5nYyo/T
cPbDBVJJrxv7lVvT03V+F5d+B0Dy4xWv/Wmcl/PHxpO1cDVtNvlnlghwirFx7Z6O
V9Uik2TeBr0/shdChzjY
=5x4i
-----END PGP SIGNATURE-----

--B0nZA57HJSoPbsHY--
