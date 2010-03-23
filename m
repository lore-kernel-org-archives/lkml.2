Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab0CWNVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:21:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37014 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500Ab0CWNU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:20:59 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-s390@vger.kernel.org,
       linux-sh@vger.kernel.org
In-Reply-To: <20100322224733.9cf93a0a.akpm@linux-foundation.org>
References: <1269126097.18314.111.camel@localhost>
	 <1269126340.18314.115.camel@localhost>
	 <20100322224733.9cf93a0a.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-d99/iIr57rL8zfJ8/KM1"
Date: Tue, 23 Mar 2010 13:20:40 +0000
Message-ID: <1269350440.18314.257.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 2/4] panic: Allow taint flag for warnings to be changed
 from TAINT_WARN
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-d99/iIr57rL8zfJ8/KM1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-03-22 at 22:47 -0400, Andrew Morton wrote:
> On Sat, 20 Mar 2010 23:05:40 +0000 Ben Hutchings <ben@decadent.org.uk> wr=
ote:
>=20
> > WARN() is used in some places to report firmware or hardware bugs that
> > are then worked-around.  These bugs do not affect the stability of the
> > kernel and should not set the usual TAINT_WARN flag.  To allow for
> > this, add WARN_TAINT() and WARN_TAINT_ONCE() macros that take a taint
> > flag as argument.
> >=20
> > Architectures that implement warnings using trap instructions instead
> > of calls to warn_slowpath_*() must now implement __WARN_TAINT(taint)
> > instead of __WARN().
>=20
> When you say they "must now implement", I assume that you mean that
> they _do_ now implement, and that no additional architecture work is
> needed.

Right, I believe I fixed-up all the current architectures.  There might
be more architectures out there, unmerged as yet.

Ben.

--=20
Ben Hutchings
Any smoothly functioning technology is indistinguishable from a rigged demo=
.

--=-d99/iIr57rL8zfJ8/KM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS6jAJ+e/yOyVhhEJAQJv7Q//WaB+psqYAejEQ4/OHpLiyVFSZmuopC4y
6vt4ssus/bhYkoH+j1FhWijj7Se1ybN2VgF0tVzdydORTeVaUZBwok3ZXVlCSqR1
uD2ca6YyVbL6fPYwzoYQALXIE1edYVfCzifCJgH+DQM31fpkBDtgxXp84i1Bp1jE
HgNlKP3qaHmHCGY2N2JIT9RCihKfgXEypyntGlSXnNrW4IpvxyDpGMHJufAHvQj6
YAE0S7LH1DDodYUYEl1PckmFjMil+RdhREXRAlME5TvovOlpgPPJ7IyJ6rN1O9S+
wDL1btV4L1Y+/6H0Vvy062dN0cvOw2TH+JMvzme1tn1LW9e/7Imr+RJ4fT0WJ9i4
Uo9BoiSRrXg0e/eOtYKXD0vg7nhOkeaXG8daxCz3prlPJqPEGzfUCWBlE84L6zqx
TxG0HM/5PNBHFArTgy5lMIPc2SMgD/wIUU3d3yCLjHahGiQSTTwgMI6p++57R7ny
k5trUHgN62vsNMxQ7eKGoG/v6h6qSy5MRa74IGfaxbszwIik40ZW1DOvkJB1VROi
KeTZ73yKK6yLgQEgDifcMD/cDvLG3p1o7wvCjk69K3hCXi7d68Anc9vp2DAW1rlO
9mNj72u98MzHRkO2X3WH+rmdj0EMz4gYNBxJzo0BGYnEEpCogr0nirJTGzam5MpN
xHRqjrePWG0=
=2Hjx
-----END PGP SIGNATURE-----

--=-d99/iIr57rL8zfJ8/KM1--
