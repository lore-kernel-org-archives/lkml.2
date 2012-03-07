Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab2CGNpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:45:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35506 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757326Ab2CGNpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:45:54 -0500
Date: Wed, 7 Mar 2012 13:45:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>, patches@linaro.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Nancy Chen <Nancy.Chen@freescale.com>
Subject: Re: [PATCH v9] Regulator: Add Anatop regulator driver
Message-ID: <20120307134551.GL3107@opensource.wolfsonmicro.com>
References: <1331126658-26926-1-git-send-email-paul.liu@linaro.org>
 <20120307132225.GB17745@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EOHJn1TVIJfeVXv2"
Content-Disposition: inline
In-Reply-To: <20120307132225.GB17745@game.jcrosoft.org>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EOHJn1TVIJfeVXv2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 07, 2012 at 02:22:25PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:

> > +- compatible: Must be "fsl,anatop-regulator"
> > +- vol-bit-shift: Bit shift for the register
> > +- vol-bit-width: Number of bits used in the register
> > +- min-bit-val: Minimum value of this register
> > +- min-voltage: Minimum voltage of this regulator
> > +- max-voltage: Maximum voltage of this regulator

> specific properites need to be prefix by the vendor

This really doesn't seem at all sane for a device which is already
vendor specific, it's just noise in the bindings.

--EOHJn1TVIJfeVXv2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPV2ZCAAoJEBus8iNuMP3dNscP/36no4jSuMHNQVkaYJkb+Bv3
0DLsEs8HDb0V1RHVsxIsAeQQB90AC1olW8z8ZnbEzONOx4h9Z4NxC5awQONoW2s/
z+Nh5FDrjsyAqxRvSDMavqJdYphl8hO8Dijh4guCFSzBNvtzavblQ3RdMskPPTy5
XoBl31HqXKBBYL+ojbIX5fVOBD3ypSJa5Pd4jawLO4XwLoisiw1u0rGwp/bLtbFt
B4/BQK5Sq5zG2X/9RKDmyYCeBa3JBy0v8OkEa3i7/JHyRupnoKKexbF7y2g8iPRS
BoGinC10ffNHzFP8y5fgAtWQ8eNR/wYWNeGLNeWjoXHylu08IuEt/5LOuaM/8Qhg
PO4A3ftm71nYtOjGnvQ6v9gnJO94eeVXRYiQL7L5HM8B0BbFy7RS2Sm2q21ukQQV
2O2go2SY70sd+B0eq6lThm6B3OohOxprp/o7330ZC5G1lnnxGzvE9SitkWILjqf6
1kdHnx1le3kqhoD/M+qKx1W3uSwR33DJ03orTXtI9ggD1cO+LQtZtsoG9EXGppvs
J+h8fJqASJTM8LcEbcLYtJ5gsPmug3ifJrboconlRljW48WjlnjI7fs1qUYOy5tt
VHpg/VqjqeZS7qL69EAoMnaZKENF5VpuszLFiOYLmqop4dz3Q+lq7nQcD5k15rtq
dPXk2RBIK9aDRD3F/X24
=HwqO
-----END PGP SIGNATURE-----

--EOHJn1TVIJfeVXv2--
