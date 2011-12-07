Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab1LGJxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:53:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54736 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab1LGJx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:53:28 -0500
Date: Wed, 7 Dec 2011 10:52:54 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Herring <robherring2@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jeff Garzik <jgarzik@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v3] of/irq: Get rid of NO_IRQ usage
Message-ID: <20111207095254.GA6436@pengutronix.de>
References: <20111110151852.GA7465@oksana.dev.rtsoft.ru>
 <20111110152541.GA3207@oksana.dev.rtsoft.ru>
 <4EDE877A.4080708@gmail.com>
 <CA+55aFwGFogD4ROCH9m=c2jqB2axvrH-dnKPtA8kxXL9b3CVBw@mail.gmail.com>
 <20111206231626.GA31683@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20111206231626.GA31683@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2011 at 03:16:26AM +0400, Anton Vorontsov wrote:
> PPC32/64 defines NO_IRQ to zero, so no problems expected.
> ARM defines NO_IRQ to -1, but OF code relies on IRQ domains support,
> which returns correct ('0') value in 'no irq' case. So everything
> should be fine.
>=20
> Other arches might break if some of their OF drivers rely on NO_IRQ
> being not 0. If so, the drivers must be fixed, finally.
>=20
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---

/me likes NO_IRQ removal very much

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7fN3YACgkQD27XaX1/VRvt0ACfbx636k1V5VHHUwOKbikRv0zJ
xx0AoKZLY57vMXqZK6xFgXEUyKOWrIjU
=P6F1
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
