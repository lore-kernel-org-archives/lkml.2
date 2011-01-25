Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1AYSyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:54:35 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56067 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab1AYSyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 13:54:33 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Arnd Bergmann <arnd@arndb.de>, Paul Eggert <eggert@cs.ucla.edu>,
        Eric Blake <ebb9@byu.net>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Tue, 25 Jan 2011 13:52:00 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.5.5; x86_64; ; )
Cc: Roland McGrath <roland@redhat.com>, linasvepstas@gmail.com,
        Chris Metcalf <cmetcalf@tilera.com>,
        GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org,
        libc-ports@sourceware.org, linux-api@vger.kernel.org
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com> <20110125174515.C1DC2183C19@magilla.sf.frob.com> <201101251921.15184.arnd@arndb.de>
In-Reply-To: <201101251921.15184.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6083298.yfAf693vRu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201101251352.03079.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6083298.yfAf693vRu
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tuesday, January 25, 2011 13:21:14 Arnd Bergmann wrote:
> On Tuesday 25 January 2011 18:45:15 Roland McGrath wrote:
> >  I know of no reason to
> >=20
> > think that the current treatment of the empty string was ever intended =
at
> > the creation of the *at interfaces.
>=20
> I always assumed that this was done so that the *at syscalls can replace
> both the ones that take a file descriptor (e.g. fstat) and the ones that
> take a pathname (e.g. stat), which is sensible for the non-AT_FDCWD case,
> although not documented in the man pages.
>=20
> Treating the empty string special for AT_FDCWD is rather pointless, but
> at least consistent.

i dont know if the gnulib peeps are on these lists, but i think their=20
implementations of some of the *at funcs leverage the extended behavior tha=
t=20
is available under Linux.  or at least, i'm certain they'll have some insig=
ht=20
into some of these nuances.
=2Dmike

--nextPart6083298.yfAf693vRu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJNPxvSAAoJEEFjO5/oN/WBK+sQAJwq0dJKP+rv3bXDv1qlq8BJ
MGeRFiJrahps+qkmGYc0C3hd8QvCtwf/6NwkKD9SbViW+81eI2R087egwZ5djsUQ
zlJLjj3A9DLuOaDqZPA7c6Y1Hhj4kbfYhmapA1hhVGaZBKbpFbzQsm4W08XeVVDk
eqekSCRzWehf+Yrc+XrX5rOTPJDSiqlTVfoSRaBSh62vALAHZyRVsg0FzHQr1xiC
ulh0mtym8n13UdAB9CVe49Vj/DQWP1hUb63iBmbkw6JJbZRJBr5gM6KfEjbHDaAm
igDqF4grZXGjjHOSfI6Mm4FvBgyjyOkPQBOCcqbob6vgCIA9ZF1k28bCfDnhhWIW
/wl2TmbBb21WpGgytqBlZjZw/vyPoT5kK9DUdbXnk4isLkpeJPWKgyeqzoqp/s9p
kvJLT+OylPRxP7k/B18kadesAcSxFmhTqsZE2V9pnUSmegiIOPjGEsBgGroWNW7K
YluXqd+/u0AjVin2OpOnR6rpQVBGp98vKDWncSHzs3qEsCsreVyFS9/flulRncwz
oyikPcQBXm0hozOOClxY9pAdSL3KrCMli9s3eXcWrh4ZNMqws3ZCIbPZW//fjwu/
4KUJqBh2P6gCoXg+oxd4enYDnXjBPUwvIyoeLsQ5rUo+Fknb22lgytxUc2N3dqLG
Ogp+zs3CTyVFef3z3kIA
=ZvLr
-----END PGP SIGNATURE-----

--nextPart6083298.yfAf693vRu--
