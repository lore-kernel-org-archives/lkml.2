Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2FSL7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:59:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39204 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab2FSL7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:59:17 -0400
Message-ID: <1340107151.6871.24.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 04/69] drm/i915: fix up ivb plane 3 pageflips
From: Ben Hutchings <ben@decadent.org.uk>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>
Date: Tue, 19 Jun 2012 12:59:11 +0100
In-Reply-To: <CAKMK7uEPNBDbBT4TEf9norZ_em9c+v89XRoFF_Yyam8pakYMOQ@mail.gmail.com>
References: <20120617175941.281333656@decadent.org.uk>
	 <20120617175941.924141588@decadent.org.uk>
	 <20120618215555.GD3263@herton-Z68MA-D2H-B3> <4FDFA760.5040403@intel.com>
	 <1340078392.6871.6.camel@deadeye.wl.decadent.org.uk>
	 <CAKMK7uEPNBDbBT4TEf9norZ_em9c+v89XRoFF_Yyam8pakYMOQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-R5VIeKPAh8x1RKVVSUnd"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-R5VIeKPAh8x1RKVVSUnd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-06-19 at 10:23 +0200, Daniel Vetter wrote:
> On Tue, Jun 19, 2012 at 5:59 AM, Ben Hutchings <ben@decadent.org.uk>
> > So should I drop this until the second patch is upstream?
>=20
> Nah, just merge it. It covers a truly impossible situation, and I've
> decided to not push Eugeni's fixup through -fixes because if that.
> Still, thanks for catching this.

OK.

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-R5VIeKPAh8x1RKVVSUnd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT+Bpj+e/yOyVhhEJAQqXFg/+MZ6I5E7HptlKmjCK8SS69hJKBInq5T3k
j5iQUfyqylz1l1T1njniemLa+Pb61cBmdGxHLwz8P9SShWVLGblxNLX+Eykndhe1
iMpyoRx5+dWGAmap/ISr321CJEm6ntr1PBk7PC2RWENB5UqsDKQZnh7lNm83foga
oOGZSKdYbSsvnOvWQGSbjaPNW3w36OO9m0wKsf4zBGEVGeeeI8svfi9PdY08DBPj
IxH7mzk0AA3K5Lz6fGI82YC7aiNwTblwDHrWIta1tIok8Cd7nTB7aLRZKgjwzEPv
nAZQhtNvC2U/CiBNeZb1yDKGWUpgedhfDVNMI1G77jeMVQRXjL9C2aTzNw5LezHO
+V+jEfNl2Tk+LzgVDQmmv4EuwzUlKXeTDocAOFkRb9RuCbcWjrS1k+ASs55UKllH
6Q6vXQSy+oDZTJ4k41brFVPzbZVUDSiqzzxZ4dDzkyKNThgkHSUXJX7fjFqSMaqA
avqbVSAkMuXrjNfZ9U3iIbiVbj1fkn2SHCWBo+fp2TqNpJi1JLB5URQmd/TrsV0k
5rMIDGhEokCWR1gulwtijOAgQBPIaouWsGWj+RWdQJIeGkiQiLWy7vLHtdhiRyfi
VPpiZNDIlx5U19wXUIP2t4ky+0d8LyW5MRJw6LfoPZwziQ3UgK30wof4vkVs+INC
klMWqBnurSE=
=rUi9
-----END PGP SIGNATURE-----

--=-R5VIeKPAh8x1RKVVSUnd--
