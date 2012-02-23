Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab2BWMa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:30:26 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:49216 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758Ab2BWMaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:30:25 -0500
Date: Thu, 23 Feb 2012 14:30:20 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: linux-omap@vger.kernel.org, grant.likely@secretlab.ca, khilman@ti.com,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/6] gpio/omap: get rid of retrigger variable in
 gpio_irq_handler
Message-ID: <20120223123019.GH18463@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
 <1329999031-6914-5-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LmeqhziFqEm+Ep0k"
Content-Disposition: inline
In-Reply-To: <1329999031-6914-5-git-send-email-tarun.kanti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LmeqhziFqEm+Ep0k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2012 at 05:40:29PM +0530, Tarun Kanti DebBarma wrote:
> This local variable is just assigned zero and then OR'ed
> with isr. It does not appear to serve any purpose and so
> removing it.
>=20
> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>

hehe, makes a lot of sense :-)

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--LmeqhziFqEm+Ep0k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRjFbAAoJEIaOsuA1yqREheAQALW+SISMRs+TRxlDbBsATgon
HTyLLKdgThS5EQ0uE7qka1dhJz3XpzCRQV3Z3Q55uK7KqiilYhybkxqLapww3hWQ
xrAKh7V8sP+8qTI5m2tRP6IuDmQtXAGjBGpCEsGL5vjZVrC0XqEHXNN72SaehM7m
gz3aSb1CcObth+N7nA8Op1nKRyPzPQgeoDiir4w1BcoYgb3UVJevMXmUCeQf41uk
RYf/lUSLOiEbZFXoLDQbSKjwnZ9FEVF8Q2wbFCiGC4O16Sd7xvfDbZTpZ5se6Luh
4gyCrkO3aKAm04InsDTktlruC+Qfc4xWzrpQqWQgvXeMDYFJv3RrxzAhm+oVKbsL
ONYbgLIcj0kxiBumYTd3jmr1bxcdjInD01ArsOp+Kruh5AC5eP/PzPbR3XkX7gR0
L4tcxYSyP4LMeoxf++WomP/NuVYyx7rO7mJVHTHB3Im9IYf5NIX6ED7bZxW3mLDI
LMhvj/tBHZC0fzi5HsqAzvFkygMMQm1YjrOxcyQUDunmF0ZUUSLYxyFN401q5IuU
GfFdtqpjW8AGeoQhhHf6pCsDl3+ak/l5BbrYbNDjs5DAyuuH37SY5/q+Omnfhc22
bb8/mEBzV02t4cwSqJITNc1zRVGPNYHlVAVVwBzhP1fmCN6en9Ub499DLWrkFaBe
3ybGK1tnVEM1FGKkD0Mx
=0wz+
-----END PGP SIGNATURE-----

--LmeqhziFqEm+Ep0k--
