Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2DQSig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:38:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51386 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715Ab2DQSie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:38:34 -0400
Date: Tue, 17 Apr 2012 19:38:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Karol Lewandowski <k.lewandowsk@samsung.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        Rajendra Nayak <rnayak@ti.com>
Subject: Re: [PATCH v4 2/2] regulator: add device tree support for max8997
Message-ID: <20120417183829.GW6652@opensource.wolfsonmicro.com>
References: <1332582590-16382-1-git-send-email-thomas.abraham@linaro.org>
 <1332582590-16382-3-git-send-email-thomas.abraham@linaro.org>
 <4F734460.4060605@samsung.com>
 <CAJuYYwRsHynt6pBHUgk72Z-UjHj3DM=s4pV4dzbb2hTAZOUSAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9+ohdFDUqiMJzwPo"
Content-Disposition: inline
In-Reply-To: <CAJuYYwRsHynt6pBHUgk72Z-UjHj3DM=s4pV4dzbb2hTAZOUSAw@mail.gmail.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9+ohdFDUqiMJzwPo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 18, 2012 at 12:05:59AM +0530, Thomas Abraham wrote:
> On 28 March 2012 22:33, Karol Lewandowski <k.lewandowsk@samsung.com> wrot=
e:

> >> + =A0 =A0For BUCK's:

No 's here, BTW.

> > =A0- EN32KHz_AP
> > =A0- EN32KHz_CP
> > =A0- ENVICHG
> > =A0- ESAFEOUT1
> > =A0- ESAFEOUT2
> > =A0- CHARGER
> > =A0- CHARGER_CV
> > =A0- CHARGER_TOPOFF

> > I wonder if these should be mentioned in documentation too.

> Yes, I missed the above regulators in the documentation. I have
> included them now and will resubmit this patch.

Please omit the clocks; these are obviously a bodge due to the inability
to support clocks off-SoC so we shouldn't be enshrining them in the
device tree bindings.

--9+ohdFDUqiMJzwPo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjbiZAAoJEBus8iNuMP3dlkMQAJTfRFimB6HTyLF2bnKYIlnl
D1XFs5FaeT43PtPqvqgwc/yJhfPc92HtxnevuushNUydDN9RgAfbne2fM+3W1un3
3jIYhAZm46eGZkYfAj95dYKtHGDO1r2+L5y477ew+fiJJVrO1R+TeMnt/33H9loe
DyyvirAMVVuxKvmsOu6NqJ12pCI6IpSui4gX8QTj4c4gOtjUQzb3BsltZfMTLpTk
ed5S6x6cdIF5F6LQ+yjd/2EvPasBT/UT29oSiJN7OUtAAqmuTAseaaSuTgzQQAC9
Ixfg0vnndLU6Jzb3ag4iNikbU+9fffNZmhFU6lQb5Hq7kmsSK3+yO1occs+P5Bia
2odgCGRhCKtNH5fCNw6XqVOC/QU5idGgfltigybdFpAOOqouGdCcPAMvO7qVlNQr
Kt+JWRFJ2giEACgIr4ad2weY8z+kOYdVdN56JRTBN8+dmMzmxTMO+C3v/AZR83y7
ubWvpeCxXDnpxxa22VB/Aq+LaCgJZyzKIYPsqnDFKMsXFHwG2QLskZ+rb87P0feP
Ec00IgrbuV5hsuBeVHglzPmQ+aM+hjMgsj1CqbYbwMGbvv/+xzfGfkZ1i+lhKjuo
TiORe80grOrIGWIhrELUUF6Omi7xDqBrs3mKrBUzE+ggomD5s3XECQ0PdClF7dFd
yiwuI9YMsFnxcZpqnKg+
=QzZj
-----END PGP SIGNATURE-----

--9+ohdFDUqiMJzwPo--
