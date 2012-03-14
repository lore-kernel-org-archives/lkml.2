Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966Ab2CNMiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:38:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42593 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760910Ab2CNMiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:38:03 -0400
Date: Wed, 14 Mar 2012 12:38:01 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>, Liam Girdwood <lrg@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v13] Regulator: Add Anatop regulator driver
Message-ID: <20120314123800.GH3133@opensource.wolfsonmicro.com>
References: <1331692152-9256-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VkqCAaSJIySsbD6j"
Content-Disposition: inline
In-Reply-To: <1331692152-9256-1-git-send-email-paul.liu@linaro.org>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VkqCAaSJIySsbD6j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 14, 2012 at 10:29:12AM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
>=20
> Anatop is an integrated regulator inside i.MX6 SoC.
> There are 3 digital regulators which controls PU, CORE (ARM), and SOC.
> And 3 analog regulators which controls 1P1, 2P5, 3P0 (USB).
> This patch adds the Anatop regulator driver.

Applied, thanks.

--VkqCAaSJIySsbD6j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYJEfAAoJEBus8iNuMP3dU9AP/RGPBOFxya38fFonp6txzmKa
JKDFNKkUB/oCaH06Jbo78BZatw/sE1NH3e0fjqthJrzFfA0Ma9gzV35NhWepbYGU
q94abcxREZsFmMrnX7WkUHAZNvvgzpAbqFleSBXZ1CtZ1RrD5JvKFDBS6licAJPV
gDzRgmSYaDyDLSLR1EBobM0QD7ZrSZbQQtp+wCZCwj+duDw1C5mMrh2InwMfR2O2
KPPVURG/nWwpBIaSyNPtDp3fYNMyez1klegOap3LOKIDre/Gjsuhb6IQx+TYAKwH
JLZMXtd1BKBoeKkqkQhiC2j/mUB3BE08B54EiuQyyt4zYSqpgvztddxEJAfbZXwr
W0cfs6BN4AFWDffNPj5vSX/STTBSIN1aYo/Aac5njiZfBTUuCeZiQ4kqZOkZemaN
6pI7OnHXElzia5VSyapVujH0dtxCFZsfdaElnANWJ7m6gG+CuQc/MARGAYNisRFV
cf1s4P+AwQ/Hy054xI8JEeu6xxf9/U36A8atYRw1H1986AH9Pf8B6sYYnFlgfu/v
ZP0Bst29lKjMRB9PVmOD/BRpafm9emVY0UwOXQ46mdo+08+Rq5R5Z2+3VjonQLmR
jmKB8vtTXyb1ITwa8BXIrtNaGoBf1te+qo4nEv3LClESz/76BAjdaAihnQUhvULP
WgDO3klrTrR/7GFicV8C
=xuWW
-----END PGP SIGNATURE-----

--VkqCAaSJIySsbD6j--
