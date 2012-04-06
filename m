Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab2DFRdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 13:33:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35220 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753909Ab2DFRdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 13:33:03 -0400
Date: Fri, 6 Apr 2012 18:32:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 2/2] regulator: Convert rc5t583 to set_voltage
Message-ID: <20120406173258.GM19424@opensource.wolfsonmicro.com>
References: <1333605888.18055.1.camel@phoenix>
 <1333606056.18055.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VB1oQhYtJt8uuzk+"
Content-Disposition: inline
In-Reply-To: <1333606056.18055.3.camel@phoenix>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VB1oQhYtJt8uuzk+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 05, 2012 at 02:07:36PM +0800, Axel Lin wrote:
> Not every regulator driver should implement set_voltage_sel callback.
> See commit e8eef82
> "regulator: Provide a selector based set_voltage_sel() operation".
>=20
> For rc5t583, the regulator voltage can be mapped onto selector values wit=
h a
> simple calculation, thus implement set_voltage is better than set_voltage=
_sel.

Applied, thanks.

--VB1oQhYtJt8uuzk+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfyiwAAoJEBus8iNuMP3do3cP/3eFg/m4RtiuxHsv161nK08f
vgHbgfaZXZ6BO2N2BSWnwBjd5sU0urPPAB4TJXozoQ50PL8lc3VUAuPJt3WAri8S
XsqpQlhaE8D8lHST8MM4pvFShibWppKENJBmFhWSmqlcJwZ3PGNZWwqs6mequXzD
Vj8iVKIV0JoisU26MglZiwsuP1WNtgTrSgEEoWzoY9GY39FpJbHbgKbHqH5++ze3
v2SMUgyeSfKSGwHE7M6fNdQ65i7jo1R6LX4jyo6R//ZdmYFjnA1+fIeh1PnKDlxe
hMWQWNKBjB1W7cQ7nE0zbC7rD+84iIL+ByDOoU8sS0pCxndMiuFTO0RN1wzps5DF
T6ZuFJWrqUGTXnggLrKKHUj2ttK5q4WQh6r+Ys7IktcxX1kKumqTWrJ3gMSyTuDf
Tx/uzw3macGJBwZdJVMPWdGiV0uuWvFiwtf8BhvBPQWDDZ3aZBFvYDYDhdkM9Rpr
UNPpUnRQsY7kW2CJPtNlwkqWJIIxPzuB8oYkstVmzYRH0veoYxnQkYgiQt+7enMn
gSM93aS0toELJtp3V3HNC1nX0SfmOVqOeFbP5UVT2deaDTsMAA/4m928P3NsuV19
P+nqWy0IltH0mFHAo54WR1yw1+Iea8SlzmddaJN3sGCW+rBhSgeA0BG2nBRcsXqd
Rt6PCdNxKD1gbJdfZjBI
=1fL6
-----END PGP SIGNATURE-----

--VB1oQhYtJt8uuzk+--
