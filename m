Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2G3AZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 20:25:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36946 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699Ab2G3AZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 20:25:31 -0400
Message-ID: <1343607917.4642.29.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 36/40] mm: vmscan: convert global reclaim to per-memcg LRU
 lists
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Date: Mon, 30 Jul 2012 01:25:17 +0100
In-Reply-To: <20120726211414.464540343@linuxfoundation.org>
References: <20120726211424.GA7709@kroah.com>
	 <20120726211411.164006056@linuxfoundation.org>
	 <20120726211414.464540343@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-maRrTs/95VqCewvNkqVq"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-maRrTs/95VqCewvNkqVq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-07-26 at 14:29 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.0-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Johannes Weiner <jweiner@redhat.com>
>=20
> commit b95a2f2d486d0d768a92879c023a03757b9c7e58 upstream - WARNING: this =
is a substitute patch.
>=20
> Stable note: Not tracked in Bugzilla. This is a partial backport of an
> 	upstream commit addressing a completely different issue
> 	that accidentally contained an important fix. The workload
> 	this patch helps was memcached when IO is started in the
> 	background. memcached should stay resident but without this patch
> 	it gets swapped. Sometimes this manifests as a drop in throughput
> 	but mostly it was observed through /proc/vmstat.
[...]
> The impact of the accidental fix is to make it harder for kswapd to force
> scan small targets by taking zone->all_unreclaimable into account. This
> patch is the closest equivalent available based on what is backported.
>=20
> ---
>  mm/vmscan.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
[...]

This is missing sign-offs.

Ben.

--=20
Ben Hutchings
It is impossible to make anything foolproof because fools are so ingenious.

--=-maRrTs/95VqCewvNkqVq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUBXUbee/yOyVhhEJAQp3jw/+K/6MNGlNpFu5zb6W8wN9Q5KlbMvuXQBs
0e3z0wyJicD4mngQI41CcPiw+gbFaiawDhnCBg6otee1aPDB4lQx56MDLGzAriR5
Pj544i7pEAffMoBiKtjBpT98P35FtgGSAnS/XzoHJREMBZwFn6kvOzPTPXgIvmMA
L+9PT/bWQ3w9CCgr0szfcBE/0jn8GXsvnAW6edvSs7dZ96WUahzloNMUvJQnar4T
q68gtrrctk8YE3I7OXZ2Jrg0Fr1a9LLCsgDqo7wZsy5wBqshVLk3pUbsbg7RHQIt
efsGhgfkz294abnPaHkG+7v+XpnPmg5Tb2vtmP3iUD6h3j8W0VjUjbDR+fHIIw2Q
3aV5WXKMhYJGTwERxtlInjTBRJlWdDP1DvGRB+hgDc+p5iZIGso+/rCtXbqN+iZ0
3pY5R42RzkdXB8gjZ0NAeVgWRI+jYsY4l7dxkYI5WSeA4XYGc6+lEpdeQvuG5KZ4
pPBLxXjLmysFAuqhWXGaKcNceVzdAJfiEcA7chZJY9/tPM/oleqfvwjUVaO0qQ+R
gU2rX7Ec0qmiNnEFtn4MQ1Ol5M7eSU8qXqIm4F0VU0ccaD85ar1VSoVqqEtfPGvI
YwZrxtU5l66jKhawuVBDjxkK/yw2GbtIvIMF8UyJ2F+apEWzI82/yHbf4+mQk7DY
tZsuF2VBBTM=
=6iHZ
-----END PGP SIGNATURE-----

--=-maRrTs/95VqCewvNkqVq--
