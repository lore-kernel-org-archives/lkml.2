Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779Ab2C3MZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:25:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:22434 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760391Ab2C3MZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:25:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="123590924"
Message-ID: <1333110503.5440.24.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: allow atomic updates to sychronously erase old PEB
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 30 Mar 2012 15:28:23 +0300
In-Reply-To: <alpine.DEB.2.00.1203301413080.10066@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1203291653210.912@eristoteles.iwoars.net>
	 <4F748CD6.4080704@parrot.com>
	 <alpine.DEB.2.00.1203301413080.10066@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-mLT6mqtNlrtp49xvwOi+"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mLT6mqtNlrtp49xvwOi+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-03-30 at 14:20 +0200, Joel Reardon wrote:
> Hey,
>=20
> If there's a power cut after the new version is written and the old one i=
s
> erased, then it is my understanding that while remounting UBI will detect
> that the old version is not needed and put it on the erase queue.=20

Yes.

> The
> higher layer that issued the call to update the block will have to do a
> blocking clear of the ubi erase queue when remounting after unsafely
> unmounting.

Yes. You can do this if the security is enabled, I think, using
'ubi_sync()'.

I did not have time to look at your patches, but one quick comment is
that we usually call the argument which controls whether the function
has to wait for the operation to complete or not 'sync', could you
please follow this unwritten convention as well?

--=20
Best Regards,
Artem Bityutskiy

--=-mLT6mqtNlrtp49xvwOi+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPdabnAAoJECmIfjd9wqK0ybEQAJmAvxPe6WkfwsjGF+QcNEmn
bmCKzFL7xC3BSOlh4pSADsVzQpr4ZPTfd5xMkWGRjeyEhZB0UeAtlC32j+A9EGXp
AtBACQdJHz2sRnzKBZuYXzv7zoZ+yXAdrrn1G7Qn8UZ3tmTYNZtB/blHxjfz6uL+
vS0mXO1KN0289nfecYbRt2IstgDkKvopmLNUjXN/mJAe10pB+qZyP1JJRroBpiH/
5YkkvPRZVlDF/MknGuE6Um8O766gAofE944VAVLiimZPvsPiQOp/PzaT37cvgZce
3I8Vbd//eE1w9vg4mAxvjD9yydhrUclhPjtve9RGGXraeysKyhXVEAg2528oXZTQ
JZbBVKAo/X8XgUJ2EhTX5fysaAnxS3gBvtbqQThrwmt97vgGdJp2pOtakKAAcizP
tQMinnC3kPna5URTRw5ffQykkctJBTrIvu34KuAGHxXjgllIvKj9rPSjdtHPpw67
PMrAsydIwomhY3LgDm/thHAS1IZqSePk/JbKJbZ0AlIYpzmx9NvVbqzBmMt+xpmj
z20i7FSy+UWI0Sc3JyVLKRgBxWygCgNrJPCJYGAJFM9dneCPJZAbhrkTG0gkEqJ5
OzaJa8/8EGAA9HciIi2UIIU62PZlSTKqYLi/yJobD+QiyJ/mNC/cFK39P5DgwAzA
2Mi0nWtJyqTknt9yQLQF
=AIxd
-----END PGP SIGNATURE-----

--=-mLT6mqtNlrtp49xvwOi+--

