Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab2CZPen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:34:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52630 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932635Ab2CZPem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:34:42 -0400
Date: Mon, 26 Mar 2012 16:34:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
Subject: Re: [PATCH v1] regulator: i.MX35-PDK Add regulator support
Message-ID: <20120326153429.GX3098@opensource.wolfsonmicro.com>
References: <1332772593-13313-1-git-send-email-alexg@meprolight.com>
 <20120326144712.GA8579@sirena.org.uk>
 <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD16@MEP-EXCH.meprolight.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uN3tURjgVTLfI0kr"
Content-Disposition: inline
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD16@MEP-EXCH.meprolight.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uN3tURjgVTLfI0kr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2012 at 05:28:55PM +0200, Alex Gershgorin wrote:
> On Mon, Mar 26, 2012 at 04:36:33PM +0200, Alex Gershgorin wrote:

Fix your mailer to word wrap within paragraphs, I reflowed your text to
be legible.

> > >...and in many cases the supply names don't look like things I'd expect
> > >to be varying too much at runtime.  It looks like you just typed the
> > >maximum datasheet ranges in, not things that make sense for the board.

> It's not quite true, I was based on the Freescale BSP and I assume,
> that this is checked.  I also tested it on v3.3

Uh, presence in a vendor BSP isn't a guarantee of sanity...  Since you
didn't specify any consumers the regulator API obviously won't do
anything with the voltage range provided but to repeat it's really not
at all obvious that anything sane ever would.

--uN3tURjgVTLfI0kr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcIxdAAoJEBus8iNuMP3d6H0P/0EOL8l57TtnUNrMotCzulH/
JAg21Jpen+u/y4H/M+jbCTfur/8gMANRyMhl54IPadPz3QhppVbPha9/G2rOVhXP
z9oTjlXs4RRO2iz3v1jS12Axzc7dBW9mmAvZAyYZaJ2wbfuHzIjl8Kew9uaGBXRb
Ppc0jXOfBp7TYuulCmM/98yNLqyDL0N97PlNZiYN75Fv9RE/pwSZt0IM0Vgs4qlO
VNPbSrcblwFCDrzeGdzv+um76dTTVX7pTMPWOmuvXWbXIsK4YpEniH9p7hKplral
zqnqVUosgU6I+8+KnMh3p7qoAVeAIrvydFQDGd/XMhUj4U5endXpBpDlOT6fM6J3
MXmawJGyrSZz2e09Si3EExjdZ38kpH8o9vmhOshsQvSYCv5cHQOPf+kIEjBvivDj
Azj7TkBRLoe3OydBz7VDZDuLXH7bNeeDrLwl3EjVpWxg9E1n6E3c6x7HzlRdfksV
MchdZKA0TfyN4GQqMOv2uAT+eLM3tG9lazTUkQJgIeqGnGYxwQdzvfaUTw3g8wLA
G4v3kihXLE8nFIL5MVXVbPVzFQKjSSSj6ViYqE/rF8Hk05ItryMJRgY72eHjHTJE
cOgzTJBxtLxQulgB5Fey5dz1WLODHjwTUqNI6bXSkg/RHPADuAWUysLK5KvIy8/Z
p8G4fm8kRMnys8sjpmfD
=jc/H
-----END PGP SIGNATURE-----

--uN3tURjgVTLfI0kr--
