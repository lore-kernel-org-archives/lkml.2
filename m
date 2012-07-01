Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab2GASX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:23:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37572 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403Ab2GASXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:23:55 -0400
Date: Sun, 1 Jul 2012 19:23:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, "AnilKumar, Chimata" <anilkumar@ti.com>,
        "Girdwood, Liam" <lrg@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [PATCH RFT] regulator: tps65217: Convert LDO1 to use
 regulator_list_voltage_table
Message-ID: <20120701182352.GF28922@opensource.wolfsonmicro.com>
References: <1340934316.14052.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PgLV2f+xYr9y+IUc"
Content-Disposition: inline
In-Reply-To: <1340934316.14052.2.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PgLV2f+xYr9y+IUc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 29, 2012 at 09:45:16AM +0800, Axel Lin wrote:
> Convert tps65217_pmic_ldo1_ops to use regulator_list_voltage_table.
>=20
> We have n_voltages and volt_table settings in regulator_desc,
> so we don't need the table and table_len fields in struct tps_info.
> Thus remove them from struct tps_info.

Applied, thanks.

--PgLV2f+xYr9y+IUc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8JWSAAoJEBus8iNuMP3dcXMP/iROcZSnP+MkXF/h15XIlQ0n
1SweCfCYTTqiLKTZ2gWTNsC0wjxH9LlnL+VU2uVa1kIDcGc9CVJ73lkTv9unK4Vj
z4Ou256U9Iw+Xefc2PztXdQUTRpxmur+dtBk2w/hDsK3ZuHETxxdxgEk1HYmNlGr
Yh+TUI2U/mQc3NSO2ACvEYVJZtNt5l2eRnoRzmJlOuWwPqf1GYFol21DPNtOjsO9
YvcG1/fZQO0bRFLO48Ki/eYQpp3Cct6wcVi5JnhSMw5Xo1Gdm7b4BxT2O215C8gY
zcFVJehNYs+Ssz5TqpgzIMuWtZjkFW8axewiJcMENwLb80HXzzLzAC+5UQTBPFA/
bvaunyrd9lOY+aB5Mp+RJ3XMOdAHT+BBq7K7gTzhMddhDuaNmd4DpEEKgIxAK3qq
0A0E2N44/sminfnqoyGEhHM7J232a2nOEmx1YsWYLJIoWro0/xrRXTzFCoCEKdL2
H690t/A3s19MD4K0487J7/lbu5PWKR3nHKaaJomHz+AFV0nwvEmNspb3il/p0lMl
TRjCZCGlsRhQWlivUjJXK07UnxLIFgCt1Ryn11JrJ/jFa/aYvLFf8RikJD/SnOca
47oQ13L5uJ/C2y/d94ViS+GVdpQsgVf3rzz4uVTfWwiPgGFn895wn+JblSjmGh6D
olPmouh4VjGPxtQr4TGp
=+rxa
-----END PGP SIGNATURE-----

--PgLV2f+xYr9y+IUc--
