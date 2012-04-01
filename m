Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab2DAV1z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 17:27:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36598 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753328Ab2DAV1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:27:54 -0400
Date: Sun, 1 Apr 2012 22:27:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC v2] ARM: amba: Remove AMBA level regulator support
Message-ID: <20120401212750.GE8971@opensource.wolfsonmicro.com>
References: <1333306720-28344-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACRpkdYRStgKo_e-4kZKA-V-OoMiV21jRS3R4g1Cq+4c+4=iQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5xSkJheCpeK0RUEJ"
Content-Disposition: inline
In-Reply-To: <CACRpkdYRStgKo_e-4kZKA-V-OoMiV21jRS3R4g1Cq+4c+4=iQA@mail.gmail.com>
X-Cookie: You will have a long and boring life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5xSkJheCpeK0RUEJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 01, 2012 at 09:22:50PM +0200, Linus Walleij wrote:

> Combined with the PL022 patch this causes a power regression since
> the PL022 is hereafter always on.

I guess this code isn't in mainline, though?  In that case you can
always add a revert of this commit to your out of tree patches if you
need to.

> But I guess if I fix a power domain patch to accomplish much the
> same things then nothing is really lost...

Let me know if you run into any trouble with that - I don't have any
systems which could usefully use such support so I'm unlikely to work on
it directly and from what you were saying you'll need to integrate with
existing power domain code anyway.

> And I do like the change, if for nothing else so for the fact that it
> eventually pushes to power domains what belongs there, so:

> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks.

> But to the defence: power domain code was not in the kernel
> when the AMBA "vcore" regulator was introduced so how else
> could we do it... except for inventing power domains...

Which might've happened sooner if we'd noticed :)  There were some other
platforms doing similar things but they mostly used the clock API since
it was always entirely platform code until 3.4 so they're less intrusive
into the generic code.

--5xSkJheCpeK0RUEJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPeMhQAAoJEBus8iNuMP3d4eQQAIXgUP1oSjA9sc7Sqv3ps+G3
OC12Dy8t+DxjhqTjFZKgr/a4GSsEZUA3ZUZSt+bSoGhbUms93IXpAESq6VQySFLs
tnEft6lcMt5+/ABkQGehj0QUjXqfmcXG7oxaeJQ3nBN0E//RwN/e5BR6lgQ+NDWp
8Jg5toioqrXB1cR2aKUdx4iooPqAMs9TRbo6t2QlXqtnckD7DF/QSWkHi03zY1Zk
K643LgibaCM7LCe9OJPMWr88NW2LBrioh4AXB6ym1kxg0sLc/ZQVwnQLu0aYKMHj
sFtD+W3XscfWoItQTmqGVEBMkArboNChrogo3S8oNM0t3ciPZe5KoG3FrEFWnRZB
XYH4yuzmj0WJKCdKNvZKmc9GtVlcKwkzJ+Dz3gKeKK4dJM951GdSr1WMG+BpLLRl
9RrR/U8MTqcYBy9sRDhOWxnTdJ2uJ1jH9Soi4x1mfATWwk4v2idz/6vsU0wfkQYs
ZeNNwrMLknj1lFJw2aZYCymIQShVfjgH0LXS4gHlB0454pAkocP/JsuzKIGyy3f9
WFC4EU4gFZtF8Yjxf8qoJ+SBdJ5CVBKAPGJGnvb4kFH7PTtNAio/YdmCw4CCpEhp
/FhBi2IKw2BEfuZI/j5Z5jsIQHS2rhsjhXR8SzpzwpGaSq5UoAUyCCkIR6mylPUL
Td1EuX2iJ+pICIX49awJ
=Q1pe
-----END PGP SIGNATURE-----

--5xSkJheCpeK0RUEJ--
