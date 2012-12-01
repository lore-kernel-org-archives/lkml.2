Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2LAN0n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 08:26:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54060 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796Ab2LAN0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 08:26:41 -0500
Date: Sat, 1 Dec 2012 13:26:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Olof Johansson <olof@lixom.net>
Cc: Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        grundler@chromium.org, naveen@chromium.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c-s3c2410: Add bus arbitration implementation
Message-ID: <20121201132632.GA17981@opensource.wolfsonmicro.com>
References: <1354165536-18529-1-git-send-email-ch.naveen@samsung.com>
 <1354165536-18529-3-git-send-email-ch.naveen@samsung.com>
 <20121129163448.GA3761@sirena.org.uk>
 <CAPnjgZ0atD3k=gT0vjgkLO_SA8DMak6SiT6nZ_2T6WFqtK0szQ@mail.gmail.com>
 <CAOesGMgE0JEHsdySpua34_kbWi1+z4n4UdW0kumiJEROi7O2pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <CAOesGMgE0JEHsdySpua34_kbWi1+z4n4UdW0kumiJEROi7O2pQ@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 29, 2012 at 10:14:58PM -0800, Olof Johansson wrote:
> On Thu, Nov 29, 2012 at 6:13 PM, Simon Glass <sjg@chromium.org> wrote:

> > It was originally done separately but I think it was felt that this
> > was overly complex. Olof can you please comment on this?

> it is indeed not controller specific per se, but we are unaware of any
> other platform/driver using it. So, it seemed reasonable to implement
> it in the driver as long as we have only one user; if another one
> comes along it's of course better to move it to the common i2c code.

> At least that was my opinion at the time. I could be convinced
> otherwise if someone else has strong opinions on the matter.

This sort of approach is half the reason SPI ended up being so fun...  I
suspect if you look hard enough you'll find that this is just the first
time someone tried to upstream such a scheme.  This is all especially
true for the DT bindings, even if the implementation is driver local for
now it'd be better to define generic bindings.

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQugVFAAoJELSic+t+oim9ehkP/R2mcq/f9+07jA+ZiI7JdiDA
FCWvfBFkb0zwCncKCC4qZhnIE9Iz/wBMxghCoJRuXM162Bpom+tswp5Uqu0jxQDD
XF5HUwPdSEd3iFJUv/s+VXGJ2jLLU9Y15SfOT+NJhxTUtp7rUc63boJA4tzVNVoa
xTmVKlPqH7CiBiFSkyvmAp9Be2La5S+9k9bPoRMKjFk9rnfDTIgdOV9WPdWltCD/
mAwmsjBdFK47l+t5xOmAMA207xc9TkIzMuaNuFAj67D3rcJ05RDfkzSjhPBScGxN
52/dV47fqhOdATB2oAbiCJ0dnMkPxKuYVpRdWpM3TInyNu+Ehl1lKG0T0QYMXXUE
xiDITevkhxF7SWyMZK6E6M9mUwJi9axSyDYQDmC4y8NegsTO9QQVkhSn3RWU9ZKa
94cTONEvRiAOHd1wuQORmEqvS8mDM7YyMNThKxhVYe/4D+D001Yl2ZPHu7Ldw0rW
ADIFyonv4IyCiq92YiymMJBRRCRJHXu9nXWChocJOKSe0gz9AFGSodsrzX8obpvz
fxKi3hN6Z0tdEzJUA0nG4EICAUct9Z2mZ0mcFJtvlw7JRcaP16PA3nHZ3hFDW/Lq
/yptAQDCxeM1B8bqiUg6xraXexmb+ke30fjsig89TMMw3yl44obAAyFTh0VAlcaY
7JFoUyqMtz+nxldhmh6N
=83z5
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
