Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab2FRNi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 09:38:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58422 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016Ab2FRNi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:38:27 -0400
Message-ID: <1340026695.9372.16.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 60/69] usb-storage: Add 090c:1000 to unusal-devs
From: Ben Hutchings <ben@decadent.org.uk>
To: Simon Raffeiner <sturmflut@lieberbiber.de>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 18 Jun 2012 14:38:15 +0100
In-Reply-To: <20120618111403.0da5fbe6@cloud>
References: <20120617175950.030711074@decadent.org.uk>
	 <4FDEE95A.8050605@redhat.com> <20120618111403.0da5fbe6@cloud>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-6XfSF9Rkzs+MuT0qS6SG"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6XfSF9Rkzs+MuT0qS6SG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-06-18 at 11:14 +0200, Simon Raffeiner wrote:
> Hi,
>=20
> I wrote the original bug report for the Feiya QDI U2 DISK (bug 43265)
> and can confirm that the bug was introduced with kernel 3.4.
>=20
> 3.2 and 3.3 are unaffected.
[...]

Thanks both for the information; I'll drop this.

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-6XfSF9Rkzs+MuT0qS6SG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT98vR+e/yOyVhhEJAQoumBAAzvlD1w41gge4um6i94kcgJLAI/X8bQNU
8tYHd3Jb8no/L7lYsvjwPzeIfbI8UAv8jNsxkEiwNJlXJS9pSVW/19/ePWk223Zx
khkfl0gt1gnoIi2Sets17R2fjFIy1u+/sQb97ZZwbGcznyjloaFQuur7UFZlb6D7
0Y2J/44gKg1bhCm9w52dsIr/60QWiWYzoSM7FIhBON+kJXOy8P7ah+62MNNhsooq
8pcDYXAZI3xOZ0xyGSvLZZkLHKERBJIm/AqNI5ycUmk4Mn8lQNXH3n+iRlhH96QB
xtbIa87z/FFtJ7+83ekD6JqCT3FVjnCLPSFcDx6AzU9udIFL97m2tAqkYdAO/Sir
9azkpw9LOB+FRwEN7jYr8V3lw9B0HTm0t5H/xo6fH2WZgp9gbuxCCxEph2ozg4+g
Sjt0HDhPxji3HLv0X9LC0TEzNN89pnQyDBGS3SitBC/DQSLYiUr7zIiJclfSs96A
lufycAQDG5CtCJU+4YRAxisBWMAcLw1xglJD3vGzf0pzCFFLCb29IBLaitYIocWz
mraZzKxCkroj5w31BNIzVM5XM7Nuo1idnhBhvlK7cceIuptpQx+AhBI+M8HtCCqB
uCTDhOuapNL4AeirrJtkMXsXO6qYoM1YbOt65EAnjpFADtdHUTPB+ZXK3OzAHSrF
P/M2OPznsbU=
=i6Wr
-----END PGP SIGNATURE-----

--=-6XfSF9Rkzs+MuT0qS6SG--
