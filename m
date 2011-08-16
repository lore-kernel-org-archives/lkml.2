Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab1HPC1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:27:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51328 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028Ab1HPC1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:27:01 -0400
Subject: Re: [Stable-review] Future of the -longterm kernel releases (i.e.
 how we pick them).
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <greg@kroah.com>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110815142142.GC11358@kroah.com>
References: <20110815041524.GA7578@kroah.com>
	 <alpine.DEB.2.02.1108150007100.24266@asgard.lang.hm>
	 <20110815142142.GC11358@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-78EEG2n3SuYfSb8k8wWW"
Date: Tue, 16 Aug 2011 03:26:56 +0100
Message-ID: <1313461616.2981.92.camel@deadeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-78EEG2n3SuYfSb8k8wWW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-08-15 at 07:21 -0700, Greg KH wrote:
> On Mon, Aug 15, 2011 at 12:21:59AM -0700, david@lang.hm wrote:
> > rather than having a hard schedule (the first kernel released after
> > July 1 each year for example I know this is not the exact proposal),
> > I think that it would be better to pick the -longterm kernel a few
> > months after it has been released (3.4 is looking very good, the
> > normal minor driver fixes in -stable, but no fundamental regressions
> > have been reported, it's the new -longerm kernel for example)
> >=20
> > doing so doesn't give the predictability that some people will want
> > in knowing that their September release will always have a fresh new
> > -longerm kernel, but I think the result would be better -longterm
> > kernels. However, to get the information about how good the kernels
> > are, I think that the -stable timeframe would need to be extended to
> > give the kernels time to settle and gather reports. I would then
> > suggest scheduling that once a year you look at the last couple
> > -stable kernels and pick one of them rather than designating the new
> > -longterm kernel ahead of time.
>=20
> Yes, that's a very good idea.  I've seen problems in the past when
> distros have made a time-based decision to pick a kernel version and
> then the problems that this can cause if it happens that a subsystem
> really had issues for that release.
>=20
> So yes, I'll take a look at the bug reports and how things are working
> out to pick the next -longterm.  I'll also take into consideration any
> companies/major users that are going to be using that release as well,
> so it greatly behooves people to talk to me about their plans (hint,
> hint...)
[...]

This might be a good discussion to have at Kernel Summit, if enough
distro people are going to be there.

The next stable release of Debian will have a feature-freeze in June
2012, so we need to make a choice some time before then.  However I know
that Ubuntu will need to make a decision rather earlier for the 12.04
LTS release.

Are any other distributions aiming to make long-term-supported releases
in 2012?

Also, in Debian we just added an 'rt' build of the kernel using the
PREEMPT_RT patches.  We don't want to use different upstream versions as
a basis for specific builds, so if we're going to include PREEMPT_RT in
a stable distribution release we would ideally want to see some interest
in maintaining this patchset on top of the longterm series.  (Hopefully
it's going to be significantly smaller by then, of course.)

Ben.


--=-78EEG2n3SuYfSb8k8wWW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATknVaue/yOyVhhEJAQo34RAAqkIGVy+rPcGFYOvbU4EQoJByZykKtT8P
lrs/WK5uXcs4UlN2OyIFjQkOAPmkyHqtrmkkFcQtMJvlP4hHBkuVfOsdF9KC2wMk
QiwHlZ0pA04E7Nz6kLBSGV4wJeLwVN94XGdzPVF3Dmk8ljtNLQ1JrRw692lBzqA7
bF3C6aVbIgXTIaiA5utk+AS7fuW+uL6Sn/KMY9rg7hSlGSJTbbAaRsnpelonLPRz
AYwkxCmi72VxwzPs1fYkqwkLhKm6PuKRxxJbNM5Hwy19rQo8e1eBesUuWOPskRgS
1C2ysqJdwvbrHwcfJI7kN/bgx1ZC4AxjGa01A168Z6BIri4dxY601RY48FwHiiUo
o3/F3A2QyiwyjXaHFDztczkaMauHf5BC3EpIEol7MC1wVKtVsEiunZRTBumdiP/Q
BM3bG1OcE5Su7+Y5OLEsOUg0OWhzSk0WIKcyg17NQbdQo2TmXwY+mNUHDL5jU7aH
jjZsspIrZjp/ahPWwXCu0XuTol82HmXohx392bkP2iuMH+XeMTa8M9wQOv6OtDJM
YRAGgVUjvHJrUDGu2Z+YeoQ0ANw0tggmauc5boJFNIwp5CH0GzKje19Zc6jEhAre
/wch9P4Z7NklomBOn4FYzXdjEiQ3m0Ogp7bL2MQITRfCd4cKR/MN4H/ZUedwLlPv
XqysZb/frAk=
=steN
-----END PGP SIGNATURE-----

--=-78EEG2n3SuYfSb8k8wWW--
