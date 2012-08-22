Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab2HVTDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:03:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33738 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964886Ab2HVTDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:03:20 -0400
Date: Wed, 22 Aug 2012 20:03:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Roland Stigge <stigge@antcom.de>, aletes.xgr@gmail.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        gabriel.fernandez@stericsson.com, lee.jones@linaro.org,
        viresh.kumar@linaro.org, sachin.verma@st.co
Subject: Re: [PATCH v6 3/3] DT bindings documentation: "num-cs" property for
 SPI controllers
Message-ID: <20120822190317.GE7995@opensource.wolfsonmicro.com>
References: <1345643359-16584-1-git-send-email-stigge@antcom.de>
 <1345643359-16584-3-git-send-email-stigge@antcom.de>
 <CACRpkdaYqNYCy5=mS=VvsD1zJU+NnZ5BU1-kjDLAnYsRSZvFGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FyU5fTJCTr/6Eq8v"
Content-Disposition: inline
In-Reply-To: <CACRpkdaYqNYCy5=mS=VvsD1zJU+NnZ5BU1-kjDLAnYsRSZvFGg@mail.gmail.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FyU5fTJCTr/6Eq8v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 22, 2012 at 08:39:06PM +0200, Linus Walleij wrote:
> On Wed, Aug 22, 2012 at 3:49 PM, Roland Stigge <stigge@antcom.de> wrote:
>=20
> > Several SPI controller drivers have defined differently named propertie=
s for
> > the number of chip selects.  Now adding "num-cs" as a reference name fo=
r new
> > bindings.

> > Signed-off-by: Roland Stigge <stigge@antcom.de>

> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Applied all, thanks.

--FyU5fTJCTr/6Eq8v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQNSyaAAoJEFJkBDiqVpZ4WPAQALDZ+GYflLM9hkYiGFQNBpAR
p/amoxt/1DlDvIKUGfCMm9/sGhQBLL3qix+SCqJFjB9gwT2fJcjLEVgBfeGUUlAp
Y6FkvD2PGgJG6iR5gQmGr98gxPjBk2fA7mkYbl44dLYJG65hIY/WybxB65/p8sL/
KSPPJ6ZLVeJujBxqcQ0ceeI5GWkxsKLQ8NitiV/mh5ysDtxbwiJmnUMF0qEj0V7w
ffwAMFqTBsuqmb3Jn9mxeFc3XF6vqkyEMSIBF7Sxi3MUaCaCCiewwX3yKIt9IA+i
uTHHVnvOWQElb/kCK1blGq7Ldv/DqaiwUSqZkYVd+C5QIlpCBRjl+A3UXeKPqXmm
7AYrcs2Xmf7oY7em6H2+VpEY5/Pje4FCcHGyNXi78ZjJnbNKf/9dHb+BVp107piB
Mls3XiAJpkW/a2a/pgG4LlsUqZ+WkN04DaXD9Sa1OUiTDmiKYWLLymIqgQjKBJ3d
T6GRa/2cvSfl65He92h67u4C/Un88FnP7n1OGG9468sozw9XQqpC2gbCu63h3pWt
1X0JCfNvA/jqJuAEGusZEQGeOoiUqExiLcAJ9AT6jzgY16l3vhUesLE1fz3xBk60
oRTkgS+pDz8ZP2aPZLUpyU1azStxtUHKgnf52nEm+gByUA3KRGXi6N4/Ch/dNUs9
TCitKY/rVJQKQS1MTLc7
=UhSl
-----END PGP SIGNATURE-----

--FyU5fTJCTr/6Eq8v--
