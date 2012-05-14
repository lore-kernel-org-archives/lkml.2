Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab2ENKIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:08:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52510 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755684Ab2ENKIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:08:17 -0400
Date: Mon, 14 May 2012 11:08:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com, sameo@linux.intel.com,
        linus.walleij@stericsson.com
Subject: Re: [PATCH V3 2/2] gpio: add STA2X11 GPIO block
Message-ID: <20120514100813.GN31985@opensource.wolfsonmicro.com>
References: <20120514095800.GL31985@opensource.wolfsonmicro.com>
 <20120514094737.GB2189@sirena.org.uk>
 <20120511233402.43D813E0791@localhost>
 <cover.1334219873.git.rubini@gnudd.com>
 <5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
 <20120514072534.GA29871@mail.gnudd.com>
 <20120514095111.GA4972@mail.gnudd.com>
 <20120514100645.GA5712@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zl+NncWK+U5aSfTo"
Content-Disposition: inline
In-Reply-To: <20120514100645.GA5712@mail.gnudd.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zl+NncWK+U5aSfTo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2012 at 12:06:45PM +0200, Alessandro Rubini wrote:

> > If you use platform data why would you get unpredicatable numbers?

> Because I request the irq numbers from the gpio driver (now I request
> a free slot starting from 384, because previous drivers had it
> hardwired).  So if the gpio driver requests a slot starting from 0 it
> may get different values -- in general I can't now what it gets.

But this is because you're not using platform data!  If you use platform
data to tell all the drivers including the gpio driver which ranges to
use then this problem does not exist.

--Zl+NncWK+U5aSfTo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsNmGAAoJEBus8iNuMP3d2IsP/i5pGEN+KnO0yDGQpN5HY/1M
WAH89NTIknTXBRu7R7SsX9Gf9N3g2g6XaHc6Aglel0QSG7JJbJC07Z7l9szqynzf
o6BUspxONG1JdprfXwzaWr3+xmwF+QZAPtT3Jj6Qctb9z+kIRzDBIV/8anvgQ8fY
lOxCHkoLbkF07Pu74bmz/8SP74RF5WBf2VYYmVgStd+VM8NOlgWoTtAlIpVnqTtN
Cw5cS3C8eLQQKIAXCwHVPihRwJE0euQ1yMcv38h3+xvo46dltpvq9ZoTg75DWQjt
nTaUDZCWUvb4ey60nEN5Zh8iLf6UnOBYefwz9FAw245aimTtltUv8jvhR5LTurvN
zNbK2UZ/eVq8YWB6Wpr5iYhk8DFm1ksNeM9Hm00XvvqXS2fmf/uluZR+3LjzjxtV
rNavJoFhcCuVUpKVdJAX8Jj5Gr1klZwo3u8Sm2cTfqHKeZ8t/4vmnYl0OwgG52bp
kq0zdGRC7JybFYS4gt/AnyXnirS6H4HJf/Eh50P2NX9PD3NoIoTFFDlOI0JLTQ7g
ELWDVZQ2NQ9RHVAufleD+hDameQb6Dntvdc0yyZeK/W+nJP6M0PmZ7JY0+q5l6mn
HdohuIdK/7Ioqhiv6MCuDwXKwd/YoFc4b6lTBJy1Udwocu5Y/DMdVUl6JZaOUwJP
dVTEp8F4HVaJq7/NIVg8
=IJva
-----END PGP SIGNATURE-----

--Zl+NncWK+U5aSfTo--
