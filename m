Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab2GKO0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:26:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55902 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755294Ab2GKO0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:26:08 -0400
Date: Wed, 11 Jul 2012 15:26:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix bug in regulator_mode_to_status() core
 function.
Message-ID: <20120711142606.GK3938@opensource.wolfsonmicro.com>
References: <201207111221.q6BCLW8L014872@sw-eng-lt-dc-vm2>
 <20120711132655.GG3938@opensource.wolfsonmicro.com>
 <201207111421.q6BELFoF006060@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DN8g+DOX2TxGxleI"
Content-Disposition: inline
In-Reply-To: <201207111421.q6BELFoF006060@sw-eng-lt-dc-vm2>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DN8g+DOX2TxGxleI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 11, 2012 at 03:18:00PM +0100, Krystian Garbaciak wrote:

> > This is deliberate.  It's not reporting an error, it's reporting an
> > indeterminate status which is a different thing.

> Ok, then I would propose to use REGULATOR_STATUS_OFF instead of 0, to present
> your deliberate decision here.

I don't think you're fully understanding "indeterminate" there...  the
whole point is that we can't adequately represent the state, making
something up isn't helping things.

--DN8g+DOX2TxGxleI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/Yz3AAoJEBus8iNuMP3dZI0P/3c8cbK263J4INUYfWWN7fyo
w+pWYYN5jXJtymPngv/h1rA1HYQGmGW1tx0pYHdUfDXy9EYua0oZPBYseJxfOp5M
76wZxhHm5bsZW6ETkrfm0kkRoZI+rppsCCny2lSfjXMDsJbAiREMC2WBBdtHQpbC
Km6B4FLVBFN9fDVi5rjGx9p6nnM1E2PwAj2S0eO2bmAj9k82cQLeFphbI+2xFWy4
MJkc0kyNKuC3rmiJbAZzMu4WP7xm9J8WedwOGllD47QN0gn8pn66e14dmBtv0Z6+
ce7T1aDkDVKkszYGdN+VFbN6sZcEOiXx8jrA/AAME0+60RIqm2T8U4FETSEHspP5
Iz7b13X2cOuPWepHBoqeghko71jbME9Kyq1OvVnLX09hpII9UgCQIcSRr4sAcLO0
P3N/ToKdl8WeShpUMNEceQmx2KsUK+JvZu/uj5G+azzSN9gRkjfLjS5HcDg+GgK0
tQSc9aGfRRqAt+1PewdBJCX0NkAHNw/apy2rDWvAy/XefXNqXoYO9FszHGmJ2Gww
2NkqOC++lJ30lpwtwYeA6tqMt1ZiPd1XhgmDy/lNkCx05zY15PjI/sk8og6Mi2q/
6uVMyrEpLycbjeWEgysEM3pAzB40lrW3sHu/r3dmAHYGqTVD4NFzDsuDEgUGcMN3
8qcQiWCL6Xa+5KSBgG4A
=JKlB
-----END PGP SIGNATURE-----

--DN8g+DOX2TxGxleI--
