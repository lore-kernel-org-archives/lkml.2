Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab1EDIVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:21:35 -0400
Received: from narfation.org ([79.140.41.39]:48166 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab1EDIV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:21:27 -0400
From: Sven Eckelmann <sven@narfation.org>
To: "David Laight" <David.Laight@aculab.com>
Subject: Re: [PATCH] atomic: add *_dec_not_zero
Date: Wed, 4 May 2011 10:21:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38-2-686; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org, linux-m32r@ml.linux-m32r.org,
        linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-cris-kernel@axis.com, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, x86@kernel.org,
        "Chris Metcalf" <cmetcalf@tilera.com>,
        "David Howells" <dhowells@redhat.com>, linux-m68k@vger.kernel.org,
        linux-am33-list@redhat.com, linux-alpha@vger.kernel.org,
        sparclinux@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
References: <AE90C24D6B3A694183C094C60CF0A2F6D8AD0D@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AD0D@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2868987.P04i5ibDgT";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201105041021.22082.sven@narfation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2868987.P04i5ibDgT
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Wednesday 04 May 2011 10:05:53 David Laight wrote:
> > Introduce an *_dec_not_zero operation.  Make this a special case of
> > *_add_unless because batman-adv uses atomic_dec_not_zero in different
> > places like re-broadcast queue or aggregation queue management. There
> > are other non-final patches which may also want to use this macro.
>=20
> Isn't there a place where a default definition of this can be
> defined? Instead of adding it separately to every architecture.

Not that I would know about such a place - and all other atomic* macro=20
definitions also suggest that there is no such place.

Kind regards,
	Sven

--nextPart2868987.P04i5ibDgT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJNwQx+AAoJEF2HCgfBJntGRUwQAKpZ3vas4MhN1cUHPC7peYuT
VyMmy/osbr9OqHAvxVB80ZjA8lwG2OjOeB5RbJFfHIcfdC/VLAyWF0o1i8jYBYLf
qlkDuM1jRBLK7NJSmHBoTIm+zKVjQJm1cJW1qjhWqDr+tmbeHReJxmHX7uewO6bH
98rXwt2tqdZk621b1Z6pZCbLZZODQwLTejS10FDs5rT4wZztimpXGQRSjdoc0ENP
k4TX9Y8Uwac6yLA9jlgXhHzAe0iu+x9l89x1euq6Uerkax2HB0Y6YpdH97/SfxpD
eHSIgOFN8+o6WWblKOSTbDJqz0kjdvi/Wcj5mfs2YpScxE1UbEhK04Q918TWScyG
ysiycLfHrmBl+zQ6hTGveXd96M85XNlYkSIQZR48e2vSHUycF8Busv7UUTF0xnmW
2hl1svdX6p3IXMEUtYDBX7iSlEtmDe+V8bG0Ftw1nJ4cqNn4Xbp3WUSQn1qUwo1H
FwbQfFOTkzy02nWJvYpARHgTKnztbgGvC2XKWY4AtAF2WRBxmBbUTtzau9VqACzH
5I/9X63DnNo+V/yTIKps03+CyXIys/QdrsN2NaP/iEUEwz/8wVyRT4HgdYQO1nTs
e7amjs4tEW+oduDnRsPbnczSwy0lOHkVPuwiPgEA8S+WRbU5miS56u+nLDB+y/kh
u3hzuBSc64RKiJMEccmv
=JUtM
-----END PGP SIGNATURE-----

--nextPart2868987.P04i5ibDgT--
