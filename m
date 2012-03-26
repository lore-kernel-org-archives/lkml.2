Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab2CZRhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:37:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56246 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933122Ab2CZRho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:37:44 -0400
Date: Mon, 26 Mar 2012 18:37:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT] regulator: Convert tps65023 to set_voltage_sel
Message-ID: <20120326173742.GH3789@opensource.wolfsonmicro.com>
References: <1332740804.15735.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v2Uk6McLiE8OV1El"
Content-Disposition: inline
In-Reply-To: <1332740804.15735.3.camel@phoenix>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v2Uk6McLiE8OV1El
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2012 at 01:46:44PM +0800, Axel Lin wrote:
> This patch also changes the define for TPS65023_LDO_CTRL_LDOx_MASK,
> because regmap_update_bits actually does:
>         (orig & ~mask) | (val & mask)
> This change makes the code consists for all regmap_update_bits calls.

Applied, thanks.

--v2Uk6McLiE8OV1El
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcKkqAAoJEBus8iNuMP3dNgcP/j+fBrhpiLaYGo32ul539Zkx
Ar/IZlbl1nDME4lFBUmBVIFVWy0+1JiDlWck6rhbRdin1Z+rpvb6Hw9QLgw7viG+
R+Jm7m/0dy9b4KfpWKw/ntlOBlZWLc6gqlsLTSuA4pR0DaYkFcan7RUvDSFCSg0C
x6qmW2F7/4LC19QjcDYFRA7yNcSsMMKk/FYJYG425BlZt58euytapnvvTQoFF5rt
SbyIXB3LFgx5cL5AICoT1k1uVXIQMWz3yaoiu7Vj+TbWluTceiNJ2eukQ46ymWFB
z9/qZO2vhgm/0sk7mCML4uaBS9ehHInWPTn1SNAcgiekGhyFwVwBcEs4vcDL6fM0
gDHBSTir4fodyyIBy3Y8gVrTHYOzuM2llTTQ997Xd9dSmB73E3mg1a9tZSKFXnei
qiKnUFVv+xCixAOGBuhalXQbUf4fiMsvSOmagigRLtw9i37dhFYGRevx7YXe5lLd
0/z9jWvOdWMZ/1tOx7VVcBJZpLvy4ExBMSKrPcMeOKIH79hG6kQp0JZ1EMXGFyT2
yul/T8NNwHhcmf0CHcbBIRxAEUWUixRpriOmTQABunHbUHwLriYPydSyZORJFI4N
+zcqwPLTKUtYTzl4a4Chqc2b/5pKsFMNtJuU0SIVzx5fu0Cnw042bHWPsfxds+IC
YxPn1MAVD//Ld+316FYg
=kSNI
-----END PGP SIGNATURE-----

--v2Uk6McLiE8OV1El--
