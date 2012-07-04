Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2GDJXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:23:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50409 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756472Ab2GDJW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:22:59 -0400
Date: Wed, 4 Jul 2012 10:22:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Russell King <linux@arm.linux.org.uk>, mturquette@ti.com,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] clkdev: Add default clkdev.h
Message-ID: <20120704092255.GA4111@opensource.wolfsonmicro.com>
References: <1341329015-28207-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CAMuHMdXzE48MCpQWjaxdrYMEwi-Cn5GR6NYrDAOAKwqiJ3m7Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <CAMuHMdXzE48MCpQWjaxdrYMEwi-Cn5GR6NYrDAOAKwqiJ3m7Yg@mail.gmail.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 04, 2012 at 10:00:50AM +0200, Geert Uytterhoeven wrote:

> Quoting Sam:
> "Any use of wildcards in include/asm-generic/Kbuild.asm is bogus."

> http://lkml.indiana.edu/hypermail/linux/kernel/1206.2/01507.html

Without actually explaining why which isn't terribly helpful :/

As far as I can tell it looks like this is for headers which may
optionally be absent but clkdev.h is a header which should never be
absent, either the architecture defines it or it uses the generic one.

As I said further up the thread having to go round ever single
architecture and get them to actually apply patches for stuff like this
is needlessly painful.

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9AsUAAoJEBus8iNuMP3dMOoP/07hHKd23hk+4gebt3Y82PdD
TL0y8CZEWpF1qn10hpNaDmWwNagYg12zr/UZb08dzH0E8APGw+rxfnGQoY+4Uunj
zL3SPUCQ9X9uGtkOfg8BDWXCjj5cYMUJ99RzGw22/4yFN3ofF3wc49Ws87vhjDH8
W4qpzehu3hELmYSNvU6PGw9Q/YQAj/fn/oHpMZzw4t4FqyHigZs/hMzXeYh88ex/
ZseXTXOaJzT4kHrLVtf22esZgumLJyZnoaFA8UkT1Lf95zEI2yv8Iofqw82lInQ4
ps1ORjs4J0xHvv9qMklDn21Ct6UcdBCKyGCZ3zszxJJwpl4H/2Gu2roNLLxOMZgL
+htnRe3rJC2xYUFGjwZsfHh32JCIHd2i9PflRxbRZ+fu87g+Xo0V6yPvwd+S9uat
KBey7kOZK+QpwG0V4rSPvACy57BHy8VQyrnT6K7Fg9SMxKDthdlaxoUEhmPy0Uy/
86k5cD6LLq/OzmEwD0IVFientTXJplQy4kcWuBQbOS3Ov7sLRJSZeQMdeRrUC76L
jUUK+s6KpBZkmQewkstxLL8ct8s2RFyb9q+25OO5bpIQTvx7DIlFJMqqNkvoh6lJ
o+1VmR1fx3LJOzEoVPvnblJiz9DEiuR9H0Jvt0rJuv+EoFqP3LM3tEMtghfBUEnd
48CN7Tzw/r07sH+44ohv
=Gp+d
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
