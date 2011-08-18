Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab1HRAdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 20:33:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47830 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513Ab1HRAdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 20:33:41 -0400
Subject: Re: [Stable-review] Future of the -longterm kernel releases (i.e.
 how we pick them).
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Tim Bird <tbird20d@gmail.com>, linux-kernel@vger.kernel.org,
        stable-review@kernel.org, tim.bird@am.sony.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110817045856.GB4936@kroah.com>
References: <20110815041524.GA7578@kroah.com>
	 <CA+bK7J7_EKdQACnoJGWkd4asH+096SJ-gjEvsnjmRX6Dmc6dpA@mail.gmail.com>
	 <20110817045856.GB4936@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-DWrGbNGI8BtaoP51zaPI"
Date: Thu, 18 Aug 2011 01:33:34 +0100
Message-ID: <1313627614.2799.61.camel@deadeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DWrGbNGI8BtaoP51zaPI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-08-16 at 21:58 -0700, Greg KH wrote:
> On Tue, Aug 16, 2011 at 04:01:57PM -0700, Tim Bird wrote:
[...]
> > One specific issue I have is support for PREEMPT_RT, so that's a big
> > factor in selecting Sony kernel versions.  Thus, coordinating with the
> > RT patchset kernel versions is important to me.  Currently
> > that would mean 3.0 is a good candidate.
>=20
> 3.0 is looking like a good candidate, but we haven't seen 3.1 yet :)
[...]

I'm quite happy with 3.0 in terms of stability and features, though it's
early days yet.  It's not so good for Debian in terms of timing.  We're
not going to freeze for another 10 months, then the release will likely
be at least 6 months after that.  The earlier a kernel release we pick
with, the more hardware support needs to be backported later.  So,
extrapolating the likely kernel release dates, I think I would prefer to
use something between 3.2 and 3.4.

As for the RT patchset, I haven't seen any announcement that it will
continue to be developed against 3.0 after the release of 3.1.  Of
course, the fact that there *is* a working RT patchset for 3.0 is an
advancement over recent upstream releases.

Ben.


--=-DWrGbNGI8BtaoP51zaPI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATkxd2Oe/yOyVhhEJAQoYVBAArxT7f5tOzYm0ZDxQutSGn4U0bHeRS3St
rhl9z0pgafyhJENVyQXr+qwbHssHDUjuD0ccHjgoQR6ovwIqHQLFDzxQbXpVVFyM
nR+3X5YpccBfyUFDgbCyCOBjKxKSPVOqYct0s2CA72EeO1mA7WxrFEQRFcCJneQX
0lYCWtUiU34Iwuf9/pchmKBXvQx71juZA8sxl+nASECA0fWCSwYZYH39Rhtt4prE
c7Qw7eIS74j4RI0jeFQR22Sivxh88tLo2bpv+ikq7FfyGXdcEhqdh7SFlAObsETE
Jz6XByTdfRgJIgnAjC7nXGQmVyEOHKwCFcRu612Qn2V4PuJYGuNJlQ+DhYTRviyd
h1sBW28qljoppIvgJxLEx1V+8coYESPrQvl5T9RUK4aFsH7pLnHzuny5lp4oNPwB
MNtl3R7Rg3FIKXSazh3yhQ7xU5jjYpU2E+uvY9HXauYSllwmp0Gi6mbRRlv+lhJ0
eFp53dMgQGT8CseVQDIg+8K0uYYTxQX5Vz9SGgogulES+326H0G3unv04fxE0I2C
RHNGRSuIrkbxpalzZM0+fAdfZF86j0unI1FOLHZTHQcgxvDcJ2u8BJzaZEHg6IdY
UjoE/C96nar9KJA7RE2O0MVZ5oVFJwaRTnihkIzouf4RZo0p9j41hs+HeGJZLqvo
aeVPCQJFkko=
=52Vw
-----END PGP SIGNATURE-----

--=-DWrGbNGI8BtaoP51zaPI--
