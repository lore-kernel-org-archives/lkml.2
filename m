Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2ENJ6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:58:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51582 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841Ab2ENJ6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:58:06 -0400
Date: Mon, 14 May 2012 10:58:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com, sameo@linux.intel.com,
        linus.walleij@stericsson.com
Subject: Re: [PATCH V3 2/2] gpio: add STA2X11 GPIO block
Message-ID: <20120514095800.GL31985@opensource.wolfsonmicro.com>
References: <20120514094737.GB2189@sirena.org.uk>
 <20120511233402.43D813E0791@localhost>
 <cover.1334219873.git.rubini@gnudd.com>
 <5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
 <20120514072534.GA29871@mail.gnudd.com>
 <20120514095111.GA4972@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yaPAUYI/0vT2YKpA"
Content-Disposition: inline
In-Reply-To: <20120514095111.GA4972@mail.gnudd.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yaPAUYI/0vT2YKpA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2012 at 11:51:11AM +0200, Alessandro Rubini wrote:
> Me:
> >> I'm not completely clear (yet) about how to get the right interrupt
> >> number in those other drivers, but I'm willing to remove the constraint
> >> as they are cleaned up and submitted.

> Mark Brown:
> > Use platform data for both this driver and the other drivers (or device
> > tree if you're doing that).  This will hard code the magic numbers in
> > the board files, not in the driver.

> Yes, but it's not that easy. If the gpio driver gets unpredictable
> interrupt numbers associated to the pins, the other drivers must
> recover those numbers in some way.  That's why I currently started
> from 384, like the prevoous gpio driver was doing: the platform data
> uses that knowledge in the drivers I'm still using internally (but are
> not submittable as-is, so I'm working on them).

If you use platform data why would you get unpredicatable numbers?

--yaPAUYI/0vT2YKpA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsNcgAAoJEBus8iNuMP3dwckP/08HGi7uScBRbxL6xdLDvs9w
KyxNddCfl3Ka4W/YQKr6TTES9ZifpNpQfsYTgfqJuMrsZtbDcy/CYsWE0nhkmIOA
WLTolYiIQtq+iTncENgsYCDhTm1MDowPs2iKSyW0ax2kchJMXu44fDwRr5JTRsLb
sLuro0qA1/muIStWFOXz38XcCeEjiIDrAswi9y+lpZG1uLeHhwzK66llISws1mGe
xnfPKBR52KFJXVa/6Q6gLEOH8X65yNAQO26qIa5pV6UWuqJpvo8+s1zNP7/ng5/y
9eV/aoA3bHkJ4LOQvGh5/qb7Wk2WgqbhxODf9ydP85TBoTY5QwxCbkgJqVutU6Ht
xju9w6+4MRWNYWeYFhz19FHpIyqNd7l550ardRs1ZMCCZR0sNqv+Z2tPvvAnJycO
0WgfhvCEiIW6NYThdY6U5RsGzmZjOp0XGWVXE19hwhcBt4K92NGHRb8A6PAL9zkX
m07e1RfI+MV4f09suy1j+aL5LV5CSxC6jQ4UvnpSx0FqW+qF4ZJMd3HsrholEMBr
lC234N8CHLgG/mJvfYmuTn6vCXEQAda/Y6VXdjlUwVyBlySZTROInV1WWDIWyYbn
nM/lf7pN82OYbUBaFMVlADxLBDWi2X88NyotTz0sWu92LG3aFpFFK46nymTBl+ak
bhWpDvrja9BShL24J1AB
=DNnT
-----END PGP SIGNATURE-----

--yaPAUYI/0vT2YKpA--
