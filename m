Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab2CNOOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:14:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50559 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932384Ab2CNOOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:14:01 -0400
Date: Wed, 14 Mar 2012 14:14:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFC/RFT 1/2] regulator: Refactor tps6507x to use one
 tps6507x_pmic_ops for all LDOs and DCDCs
Message-ID: <20120314141359.GQ3133@opensource.wolfsonmicro.com>
References: <1331539070.13086.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+hz2tM55CCA8Ej21"
Content-Disposition: inline
In-Reply-To: <1331539070.13086.2.camel@phoenix>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+hz2tM55CCA8Ej21
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 12, 2012 at 03:57:50PM +0800, Axel Lin wrote:
> All the callback functions implementation for DCDCx and LDOx are very similar,
> I think it is ok to use one tps6507x_pmic_ops for all LDOs and DCDCs.
> This refactor removes a couple of duplicated code.

Applied both, thanks.

--+hz2tM55CCA8Ej21
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYKePAAoJEBus8iNuMP3dPicP/25J1sEUIqcuZWYcXt7GZexH
CEnYOg7NZnI5R3C5qCcexkjjlcZfAY9U/wBr4mjluYn61j8NNYcPFaan0luYuPfi
cJOqiValWZ5jhIODUqRc0B4JHFPTaC44XfxJ38sreqo3N9m9EvQioVPXrbgT2atx
VtfQWuIHpkG0wn0edWryZ2uAeOMHZqqBM0cXalk/nR85U1FufGxko9cKEJZesaTk
TkCBt+dKrViqviY+hMYmuJr62hDzXoe+VEJagcHKc52o7VO6o1LZUhLj2chWhvFY
0hBjgJaTyFZo9Scq1/3XT8fWap465oCR0nulV6QQzhHp5CFbz+SBU86ODLNEqy+W
IvqnBv2eyt+P5RE3M2tFXu04GlOt4Ppmum4B0imMkzE5FUl0Jed7py6uT/DBVX0B
k3Pw/lBjWJ0RS9Bn+6ZNcrRBsZnf6Ri/3H0k3bGMk9yFsOq7jpByO+SncM1Vq2Zp
veNOFN1vOKUjufBxRidlPEYsI1RaKdrUKygxUFXZ4BZOpclpUfgNl8kzggPhWNiM
GnSW7JoAKXp5ch5YVBxIAqrJe/GklrM4DjyPPtGDj3CE28l1aJcawuQ4ZaH/GzLt
0Xm4nUvCHHdOZHGZCwJRJiiZ0O5/3kBUcZT8uustsKTEMpz6BX4nU/oOQKIzGaTq
KU3fBHRDto4aKqNRwyd/
=RAQm
-----END PGP SIGNATURE-----

--+hz2tM55CCA8Ej21--
