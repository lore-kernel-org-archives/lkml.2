Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935482Ab2JaNjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:39:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57351 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756605Ab2JaNja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:39:30 -0400
Date: Wed, 31 Oct 2012 15:33:26 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: Dmytro Milinevskyy <milinevskyy@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: ncm: correct endianess conversion
Message-ID: <20121031133326.GT10998@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1349729943-28995-1-git-send-email-milinevskyy@gmail.com>
 <20121024135834.GA4368@breakpoint.cc>
 <CAOUdcc9PwMg34n_W14ctgW2qqP1P+STan6JBH3uyO+y+jWZ0FQ@mail.gmail.com>
 <20121028174829.GA3761@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w3FC1ngOohd+pYSp"
Content-Disposition: inline
In-Reply-To: <20121028174829.GA3761@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--w3FC1ngOohd+pYSp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 28, 2012 at 06:48:29PM +0100, Sebastian Andrzej Siewior wrote:
> On Sun, Oct 28, 2012 at 06:30:02PM +0100, Dmytro Milinevskyy wrote:
> > I was trying to keep 2 tabs but checkpatch didn't accept long line
> > that's why I killed extra tab.
>=20
> Then move them to the code section instead to initialize them in the
> declaration section.
>=20
> > >How does it work? Is the test on host side not strict enough?
> > The host part(cdc_ncm) does not check this field.
> > However I agree that at least on device side this should be corrected.
> Good.
>=20
> > Felipe, do you want me to send another patch or resend previous one
> > with this correction?
> If it hasn't been applied yet resend it.

I think I hasn't applied this one yet, so resending is the way to go.

--=20
balbi

--w3FC1ngOohd+pYSp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkSimAAoJEIaOsuA1yqREfJcP+wWHp1Ew9Hh9gAp0w6YC9cIq
WIADd9Am5RLnSEhoHRSXz05qjxCfRAft9RKIldTCTjBtRyuxZNQw2ys7t2Yisyg3
zhDoZNY2hpF0VtS02oIoamUErz2Z4PSlhoWvCIpi6fSsv45QIQUcyAJptQl9H5yD
UMfPeOc5ZcK9lsuNXlW07BMxEPSaSnwCXiNyZ3UBdf4MUYDe9BqnM5C2JcFUZX/q
6clga+7NrPXF4lc+MvY5qKnW9znDpWzMZuUHjr0j/qMKctLcYNitSjJbhpNZl59R
f5oEbY4nOYUtT79umSnw9bHMn8w0HZil9s+q+2eJfbr/o6Dq/h+NC1WmDObVdkdE
GO7t07A4aABnwh1LBZBSQ+DG1NqlP2et31hQEl2Vx+BkHvDLo89xr6UYtdSaEQew
52APud1ArB63UvmdCSk7TA/LoDUOV16pYY368+ytXT3dz9ANI6WmRlQLaOJDaIpp
UkO7ayM2i6EbQ2gkkxJ8zPXCSGuj+cWXYN5DKv2aMQkPOTgIB6Z+J9kiiq4OLLT2
T414S6KLkdVj14KQrEbCAgLljY4V8k2odRjuxLGnpTHadX6h0XTAsKUKwcSd0azs
u9dv7yHlDL9pP49/RI1/e9izvH2kgbxJQpqW1XW5Re8djhQbEzAvHN7npdN8Iy2m
wsv+DA804kDXsG9wg6On
=Ru8d
-----END PGP SIGNATURE-----

--w3FC1ngOohd+pYSp--
