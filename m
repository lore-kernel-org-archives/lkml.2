Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1GKK0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 06:26:17 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:60880 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812Ab1GKK0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 06:26:15 -0400
Date: Mon, 11 Jul 2011 13:26:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: track the owner of irq descriptor
Message-ID: <20110711102608.GW2680@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110711101731.GA13804@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i6WX/W6h5xa4jqsd"
Content-Disposition: inline
In-Reply-To: <20110711101731.GA13804@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i6WX/W6h5xa4jqsd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 11, 2011 at 12:17:31PM +0200, Sebastian Andrzej Siewior wrote:
> Since those functions can be called from within modules we should ensure
> that nobody is going to free this module while someone is using an irq via
> requst_.*irq() and still using them.
> A reference is hold in request irq and released on free irq.
>=20
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

This is very good news, I was waiting for that to start changing how
MUSB allocates and frees endpoints. I wanted to have per-endpoint IRQ
handlers and this will help achieve that ;-)

--=20
balbi

--i6WX/W6h5xa4jqsd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOGs/AAAoJEAv8Txj19kN1K/oH/1OdXQH0eppbGxG+pWk8y+dh
a+pCj4AoUgemimKaO5XItCSuIjf2WZ9JLZafOWtymnwPrKGtPWaV+bfAQYik8pjv
zh29XceYJdVL/lKR7WL9dO3+YRzcwD3liQ8mZRh5I+JhhgM2lwg0njp55HfrP1Pf
7Nny5l62HMagZGUKlCCF/me4CSTQUT1y5Vy8D3S+HtNYZKUEyFkl9ILAoJ3bLOWs
hWKQsqU5G0AEXFnzDaoOOqi5bSkTGoa/RjitBxchzpmwyyOqMACW8yZaIC8rqp5L
BzpsNqYoHvDpDFJ5m0Q2p11gYazdV5ME1nGwttb8YdBppwDy0aQx/pHxebqYdI4=
=0YF+
-----END PGP SIGNATURE-----

--i6WX/W6h5xa4jqsd--
