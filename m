Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab2JLVLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:11:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58199 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866Ab2JLVLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:11:39 -0400
Message-ID: <1350076284.4832.28.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 011/120] lib/gcd.c: prevent possible div by 0
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Davidlohr Bueso <dave@gnu.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 12 Oct 2012 22:11:24 +0100
In-Reply-To: <20121011005827.374358602@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
	 <20121011005827.374358602@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-nfAhVNS8Fx4gy7H5pqHn"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nfAhVNS8Fx4gy7H5pqHn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-10-11 at 09:59 +0900, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Davidlohr Bueso <dave@gnu.org>
>=20
> commit e96875677fb2b7cb739c5d7769824dff7260d31d upstream.
>=20
> Account for all properties when a and/or b are 0:
> gcd(0, 0) =3D 0
> gcd(a, 0) =3D a
> gcd(0, b) =3D b
>=20
> Fixes no known problems in current kernels.
[...]

I can't believe this change is harmful, but unless there are some known
problems this doesn't meet the criteria for a stable update.

Ben.

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-nfAhVNS8Fx4gy7H5pqHn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHiHfOe/yOyVhhEJAQpLOg/+J0ZsbrbfQJfct/hgBZN+DQIzVyJ0QapW
Qr9gLtK9JJ+D3/Wve0CytKSqFBxLbzYYByEVKxNS5xxcPaV/CELmbGOEc9K+TKgj
0FbTqxnLWC8BZsOhptsNoMq+LRebUXVbE3MolzOYf3jPZjGvJ33j+JfhKFEeL3S3
MlxrgHHFyKXoFLP+qqRF87iV3gGpCaiugkCsUoTRivwtq0ORKBNFk3NQMgAm3U83
/kNzXZMQeOjaGHqxDYLn5rq2vfkSlXqT+xgohWJnyQDjxsJejQRzFBOwcEPzwZfb
HP5fJfQwPvxBDHPcbQ3feVTl6laN0vk+MLqRbKsCFwvAOmwF6JDFM3m410kM3kt2
Y/Kd49pkoHsSW8+xjYaAkoI6pVqL8fOgT/8wvZwylU1IFyC2DNnS/5Knnp1zEBUw
pRY+yosdhGQ8tL1NadJhXrNfXqZnG3G8MHP1qbb1bWKxMw1lPuJafxRJBw8+fONL
AQkZExRYlhN/78U4zhl+DgxqfrUthrOuouPOuDmtC4rxzT8ik30F1BSmcBKavSd1
JrklwX0uTBCK+y6OHGLri8tJNIvzu0j3TnrresxoNl8qvNBXZCFlaVDLyuD4UAZJ
5mHxIhIPGT1Jw331B8V0oNNtnSVsKuHIB2cnzRDgHPJMlQCgxDicJeZPgNKxwlRo
gwnMMVqUNgw=
=3T2w
-----END PGP SIGNATURE-----

--=-nfAhVNS8Fx4gy7H5pqHn--
