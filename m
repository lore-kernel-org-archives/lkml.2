Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab2BFQkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:40:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52060 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754865Ab2BFQkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:40:14 -0500
Date: Mon, 6 Feb 2012 16:40:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RESEND] regulator: Remove redundant regmap_update_bits
 call for TPS65023_REG_CON_CTRL2
Message-ID: <20120206164012.GS3070@opensource.wolfsonmicro.com>
References: <1328533274.4535.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hEarWVD7htqb1VxP"
Content-Disposition: inline
In-Reply-To: <1328533274.4535.5.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hEarWVD7htqb1VxP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 06, 2012 at 09:01:14PM +0800, Axel Lin wrote:
> This looks like a merge mistake.  Calling regmap_update_bits once is enou=
gh.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

--hEarWVD7htqb1VxP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMAJlAAoJEBus8iNuMP3dB0oP/RxmKhHli1XRYzY+fb5RelV1
HLPLHgmxlScwThTDTSA0GX5HbS9zZrfkcHsdl0MdgXnc2YVgvmQ6szvMuRcI0vS2
/3o2vXIogbBh0CrwWXe2KJj3kb0Cs9V9JrUGts0bIzQkmP1q0TYOr1pDXulu3vAf
jwxG5iWTPCN+NiSgoOOLCAkiPNwpEw2M59FrqXG7jM0orMGWDWoxbiJL2MU/wYo+
xqV1ZVy22eCmgtIwsCOQlmiGJRpU1Py418d10Xp57DCPBgOf2mDT+5p0OEfXdlu3
a3JKNPqHw/lQqZ1kP0ZPtvhJMHVgHsQuc4owaKbFg85jj+So0mJ4M3M9hs0i3wSQ
THUhgTWPhaxXgIbgDPv0AH6RlPp5KZoHDgqTc+uYh9aVHYAQ5U69y5p3XpE3V1KE
0vYe5nFiRm+vqWoY36vfnl7zaSREtkln6x2EqUz/TmUmvaQhcm4rT5DBkw2HutNl
zwL6URFLtkmYHmsBOv+wM0yXBmnhnRo04PbpDx2tqTshxoOq9DwtZQeJgUcLlnPH
9lr1AbJieNi+0Uqb3lPZ0tpJlpDNFNDGVJ1RdOdUnYRNH+P4jFlb7Kmz3bkrGEyS
ziUD9AngnQFECeYFdQSkx1zk3GiyjZRHzop58eBUL+UbubX8szBDW52gN/RaDV1e
JLUghiOnM/4E+1UdZRNW
=PBNZ
-----END PGP SIGNATURE-----

--hEarWVD7htqb1VxP--
