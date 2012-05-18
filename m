Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876Ab2ERHkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:40:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45276 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754271Ab2ERHkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:40:23 -0400
Date: Fri, 18 May 2012 08:40:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFC/RFT] regulator: ab3100: Use
 regulator_map_voltage_iterate()
Message-ID: <20120518074019.GF4073@opensource.wolfsonmicro.com>
References: <1337231178.22713.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zaRBsRFn0XYhEU69"
Content-Disposition: inline
In-Reply-To: <1337231178.22713.2.camel@phoenix>
X-Cookie: The time is right to make new friends.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zaRBsRFn0XYhEU69
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 17, 2012 at 01:06:18PM +0800, Axel Lin wrote:
> regulator_map_voltage_iterate() is for drivers implementing set_voltage_s=
el()
> and list_voltage() to use it as their map_voltage() operation.
>=20
> In this case, regulator_map_voltage_iterate() happen to be doing the same=
 thing
> as ab3100_get_best_voltage_index() function. So we can use it to replace
> ab3100_get_best_voltage_index() function.

Applied, thanks.

--zaRBsRFn0XYhEU69
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPtfzcAAoJEBus8iNuMP3dZYkP/36UkutQyuqJuQVBf4jjW1+S
xSAkaeqgRo5YEAipFisoyBSHAwGwUVdVttiJMLQtTkrVdIL+Uq5rsixJxZw0PcWY
ZIlmRE2KngBVGWKe+YGI7KPHwSFWuirw3qcsFNDxN56Es4uQxjYX26SEK0n/Q2H7
FPZfhBmIc2DGjYnnRbwDanrb8N+eG3YUi4RCEq/BdOy5Qo4FddUAdxfKc2HjCQNq
Jpi58oRT1JR7lb3biDKdvPiO68C0CAvrTCN+m10PbBE508nMaAALVxoMwg0e0sSh
ZiMk1NjJbm/7q7MK4BH2i0Mc2DQgcJXwRCnKq2ud8MswOH1+0L23+n8G+nIxNRXy
ea1YfBGp/3tiu1YOfTLearsQX8gKqMaST/G37JBke8bVfo6zv3iKoPe66S9ZF79b
JCwpwmQ5VHCcPaGQvk+VlrZcZOxvoNcSxeVJHO8XENYAHL60q55QHMGk9U0ymCy3
UtcK7CATIkSxz8tmwwGa58ogaNcoMRmlQh9MWLww9FxcZnJJUuaIEdGPzCCDxeJa
D9/FvpBf0D915zCUGQdPPCQJcb0Ebh6fgNvvkDb1Qog58avU3E+ihY5aLkWIVc0G
+vnOPe6o2X7vKwOAr7ORov+/5+9jDwHWAVYyfJoHPZ+8AOhBOLGob9BIVRRhb5yK
V6c5BDfn8YcfrOASz8oQ
=XQHF
-----END PGP SIGNATURE-----

--zaRBsRFn0XYhEU69--
