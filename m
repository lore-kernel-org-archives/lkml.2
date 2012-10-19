Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab2JSLal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:30:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35317 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab2JSLak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:30:40 -0400
Date: Fri, 19 Oct 2012 22:30:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFC: sign the modules at install time
Message-Id: <20121019223029.e961fc1cc6a8bc6fb6a2552b@canb.auug.org.au>
In-Reply-To: <2201.1350645923@warthog.procyon.org.uk>
References: <20121019142147.76f67505862afe5614167428@canb.auug.org.au>
	<CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
	<87txtso9xw.fsf@rustcorp.com.au>
	<CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com>
	<871ugwny1n.fsf@rustcorp.com.au>
	<CA+55aFwTz6xadNL37H6Qb8+rWNefn0cQ0URFPfD=Ea=J54xzGg@mail.gmail.com>
	<87fw5bp858.fsf@rustcorp.com.au>
	<2201.1350645923@warthog.procyon.org.uk>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__19_Oct_2012_22_30_29_+1100_y1irRTGizTMAKnOu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Oct_2012_22_30_29_+1100_y1irRTGizTMAKnOu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Fri, 19 Oct 2012 12:25:23 +0100 David Howells <dhowells@redhat.com> wrot=
e:
>
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > So, this still generates the keys during the normal build, right?  That
> > would be a problem for build servers that have limited randomness
> > available to them, I think.
>=20
> openssl uses /dev/urandom (unlike gpg), so that's less of a problem.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__19_Oct_2012_22_30_29_+1100_y1irRTGizTMAKnOu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQgTnVAAoJEECxmPOUX5FELAkP/iRWAza7kfaChEauzHgarCvP
2fuQod9YoWq7Jg0KIllKcs+AZDORPZz64pIpG9z4VtiNKD9P+rn7icqu0qZnJsia
8zLD14k2+Bf0pm2QM0vcvWTg/HKOpy3jGb41k3PZfFzV16QLnAq4DOeXA+ZGLjyw
QGK5IMDdlS2Q/g/j8X4tt1GNnwvLPb1LMX6vMvfLi9v8MM3b5i1K4j5ETiT+F6ga
yz2OPvkWrsS8LYR6xBWOJ5G0UUuv/gBUaOEoUoatCtJ1mzTQ0e4mBn6hyOM6TSzb
7ey9GbiW+jo9eO8dy2Wbin6hgQFjonmaWnz+y8hRfTQ1nXtAeFAyKsPfh/MhInck
rv73+UNY5fUEaMWtbiCTwOqKBP/UDAc5VoEgC8wJm7qYK7tgzNQAC2aeNRmMTa17
/DL0OWZjDkNQJ1Eczf5cPLi6iQv9S67kUSU9tPsmCRRfIM6k9L3fEka43kJe12Jm
Phe5Ndz+SqbczwWLJf/utnFZiL+nybLz/bKjeNexj58u3mZBazdoaGJD1rvNJt3x
hydUrNuQqZK1Og4Fb4Sj9KiEw8Z2rF75L0qLdujcHvDiq0/HsvEjqHg5dlcEG+wD
u6wP7oz5+l5uUqHcWL6RJvzJYjAoCypSFXbR+7ZjXSOVziyjT2Iiigg+Epsik8EO
LCayWS3IN8qlzO+U3M47
=lY7z
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Oct_2012_22_30_29_+1100_y1irRTGizTMAKnOu--
