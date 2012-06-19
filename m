Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2FSLzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:55:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39172 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752255Ab2FSLzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:55:07 -0400
Message-ID: <1340106888.6871.20.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH -stable]  ntp: Correct TAI offset during leap second
From: Ben Hutchings <ben@decadent.org.uk>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, John Stultz <johnstul@us.ibm.com>,
        stable@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Date: Tue, 19 Jun 2012 12:54:48 +0100
In-Reply-To: <20120618162854.GA3111@netboy.at.omicron.at>
References: <4FDB8563.3030805@us.ibm.com>
	 <1339944223.4942.240.camel@deadeye.wl.decadent.org.uk>
	 <20120617164751.GJ12429@burratino>
	 <20120617173456.GA3684@netboy.at.omicron.at>
	 <1340027711.9372.29.camel@deadeye.wl.decadent.org.uk>
	 <20120618162854.GA3111@netboy.at.omicron.at>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5PF9MRbXu/eRCsMTHbXO"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5PF9MRbXu/eRCsMTHbXO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-06-18 at 18:28 +0200, Richard Cochran wrote:
> On Mon, Jun 18, 2012 at 02:55:11PM +0100, Ben Hutchings wrote:
> > On Sun, 2012-06-17 at 19:34 +0200, Richard Cochran wrote:
> > > The offset should change upon entering state OOP, so something like
> > > the following (untested) patch should fix it for 3.2.9.
> > [...]
> >=20
> > It looks like this patch just changes the offset reported by adjtimex()
> > during an inserted second; is that right?
>=20
> Right, nothing really terrible will happen. The worst that I can
> imagine is that ntpd will set the new TAI offset during OOP, and then
> the kernel will add one to it, resulting in the TAI offset being off
> by one.
>=20
> But I really doubt any software makes use of this information.
>=20
> > Other than that, is 3.2.y likely to be OK?  Is there a good way to test
> > that in advance; does
> > <http://codemonkey.org.uk/2012/06/15/testing-leap-code/> look
> > reasonable?
>=20
> Well, if you want to wait all night then that is one way to do it.

I was intending to change the clock too...

> Here is a little test program I have been using:
>=20
>    https://github.com/richardcochran/leap

Thanks, that runs without incident but does show the incorrect offset
during OOP.

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-5PF9MRbXu/eRCsMTHbXO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT+BoiOe/yOyVhhEJAQqhNhAAs5j3ViySKZfYwJuegP4ESpcq8SGU04Ms
izkROGFMo0W4mEQ8sRN9apgmh+zz2fElepfLXMoHY/vfsRafVAYAqgDgNmobjcpW
757BhX492Z9fznGvYJ4ppNg4NpIhokfQ7wMb/tSQlXsWT8PPH0YmWHnub0TwndiB
wdmpZG+2clRjtFYo5ReCzrB5q/pffgCGIreHGWqW1zavVrxTbJU2eWdE1RDEDiXC
T9ewtfePHCw2j/GvUWhTPndj4ejCRIH4YLXENL7i4S7lA1P48PY4oKMVpqcueTBH
i2zNwkj1Auhv5Zp5EOxc+iZQXr67x//kibU6h30wfLIduSiWtSc7KvrxabTcVC4c
4/oCxGvEZ4P/y8iAajfg/XCW/C0naj2selBMljWPiWN+O3qYo+BRLdnKQ7OzvNmH
Ue2L/lfM8f+ToCgwOw0c7NSbp5/vZ7yStJsTL+Rw/mCNZTwY0rU0x4/aOaf9Ra+y
8Dp8qRlpauKSh8mkdJK9B5WBvLTwSVvXflf1ik/4csLgzPuKEHuuZv59DZdFAyYq
6VFVzLmD9iTHmfnlHZtBfRJD00KP758xwBKuLE+OIxWfa10bGbMj8GCOgSL4Q/mT
QeCPy+aHabqKIbVcK4htC0uO6+JOtvkusxGpgpXEz/hIiLel2Y2n1ot5SaVd8T5x
x11H3cFFkq4=
=kpSN
-----END PGP SIGNATURE-----

--=-5PF9MRbXu/eRCsMTHbXO--
